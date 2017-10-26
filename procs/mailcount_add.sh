#!/bin/bash

source /etc/procs/db-conf.sh


rm /var/log/mail.sql

echo "use nagios_stats;" >  /var/log/mail.sql
cat /home/website/*.sql >> /var/log/mail.sql

mysql -h $DBSRV -u $RUSER --password=$RPSS  </var/log/mail.sql
 
