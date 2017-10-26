# Plugin that uses nagios-statd to get load/swapuse on a UNIX-host
unix_load() {
	for ARGID in $ARGIDS; do
	#for check in `echo $ARGS|tr " " "£"|tr "|" " "`; do
		CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "LOAD $HOST: $CHECK"
		VALUE=`$PLUGINSDIR/check_unix_load ${HOST} $CHECK`
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

# This plugin uses NSClient to get cpuload/memuse from a Windows-host
nt_load() {
	for ARGID in $ARGIDS; do
		ARGNAME=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "NT_LOAD: $SVCIDX, $ARGID, $ARGNAME, $DSNAME"
		if [ $ARGNAME = "CPULOAD" ]; then
			VALUE=`$PLUGINSDIR/check_nt -H $HOST -v CPULOAD -l 10,100,100`
			RESULT=$?
			VAL=`echo $VALUE|grep "%"|awk '{print $NF}'|cut -d "%" -f 1|tr -d " "`
		elif [ $ARGNAME = "MEMUSE" ]; then
			VALUE=`$PLUGINSDIR/check_nt -H $HOST -v MEMUSE -w 100 -c 100`
			RESULT=$?
			VAL=`echo $VALUE|grep "%"|cut -d "-" -f 2|awk '{print $NF}'|tr -d "()% "`
		else
			RETVAL=3
			ERR=1
			RETSTR="nt_load: Unknown value $ARGNAME"
			break
		fi
		#debug "NT_LOAD, $HOST: $VALUE"
		if [ $RESULT -gt 0 ]; then
			RETVAL=3
			RETSTR="Socket Error"
			ERR=1
			break
		fi
		RETSTR="${RETSTR}${ARGNAME}: $VAL%, "
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


