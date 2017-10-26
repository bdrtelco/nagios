
ping() {
	RETSTR=""
	for ARGID in $ARGIDS; do
		debug "Ping: $HOST $ARGID"
		ARG=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		RHOST=`echo $ARG|awk -F ":" '{print $2}'`
		#debug "PING: Arg: '$ARG', Rhost: '$RHOST'"
		if [ "$RHOST" = "" ]; then
			RHOST=$HOST
		else
			RETSTR="$RHOST:"
		fi
		RES=`$PLUGINSDIR/check_ping -H $RHOST -w $WARN -c $CRIT`
		STATUS=$?
		#debug "PING: $HOST, $DEST, $RHOST, $STATUS, '$RES'"
		if [ $STATUS -gt 2 ]; then
			RETVAL=3
			RETSTR="$RETSTR $RES"
			ERR=1
			break
		fi
		#RTT=`echo $RES|cut -d "," -f 2|cut -d "=" -f 2|tr -d " [a-zA-Z]"`
                RTT=`echo $RES|awk -F "=" '{print $NF}'|tr -d -c "0-9."`
		TIMEO=`echo $RES|grep "seconds"|wc -l`

		if [ $TIMEO != 0 ]; then
			ERR=1
		fi
		#debug "PING: $HOST, RTT: $RTT, TIMEO: $TIMEO, ERR: $ERR"
		#debug "Ping: $HOST, RTT: $RTT"
		RTT=`echo $RTT/1000|bc -l`
		#dsname=${NAMELIST[$N]}
		RETVAL=$STATUS
		TEMPL=`echo "${TEMPL}:$DSNAME"`
		DATA=`echo "${DATA}:$RTT"`
		N=`expr $N + 1`
	done
		RETSTR="$RETSTR $RES"
}

