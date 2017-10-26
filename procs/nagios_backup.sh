#!/bin/bash

FEC=`/bin/date -I `
OLDFEC=`/bin/date -I --date='28 days ago'`
DIR="/srv/nag-back/"

mount -t cifs //10.161.200.20/backuptelecom -o username=chkpoint,password=ElAmigo.0123 /srv/nag-back/


source /etc/procs/db-conf.sh

logname="nagios-backup"

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

echo "\n BackUP $FEC \n" > $LOG 
echo "\n nagios-conf \n" >> $LOG 
FILE1="nagios_conf"
FILENEW1=$FILE1"_"$FEC".tar.gz"
FILEOLD1=$FILE1"_"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW1 /nagios/etc /nagios/libexec  /nagios/apan-sql /nagios/rrd 2>> $LOG
#rm $DIR$FILEOLD1


echo "\n nagios-db  \n" >> $LOG 
FILE2="nagios-db"
FILENEWSQL2=$FILE2"_"$FEC".sql"
mysqldump -h $DBSRV --user=$RUSER --password=$RPSS --complete-insert --opt --databases nagios > $DIR$FILENEWSQL2
FILENEW2=$FILE2"-"$FEC".tar.gz"
FILEOLD2=$FILE2"-"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW2 $DIR$FILENEWSQL2  2> $LOG
#rm $DIR$FILEOLD2
#rm  $DIR$FILENEWSQL2 

echo "\n nagios-his  \n" >> $LOG 
FILE3="nagios_his"
FILENEW3=$FILE3"_"$FEC".tar.gz"
FILEOLD3=$FILE3"_"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW3  /nagios/bin  /nagios/sbin /nagios/share /nagios/var/*.l* /nagios/var/*.?a*  /nagios/var/archive/ 2>> $LOG
#rm $DIR$FILEOLD3

echo "\n nagios-webconf \n" >> $LOG 
FILE4="nagios_webconf"
FILENEW4=$FILE4"_"$FEC".tar.gz"
FILEOLD4=$FILE4"_"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW4 /etc/apache2 /srv/var/www/html/index.html  2> $LOG
#rm $DIR$FILEOLD4

echo "\n nagios-srvconf \n" >> $LOG 
FILE5="nagios_srvconf"
FILENEW5=$FILE5"_"$FEC".tar.gz"
FILEOLD5=$FILE5"_"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW5  /etc/ssl /etc/hosts /etc/cron.d /etc/procs  2> $LOG
#tar cvfz $DIR$FILENEW5  /etc/ssl /etc/hosts /etc/cron.d /etc/procs /etc/awstats /var/lib/awstats    2> $LOG
#rm $DIR$FILEOLD5

echo "\n nagios-www\n" >> $LOG 
FILE6="nagios_www"
FILENEW6=$FILE6"_"$FEC".tar.gz"
FILEOLD6=$FILE6"_"$OLDFEC".tar.gz"
tar cvfz $DIR$FILENEW6  /srv/var/www/html/cert /srv/var/www/html/enlace /srv/var/www/html/esquemas /srv/var/www/html/Documentacion_Telecom /srv/var/www/html/manuales /srv/var/www/html/informes /srv/var/www/html/Minutas  2> $LOG
#rm $DIR$FILEOLD6


unmount //10.161.200.20/backuptelecom

#echo "\n Enviando a FTP \n" >> $LOG 
#
#ftp -v -n -i  140.254.1.20  << EOF
#user linuxsrv serverlinux
#bin
#cd nagios
#put $DIR$FILENEW1 $FILENEW1
#delete $FILEOLD1
#put $DIR$FILENEW2 $FILENEW2
#delete $FILEOLD2
#put $DIR$FILENEW3 $FILENEW3
#delete $FILEOLD3
#put $DIR$FILENEW4 $FILENEW4
#delete $FILEOLD4
#put $DIR$FILENEW5 $FILENEW5
#delete $FILEOLD5
#put $DIR$FILENEW6 $FILENEW6
#delete $FILEOLD6
#bye
#EOF
