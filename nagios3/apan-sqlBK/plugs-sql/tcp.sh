
tcp() {
	RETSTR=""
	for ARGID in $ARGIDS; do
		PORT=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "TCP $HOST: $PORT"
		RES=`$PLUGINSDIR/check_tcp -H $HOST -p $PORT -w $WARN -c $CRIT`
		STATUS=$?
		if [ $STATUS -gt 2 ]; then
			RETVAL=3
			RETSTR="$RETSTR $RES"
			ERR=1
			break
		fi
                RT=`echo $RES|awk -F "|" '{print $NF}'|tr -d -c "0-9."`
                RES=`echo $RES|awk -F "|" '{print $1}'`

		if [ $RETVAL -lt $STATUS ]; then
			RETVAL=$STATUS
		fi
		TEMPL=`echo "${TEMPL}:$DSNAME"`
		DATA=`echo "${DATA}:$RT"`
		RETSTR="$RETSTR $RES"
	done
}


	
