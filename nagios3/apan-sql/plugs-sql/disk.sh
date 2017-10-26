# Plugin that uses nagios-stat to get disk-usage from a UNIX host.
disk() {
	RETSTR="Disk utilization: "
	for ARGID in $ARGIDS; do
		FS=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "DISK: $ARGID, FS: $FS, DS: $DSNAME."
		RES=`$PLUGINSDIR/nagios-stat -w 0 -m $FS disk $HOST`
		STATUS=$?
		if [ $STATUS -gt 2 ]; then
			RETVAL=$STATUS
			RETSTR=$RES
			ERR=1
			break
		fi
		UTIL=`echo $RES|cut -d "%" -f 1|cut -d "(" -f 2`
		if [ $UTIL -ge $CRIT ]; then
			RETVAL=2
			RETSTR=`echo "${RETSTR}${FS} is getting full ($UTIL%), "`
		elif [ $UTIL -ge $WARN ]; then
			if [ $RETVAL = 0 ]; then
				RETVAL=1
			fi
			RETSTR=`echo "${RETSTR}${FS} is getting full ($UTIL%), "`
		fi
		TEMPL=`echo "${TEMPL}:$DSNAME"`
		DATA=`echo "${DATA}:$UTIL"`
	done
	if [ $RETVAL = 0 ]; then
		RETSTR="${RETSTR}All disks OK"
	fi
}

# Plugin that uses NSClient to get disk-utilization from a Windows host
nt_disk() {
                RETSTR="Disk utilization: "
		for ARGID in $ARGIDS; do
			FS=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
			DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
			#debug "NT_DISK $HOST, $FS, $DSNAME, $WARN, $CRIT."
                        RES=`$PLUGINSDIR/check_nt -H $HOST -v USEDDISKSPACE -l $FS`
                        STATUS=$?
                        if [ $STATUS != 0 ]; then
                                RETVAL=3
                                RETSTR="$RETSTR $RES"
                                ERR=1
                                break
                        fi
                        PUTIL=`echo $RES|cut -d "%" -f 1|cut -d "(" -f 2`
                        UTIL=`echo $RES|cut -d "-" -f 3|awk '{print $2}'`
                        UTIL=`echo "$UTIL*1024"|bc -l`
                        FREE=`echo $RES|cut -d "-" -f 4|awk '{print $2}'`
                        FREE=`echo "$FREE*1024"|bc -l`

                        RETSTR="$RETSTR ${fs}: ${UTIL}Mb (${PUTIL}%) used, ${FREE}Mb free, "
                        FREE=`echo "$FREE*1024*1024"|bc -l`
                        TEMPL="$TEMPL:$DSNAME"
                        DATA="$DATA:$PUTIL"
                        FREE=`echo $FREE|cut -d "." -f 1`

                        if [ $PUTIL -ge $CRIT ]; then
                                RETVAL=2
                        elif [ $PUTIL -ge $WARN ] && [ $RETVAL != 2 ]; then
                                RETVAL=1
                        fi
                done
}

