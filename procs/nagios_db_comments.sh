#!/bin/bash

source /etc/procs/db-conf.sh


mount -t cifs //10.161.200.20/backuptelecom -o username=chkpoint,password=ElAmigo.0123 /srv/nag-back/

FEC=`/bin/date -I `
OLDFEC=`/bin/date -I --date='20 days ago'`
DIR="/var/log/"
DBUSER="root"
DBPSS="y41mj00d34df00" 
FILE2="nagios-db-comment"
FILENEWSQL2=$FILE2"_"$FEC".sql"
LOG=/tmp/db_comments.log
mysqldump  -h $DBSRV --user=$RUSER --password=$RPSS  --add-drop-table --database nagios --table nagios_comments nagios_commenthistory > $DIR$FILENEWSQL2
FILENEW2=$FILE2"-"$FEC".tar.gz"
FILEOLD2=$FILE2"-"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW2 $DIR$FILENEWSQL2 > $LOG
rm -f $DIR$FILEOLD2 $DIR$FILENEWSQL2


umount //10.161.200.20/backuptelecom

#ftp -v -n -i  140.254.1.20 >> $LOG << EOF
#user linuxsrv serverlinux
#bin
#cd nagios
#put $DIR$FILENEW2 $FILENEW2
#delete $FILEOLD2
#bye
#EOF
