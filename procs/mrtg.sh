#!/bin/bash

confdir=/etc/mrtg/
conffile="mrtg.list"

htmldir=/srv/www/mrtg/
outfile="index.html"

outindex="$htmldir$outfile" 

devicelist=""

for line in  $( cat $confdir$conffile | grep -v "#" )   
do
  fileconf="$confdir$line.cfg"

   chr=${line:0:1}
   case $chr in
    "#" )  # Currently we ignore commented lines
        ;;
    *   )
  	`env LANG=C /usr/bin/mrtg $fileconf`
	devicelist="$devicelist $fileconf "
        ;;
   esac
done

# Make index file
/usr/bin/indexmaker --output=$outindex $devicelist 2> /tmp/mrtg.err
