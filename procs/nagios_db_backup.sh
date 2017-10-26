#!/bin/bash

source /etc/procs/db-conf.sh

FEC=`/bin/date -I `
OLDFEC=`/bin/date -I --date='20 days ago'`
DIR="/srv/nag-back/"


mount -t cifs //10.161.200.20/backuptelecom -o username=chkpoint,password=ElAmigo.0123 /srv/nag-back/


source /etc/procs/db-conf.sh

logname="nag-db"

LOG="$DIR$logname"".log"
LOG1="$DIR$logname""1.log"
LOG2="$DIR$logname""2.log"
LOG3="$DIR$logname""3.log"
LOG4="$DIR$logname""4.log"
LOG5="$DIR$logname""5.log"

rm $LOG5
mv $LOG4 $LOG5
mv $LOG3 $LOG4
mv $LOG2 $LOG3
mv $LOG1 $LOG2
mv $LOG  $LOG1


FILE2="nag-db-enlaces"
FILENEWSQL2=$FILE2"_"$FEC".sql"
mysqldump -h $DBSRV --user=$RUSER --password=$RPSS --complete-insert --opt --databases enlaces nagios_stats facturacion > $DIR$FILENEWSQL2
FILENEW2=$FILE2"-"$FEC".tar.gz"
FILEOLD2=$FILE2"-"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW2 $DIR$FILENEWSQL2 > $LOG
rm $DIR$FILEOLD2
rm $DIR$FILENEWSQL2

FILE3="nag-db-addressbook"
FILENEWSQL3=$FILE3"_"$FEC".sql"
mysqldump -h $DBSRV --user=$RUSER --password=$RPSS --complete-insert --opt --databases addressbook7 > $DIR$FILENEWSQL3
FILENEW3=$FILE3"-"$FEC".tar.gz"
FILEOLD3=$FILE3"-"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW3 $DIR$FILENEWSQL3 > $LOG
rm $DIR$FILEOLD3
rm $DIR$FILENEWSQL3

FILE4="nag-db-telefonia"
FILENEWSQL4=$FILE3"_"$FEC".sql"
mysqldump -h $DBSRV --user=$RUSER --password=$RPSS --complete-insert --opt --databases inventario > $DIR$FILENEWSQL4
FILENEW4=$FILE4"-"$FEC".tar.gz"
FILEOLD4=$FILE4"-"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW4 $DIR$FILENEWSQL4 > $LOG
rm $DIR$FILEOLD4
rm $DIR$FILENEWSQL4


umount //10.161.200.20/backuptelecom

#ftp -v -n -i  140.254.1.20 >>$LOG << EOF
#user linuxsrv serverlinux
#bin
#cd nagios
#put $DIR$FILENEW2 $FILENEW2
#delete $FILEOLD2
#put $DIR$FILENEW3 $FILENEW3
#delete $FILEOLD3
#put $DIR$FILENEW4 $FILENEW4
#delete $FILEOLD4
#bye
#EOF

