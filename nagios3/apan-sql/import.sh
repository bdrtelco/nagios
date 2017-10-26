#!/bin/sh

# Change this if you are not installing apan in the default location
. /etc/nagios3/apan-sql/apan.defs

# This should point to the sercvice-config-file from your old Apan-installation
CFGFILE=/etc/nagios3/objects/apan.cfg

# End of config.

echo "This script will clear the database-tables and re-populate them with information from the file"
echo $CFGFILE
printf "Do you want to continue? "
read ANSW

if [ "$ANSW" != "y" ] && [ "$ANSW" != "Y" ]; then
	echo "Aborted."
	exit

fi

. $SQLCONF

echo "truncate table apanservices;"|$SQLCOMM
echo "truncate table apanserviceargs;"|$SQLCOMM

for ROW in `cat $CFGFILE|egrep -v -e "^#"|tr " " "¤"`; do
	#echo $ROW
	N=1
	HOST=`echo $ROW|cut -d ";" -f 1`
	SVC=`echo $ROW|cut -d ";" -f 2`
	RRDFILE=`echo $ROW|cut -d ";" -f 3`
	ARGS=`echo $ROW|cut -d ";" -f 4`
	RRDARGS=`echo $ROW|cut -d ";" -f 5`
	LABEL=`echo $ROW|cut -d ";" -f 6`
	UNIT=`echo $ROW|cut -d ";" -f 7`
	EXTRA=`echo $ROW|cut -d ";" -f 8`
	FOUND=`echo "select count(*) from apanservices where host='$HOST' and service='$SVC';"|tr "¤" " "|$SQLCOMM`
	#echo "Host: $HOST, svc: $SVC, RRD: $RRDFILE, Comm: $COMM, Found: $FOUND"
	if [ $FOUND -gt 0 ]; then
		echo "The service '$SVC' on host '$HOST' is already in the database."|tr "¤" " "
	else
		echo "Inserting service '$SVC' on host '$HOST'..."|tr "¤" " "
		echo "insert into apanservices values (NULL,'$HOST','$SVC','$RRDFILE','$LABEL','$UNIT','$EXTRA','');"|tr "¤" " "|$SQLCOMM
		IDX=`echo "select idx from apanservices where host='$HOST' and service='$SVC';"|tr "¤" " "|$SQLCOMM`
		#echo "  Index: $IDX"
		for ARG in `echo $ARGS|tr "|" " "`; do
			RRDARG=`echo $RRDARGS|cut -d "¤" -f $N-$N`
			DSNAME=`echo $RRDARG|cut -d ":" -f 1`
			GTYPE=`echo $RRDARG|cut -d ":" -f 2`
			echo "        Arg $N ($IDX): $ARG, $DSNAME, $GTYPE"
			echo "insert into apanserviceargs values (NULL,$IDX,$N,'$ARG','$DSNAME','$GTYPE');"|tr "¤" " "|$SQLCOMM
			N=`expr $N + 1`
		done
	fi

done
