http() {
	for ARGID in $ARGIDS; do
		ARG=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "HTTP $HOST: $ARG, $WARN, $CRIT"
		VHOST=`echo $ARG|awk -F ":" '{print $1}'`
		PORT=`echo $ARG|awk -F ":" '{print $2}'`
		URL=`echo $ARG|awk -F ":" '{print $3}'`
		STRING=`echo $ARG|awk -F ":" '{print $4}'`
		#debug "HTTP $HOST: Vhost: '$VHOST', Port: '$PORT', Url: '$URL', String: '$STRING'"
		if [ "$PORT" = "" ]; then
			PORT=80
		fi
		if [ $PORT = 80 ]; then
			RETSTR="${RETSTR}${VHOST}:"
		else
			RETSTR="${RETSTR}${VHOST}:${PORT}:"
		fi
		if [ "$URL" != "" ]; then
			XARGS="$XARGS -u $URL"
		fi
		if [ "$STRING" != "" ]; then
			XARGS="$XARGS -s $STRING"
		fi
		VALUE=`$PLUGINSDIR/check_http -I $HOST -H $VHOST -p $PORT -w $WARN -c $CRIT $XARGS` 
		RESULT=$?
		#debug  "`date` HTTP snu, Res: $RESULT, Val: $VALUE"
		FOUND=`echo $VALUE|grep "|"|wc -l|awk '{print $NF}'`
		if [ $FOUND = 0 ]; then
			ERR=1
		fi
		TIME=`echo $VALUE|awk '{print $NF}'`
		#RESULT=2
		RES=`echo $VALUE|cut -d "|" -f 1`
		RETSTR="${RETSTR} $RES, "
		if [ $RESULT -gt $RETVAL ]; then
			RETVAL=$RESULT
		fi
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$TIME"
	done
}
