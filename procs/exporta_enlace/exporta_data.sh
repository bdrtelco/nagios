#!/bin/bash
source /etc/procs/db-conf.sh

mysql -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < exporta.sql > enlaces2syb.sql

sed -i '/NULL/d' enlaces2syb.sql

