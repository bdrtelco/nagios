
salud_prov() {
        for ARGID in $ARGIDS; do
                CHECK=`echo "select servicearg from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
                DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
#                debug "select dsname from apanserviceargs where idx=$ARGID;|$SQLCOMM"
		debug "Xags : $XARGS, Argid: $ARGID"
		VAL=0
                VALUE=`$PLUGINSDIR/check_apan_salud_prov.sh $XARGS`
                RESULT=$?
                RETSTR=$VALUE
		debug "inside : $PLUGINSDIR/check_apan_salud_prov.sh $XARGS ; Salida >  $VALUE : $RESULT"
                VAL=`echo $VALUE|cut -d ":" -f 2`

                if [ "$VAL" = "" ]; then
                        VAL=0
                fi

                if [ $RESULT -gt 0 ]; then
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
		
		debug "salud Prov RET : $RET  #  RETVAL: $RETVAL # RETSTR: $RETSTR"

        done
}

