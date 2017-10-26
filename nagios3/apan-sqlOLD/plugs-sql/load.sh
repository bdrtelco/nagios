# Plugin that uses nagios-statd to get load/swapuse on a UNIX-host
unix_load() {
	for ARGID in $ARGIDS; do
		CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "LOAD $HOST: $CHECK"
		VALUE=`$PLUGINSDIR/check_load ${HOSTADDRESS} $CHECK`
		RESULT=$?
		RET=`echo $VALUE|cut -d ":" -f 1`
		VAL=`echo $VALUE|cut -d ":" -f 2`
		if [ $RET -gt 0 ]; then
			RETVAL=3
			RETSTR=$VALUE
			ERR=1
			break
		fi
		RETSTR="${RETSTR}${CHECK}: $VAL, "
		VAL=`echo $VAL|tr -d " %"`
		IVAL=`echo "$VAL+0.5"|bc -l|cut -d "." -f 1`
		if [ "$IVAL" = "" ]; then
			IVAL=0
		fi
		if [ $IVAL -ge $CRIT ]; then
			RETVAL=2
		elif [ $IVAL -ge $WARN ] && [ $RETVAL -lt 2 ]; then
			RETVAL=1
		fi
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$VAL"
	done
}



nix_mem() {
	CONT=1
	for ARGID in $ARGIDS; do
		ARGNAME=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                VALUE=`$PLUGINSDIR/check_nrpe -H ${HOSTADDRESS} -c check_freemem` 
                RETVAL=$?
		VAL=`echo $VALUE | cut -d ";" -f $CONT | cut -d ":" -f 2 | cut -d "%" -f 1`
		VAL=`expr $VAL + 0`
		CONT=`expr $CONT + 1`
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$VAL"
		RETSTR="$VALUE  $DSNAME $TEMPL"
	done
}



remote_unix() {
	for ARGID in $ARGIDS; do
		CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`

                #VALUE=`$PLUGINSDIR/check_nrpe -H ${HOSTADDRESS} -t 20  -c  $CHECK` 
                VALUE=`$PLUGINSDIR/check_nrpe -H ${HOSTADDRESS} -t 20  -c  check_cpuload`
                RESULT=$?
                #RET=`echo $VALUE|cut -d ":" -f 1`
		VAL=`echo $VALUE| cut -d ":" -f 6 | cut -d "," -f 1 |cut -d " " -f 2`
                debug "check_cpuload ${HOSTADDRESS} :Ret $VALUE | CPU Total $VAL !! Retrno $RESULT" 
		
		if [ $RESULT -gt 2  ]; then
                        RETVAL=3
                        RETSTR=$VALUE
                        ERR=1
                        break
                fi
                #RETSTR="${RET}: $VAL"
                #VAL=`echo $VAL|tr -d " %"`
                #IVAL=`echo "$VAL+0.5"|bc -l|cut -d "." -f 1`
		#debug " VAlor de retorno [$VAL]  [${VAL}]  kkk  $RETSTR"
                #debug "UNIXLOAD $HOST: $CHECK  [$VAL]"
                #VAL=$RESULT

                RETSTR="CPU Total $VAL;  $VALUE"

                if [ "$VAL" = "" ]; then
                        VAL=0
                fi
                if [ $VAL -ge $CRIT ]; then
                        RETVAL=2
                elif [ $VAL -ge $WARN ] && [ $RETVAL -lt 2 ]; then
                        RETVAL=1
               fi
                TEMPL="$TEMPL:$DSNAME"
                DATA="$DATA:$VAL"
	done
	}

# This plugin uses NSClient to get cpuload/memuse from a Windows-host
win_cpu() {
	for ARGID in $ARGIDS; do
		ARGNAME=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "NT_LOAD val: $SVCIDX, $ARGID, $ARGNAME, $DSNAME"
		if [ $ARGNAME = "win_cpu" ]; then
			VALUE=`$PLUGINSDIR/check_nt -H $HOSTADDRESS -v CPULOAD -l 5,$WARN,$CRIT`
			RESULT=$?
			VAL=`echo $VALUE|grep "%"|cut  -d "%" -f 1 | cut -d "d" -f 2| tr -d " "`
		elif [ $ARGNAME = "WIN_MEMUSE" ]; then
			VALUE=`$PLUGINSDIR/check_nt -H $HOSTADDRESS -v MEMUSE -w 100 -c 100`
			RESULT=$?
			#VAL=`echo $VALUE|grep "%"|cut -d "-" -f 2|awk '{print $NF}'|tr -d "()% "`
			VAL=`echo $VALUE|grep "%"|cut  -d "%" -f 1 | cut -d "d" -f 2| tr -d " "`
		else
			RETVAL=3
			ERR=1
			RETSTR="nt_load: Unknown value $ARGNAME"
			break
		fi
		#debug "NT_LOAD after, $HOSTADDRESS: $VALUE ; Res: $RESULT , val : $VAL"
		if [ $RESULT -gt 2 ]; then
			RETVAL=3
			RETSTR="Socket Error"
			ERR=1
			break
		fi
		#RETSTR="${RETSTR}${ARGNAME}: $VAL%"   #kkk
		RETSTR="$VALUE"   #kkk

		if [ $VAL -ge $CRIT ]; then
			RETVAL=2
		elif [ $VAL -ge $WARN ] && [ $RETVAL != 2 ]; then
			RETVAL=1
		fi
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$VAL"
		N=`expr $N + 1`
	done
}
sybase_conn() {
	for ARGID in $ARGIDS; do
		CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`

		#debug "select servicearg from apanserviceargs where idx=$ARGID;"
                #debug "select dsname from apanserviceargs where idx=$ARGID;"



		VALUE=`$PLUGINSDIR/check_sybase_conn $HOSTADDRESS $XARGS $WARN $CRIT`
	        RETVAL=$?
		RETSTR="$VALUE"   
		VAL=`echo $VALUE|cut -d "=" -f 2`
		DATA="$DATA:$VAL"
		TEMPL="$TEMPL:$DSNAME"
	done
}
		
