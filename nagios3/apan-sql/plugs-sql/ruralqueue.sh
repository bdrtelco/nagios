#!/bin/bash
ruralqueue() {
DEFSFILE=/usr/local/nagios/apan-sql/apan.defs
HORA=`date +%H`
HOR2=`expr $HORA - 1` 
VALUE=`cat /home/loguser/stats.txt | grep $HOR2-$HORA` 
echo $VALUE
DATA=`echo $VALUE|cut -d " " -f 2` 
FULL="$DATA"
DATA=`echo $VALUE|cut -d " " -f 3` 
FULL="$FULL:$DATA"
DATA=`echo $VALUE|cut -d " " -f 4` 
FULL="$FULL:$DATA"
DATA=`echo $VALUE|cut -d " " -f 5` 
FULL="$FULL:$DATA"
DATA=`echo $VALUE|cut -d " " -f 6` 
FULL="$FULL:$DATA"
DATA=`echo $VALUE|cut -d " " -f 7` 
FULL="$FULL:$DATA"
echo $FULL
rrdtool update /nagios/rrd/rural1-cobis_queue.rrd  N:$FULL 
}
