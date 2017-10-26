mailqueue() {
        for ARGID in $ARGIDS; do
                CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                VALUE=`$PLUGINSDIR/check_nrpe -H ${HOSTADDRESS} -c check_mailq`
                RESULT=$?
                RETSTR=$VALUE


		debug "Mailqueue RET : $RET  ## RETSTR: $RETSTR"


                VALUE=`echo $VALUE|cut -d "|" -f 2`
                VAL=`echo $VALUE|cut -d ";" -f 1`
                WARN=`echo $VALUE|cut -d ";" -f 2`
                CRIT=`echo $VALUE|cut -d ";" -f 3`
                VAL=`echo $VAL|cut -d "=" -f 2`

                if [ "$VAL" = "" ]; then
                        VAL=0
                fi

                if [ $RET -gt 0 ]; then
                        RETVAL=3
                        RETSTR=$VALUE
                        ERR=1
                        break
                fi
                RETVAL=0

 		if [ $VAL -ge $CRIT ]; then
                        RETVAL=2
                elif [ $VAL -ge $WARN ] && [ $RETVAL -lt 2 ]; then
                        RETVAL=1
                fi

                TEMPL="$TEMPL:$DSNAME"
                DATA="$DATA:$VAL"
		
		debug "Mailqueue RET : $RET  #  RETVAL: $RETVAL # RETSTR: $RETSTR"

        done
}


