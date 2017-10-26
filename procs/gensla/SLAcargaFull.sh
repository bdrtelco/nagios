#!/bin/bash

FEC=`/bin/date -I `
MES=`/bin/date +%m`
MESANT=`/bin/date +%m --date='27 days ago'`
ANIO=`/bin/date +%Y --date='27 days ago'`
#ANIO=`/bin/date +%Y`

URL="http://127.0.0.1/nagios3/cgi-bin/avail.cgi?show_log_entries=&host=all&timeperiod=lastmonth&smon=$MES&sday=1&syear=$ANIO&shour=0&smin=0&ssec=0&emon=5&eday=4&eyear=2012&ehour=24&emin=0&esec=0&rpttimeperiod=horario-age&assumeinitialstates=yes&assumestateretention=yes&assumestatesduringnotrunning=yes&includesoftstates=no&initialassumedhoststate=0&initialassumedservicestate=0&backtrack=4&csvoutput="

FILENAME="uptime-$ANIO$MESANT.txt"

#lynx -auth=nagiosadmin:nagj00d34df00 -verbose -dump -width=1500 "$URL" > $FILENAME
lynx -auth=karl:koolaky41m -verbose -dump -width=1500 "$URL" > $FILENAME

sed '1d' $FILENAME  > $FILENAME.2
sed '/^$/d' $FILENAME.2  > $FILENAME
rm  $FILENAME.2

echo "\n Parsing  $FILENAME...\n"

`./parse-uptime.pl $FILENAME`

echo " Fin de Parsing  $FILENAME..."

echo " Archivos Generados  $FILENAME..."
echo " Procesando $FILENAME..."

`./loadsla.sh > loadsla.log`

echo " FIN $FILENAME..."


