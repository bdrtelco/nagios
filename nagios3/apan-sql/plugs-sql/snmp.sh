# This plugin gets an object via SNMP and stores it in the RRD-file
snmpget() {
	RETSTR="SNMP OK: "
	for ARGID in $ARGIDS; do
		ARG=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "SNMP, $HOST: $ARG, $DSNAME"
		#debug "SNMP: $ARG"
		N=`expr $N + 1`
		COMM=`echo $ARG|cut -d ":" -f 1`
		OID=`echo $ARG|cut -d ":" -f 2`
		VALUE=`$PLUGINSDIR/check_snmp -H $HOST -C $COMM -o $OID`
		STATUS=$?
		COUNTER=`echo $VALUE|awk '{print $NF}'`
		if [ $STATUS -gt 0 ]; then
			RETVAL=2
			RETSTR=`echo "$VALUE"|head -1`
			ERR=1
			break
		fi
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$COUNTER"
		RETVAL=0
		RETSTR="${RETSTR}${DSNAME}:${COUNTER}, "
		ERR=0
	done
}

#This plugin checks disk-usage via SNMP
disk_by_snmp() {

	RETSTR="Disk usage:"
	for ARGID in $ARGIDS; do
		DISK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "SNMPDISK: $ARGID, Disk: $DISK"
		COMM=`echo $DISK|cut -d ":" -f 1`
		IDX=`echo $DISK|cut -d ":" -f 2`
		CHKIDX=`echo $IDX|tr -d "[0-9]"`
		if [ "$CHKIDX" != "" ]; then
			# Get the drives index
			INDEX=`/usr/bin/snmpwalk -t 10 -m none -O n -c $COMM $HOST .1.3.6.1.2.1.25.2.3.1.3 2>/dev/null|egrep -e " \"${IDX}"|awk '{print $1}'|tr "." " "|awk '{print $NF}'|head -1`
			#debug "DISK: $HOST, Letter: $IDX, Idx: $INDEX"
		else
			INDEX=$IDX
			#debug "DISK: $HOST, Idx: $INDEX"
		fi
		# Get the allocation units...
		UNIT=`$PLUGINSDIR/check_snmp -t 10 -H $HOST -C $COMM -o .1.3.6.1.2.1.25.2.3.1.4.$INDEX`
		RES=$?
		#If all is good so far, get the total size...
		if [ $RES = 0 ]; then
			SIZE=`$PLUGINSDIR/check_snmp -t 10 -H $HOST -C $COMM -o .1.3.6.1.2.1.25.2.3.1.5.$INDEX`
			RES=$?
			#Everything should be working. Get the used space...
			if [ $RES = 0 ]; then
				USED=`$PLUGINSDIR/check_snmp -t 10 -H $HOST -C $COMM -o .1.3.6.1.2.1.25.2.3.1.6.$INDEX`
	        		RES=$?
			fi
		fi
	#Bail out if anything went wrong...
	if [ $RES != 0 ]; then
		RETSTR="$RETSTR SNMP problem. No data received from host."
		RETVAL=2
		ERR=1
	else
	#Else start the calculations...
	#Parse the arguments...
	UNIT=`echo $UNIT|cut -d "-" -f 2|awk '{print $1}'`
	SIZE=`echo $SIZE|awk '{print $NF}'`
	USED=`echo $USED|awk '{print $NF}'`

#Convert used and fre space to kB, MB and GB.
	FREE=`echo "$SIZE $USED - p"|dc`
	BFREE=`echo "$FREE $UNIT * p"|dc`
	KFREE=`echo "$BFREE 1024 / p"|dc`
	MFREE=`echo "$BFREE 1048576 / p"|dc`
	GFREE=`echo "$BFREE 1073741824 / p"|dc`
	BUSED=`echo "$USED $UNIT * p"|dc`
        KUSED=`echo "$BUSED 1024 / p"|dc`
        MUSED=`echo "$BUSED 1048576 / p"|dc`
        GUSED=`echo "$BUSED 1073741824 / p"|dc`

#Calculate percentage free
	PROC=`echo "100*($USED/$SIZE)"|bc -l`
	TEMPL="$TEMPL:$DSNAME"
	DATA="$DATA:$PROC"
	ERR=0
	PROC=`echo "$PROC+0.5"|bc -l|cut -d "." -f 1`
	if [ "$PROC" = "" ]; then
		PROC=0
	fi
#Print free space in the apropriate format.
        if [ $KFREE -lt 5000 ] ; then
                RETSTR="$RETSTR ${DSNAME}: $KFREE kB free,"
        elif [ $MFREE -lt 5000 ]; then
                RETSTR="$RETSTR ${DSNAME}: $MFREE MB free,"
        else
                RETSTR="$RETSTR ${DSNAME}: $GFREE GB free,"
        fi

#Print used space in the apropriate format.
        if [ $KUSED -lt 5000 ] ; then
                RETSTR="$RETSTR $KUSED kB (${PROC}%) used."
        elif [ $MFREE -lt 5000 ]; then
                RETSTR="$RETSTR $MUSED MB (${PROC}%) used."
        else
                RETSTR="$RETSTR $GUSED GB (${PROC}%) used."
        fi

#Check warning and critical levels
	if [ $PROC -gt $CRIT ]; then
		RETVAL=2
	elif [ $PROC -gt $WARN ] && [ $RETVAL = 0 ]; then
		RETVAL=1
	fi
fi
done

}

#This plugin checks if a process of a given name is running and if the
# size is below the treshold-level.
proc_by_snmp() {
        RETSTR=""
	for ARGID in $ARGIDS; do
		PROC=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		COMM=`echo $PROC|cut -d ":" -f 1`
		PNAME=`echo $PROC|cut -d ":" -f 2`
		CHKMEM=`echo $PROC|tr -c -d ":"|wc -c|awk '{print $NF}'`
		WMEM=`echo $PROC|awk -F ":" '{print $3'}|tr -c -d "[0-9]"`
	
		#debug "SPROC,$HOST: Proc: '$PROC', Comm: $COMM, Name: $PNAME, Chkmem: $CHKMEM, '$WMEM'"
                VALUE=`$PLUGINSDIR/check_proc_by_snmp $HOST $COMM $PNAME $WMEM`
                STATUS=$?
		if [ "$WMEM" != "" ]; then
			COUNTER=`echo $VALUE|awk '{print $NF}'|tr -c -d "[0-9]"`
			#debug "`date` SPROC,$HOST: DC-name: $NAME, Cnt: $COUNTER"
			if [ "$COUNTER" != "" ]; then
				COUNTER=`echo "$COUNTER*1024"|bc`
				TEMPL="$TEMPL:$DSNAME"
				DATA="$DATA:$COUNTER"
			else
				ERR=1
			fi
		fi

		#debug "SPROC,$HOST: $RETVAL, $STATUS, $VALUE"

		if [ $STATUS != 0 ]; then
			RETVAL=$STATUS
		fi
                RETSTR="${RETSTR}${VALUE} "
        done
}


