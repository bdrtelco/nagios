#!/bin/bash
source /etc/procs/db-conf.sh

mysql -h $DBSRV -u $RUSER --password=$RPSS  < /etc/procs/gen_stats.sql
