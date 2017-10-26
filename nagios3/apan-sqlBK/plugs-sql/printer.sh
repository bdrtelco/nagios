
lxk_pages() {
	RETSTR=""
	for DEV in `echo $ARGS|tr "|" " "`; do
		COMM=`echo $DEV|cut -d ":" -f 1`
		RES=`$PLUGINSDIR/check_lexmark $HOST PAPERCOUNT:$COMM`
		STATUS=$?
		if [ $STATUS -gt 0 ]; then
			RETVAL=3
			RETSTR=$RES
			ERR=1
			break
		fi
		PAGES=`echo $RES|cut -d ":" -f 2|tr -d " "`
		HPAGES=`echo "$PAGES*3600"|bc`
		dsname=${NAMELIST[$N]}
		TEMPL=`echo "${TEMPL}:$dsname"`
		DATA=`echo "${DATA}:$HPAGES"`
		N=`expr $N + 1`
	done
	if [ $RETVAL = 0 ]; then
		RETSTR="$RES"
	fi
}

	
