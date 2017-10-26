#!/bin/bash
nt_net() {
	for ARGID in $ARGIDS; do
		INTERFACE=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "Net2: $INTERFACE, $DSNAME, $IF"
		RES=`$PLUGINSDIR/check_nt -H $HOST -v COUNTER -l "\Network Interface($INTERFACE)\Bytes Total/sec"`
		STATUS=$?
		if [ $STATUS -gt 0 ]; then
			RETVAL=3
			RETSTR=$RES
			ERR=1
			break
		fi
		RETSTR="${RETSTR}${IFNAME}:$RES, "
		TEMPL=`echo $TEMPL:$DSNAME`
		DATA=`echo $DATA:$RES`
	done
}

nt_smtp() {
	RETSTR="Connection OK: "
	for ARGID in $ARGIDS; do
		CNTNAME=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		#debug "SMTP $HOST: '$CNTNAME'"
		P=`echo $param|tr "£" " "`
		COUNTER="\SMTP Server(_Total)\\$CNTNAME"
		VALUE=`$PLUGINSDIR/check_nt -H $HOST -v COUNTER -l "$COUNTER"`
		RES=$?
		if [ $RES -gt 0 ]; then
			RETVAL=3
			RETSTR="$VALUE"
			ERR=1
			break
		fi
		VALUE=`echo $VALUE*60|bc`
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$VALUE"
		RETVAL=0
		RETSTR="${RETSTR}${DSNAME}:${VALUE}, "
	done
}
nt_counter() {
	RETSTR="Connection OK: "
	
	for ARGID in $ARGIDS; do
		CNTNAME=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
		VALUE=`$PLUGINSDIR/check_nt -H $HOST -v COUNTER -l "$CNTNAME"`
		RES=$?
		if [ $RES -gt 0 ]; then
			RETVAL=3
			RETSTR="$VALUE"
			ERR=1
			break
		fi
		TEMPL="$TEMPL:$DSNAME"
		DATA="$DATA:$VALUE"
		N=`expr $N + 1`
		RETVAL=0
		RETSTR="${RETSTR}${DSNAME}:${VALUE}, "
	done
}
