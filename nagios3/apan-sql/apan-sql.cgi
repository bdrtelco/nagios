#!/bin/sh
#
# Change this if you are not installing apan in the default location
DEFSFILE=/etc/nagios3/apan-sql/apan.defs
#
# Don't change anything below...
#

# Source the configuration
. $DEFSFILE
. $SQLCONF
. ${PLUGSDIR}/debug.sh
# Get the params from the called URL
HOST=`echo $QUERY_STRING|cut -d "&" -f 1|cut -d "=" -f 2`
SERVICE=`echo $QUERY_STRING|cut -d "&" -f 2|cut -d "=" -f 2`
PVERS=`echo $QUERY_STRING|cut -d "&" -f 3`
SVCNAME=`echo $SERVICE|sed -e 's/%20/ /'`


#Get some parameters for this host/service from the database
SVCIDX=`echo "select idx from apanservices where host='$HOST' and service='$SVCNAME';"|$SQLCOMM`
LABEL=`echo "select label from apanservices where idx=$SVCIDX;"|$SQLCOMM`
RRDFILE=`echo "select rrdfile from apanservices where idx=$SVCIDX;"|$SQLCOMM`
MDATE=`date +"%a, %d %b %Y %H:%M:%S %Z"`
#Genereta a header
echo "Cache-Control: no-store"
echo "Pragma: no-cache"
echo "Refresh: 90"
echo "Last-Modified: $MDATE"
echo "Expires: Thu, 01 Jan 1970 00:00:00 GMT"
echo "Content-type: text/html"
echo ""

	
echo "<HTML><HEAD><TITLE>$LABEL for host $HOST</TITLE>"

echo "<LINK REL='stylesheet' TYPE='text/css' HREF='/nagios3/stylesheets/status.css'></head><BODY>"
#cgidebug "QS: $QUERY_STRING, $SVCIDX, Label: $LABEL, File: $RRDFILE"
if [ "$SVCIDX" = "" ]; then
	cgidebug "Cant find service '$SERVICE' on host '$HOST'"
	echo "<H3>Unknown host or service: $HOST / $SERVICE</H3>"
	echo "<A HREF=javascript:history.go(-1)>Back</A>"
	echo "</BODY></HTML>"
	exit 
fi
if [ ! -r $RRDFILE ]; then
	cgidebug "RRD-file does not exist or is not readable ($RRDFILE)"
	echo "<H3>RRD-file does not exist or is not readable</H3>"
	echo "<PRE>($RRDFILE).</PRE>"
	echo "<A HREF=javascript:history.go(-1)>Back</A>"
	echo "</BODY></HTML>"
	exit
fi
N=0
if [ "$PVERS" != "1" ]; then
	echo "<TABLE CLASS='infoBox' BORDER=1 CELLSPACING=0 CELLPADDING=0>"
	echo "<TR><TD CLASS='infoBox'>"
	echo "<DIV CLASS='infoBoxTitle'>Apan-graphs</DIV>"
	echo "Genereated by Apan - <A HREF='http://apan.sf.net' TARGET=_new CLASS='homepageURL'>apan.sf.net</A><BR>"
	echo "Last Updated: $MDATE<BR>"
	echo "Updated every 90 seconds<br>"
	echo "Nagios&reg; - <A HREF='http://www.nagios.org' TARGET='_new' CLASS='homepageURL'>www.nagios.org</A><BR>"
	echo "Logged in as <i>$REMOTE_USER</i><BR>"
	echo "</TD></TR>"
	echo "</TABLE>"
	echo "<A HREF=javascript:history.go(-1)>Back</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	echo "<A HREF=/nagios3/cgi-bin/apan-sql.cgi?${QUERY_STRING}&1 TARGET=_blank>Print</A>"
fi
echo "<H2>$LABEL ($SVCNAME) for host $HOST</H2>"
if [ "$PVERS" = "1" ]; then
	#LASTSTAT=`egrep -e "SERVICE;$HOST;$SVCNAME" /usr/local/nagios/var/status.log`
	LASTSTAT=`egrep -e "SERVICE STATE; $HOST;$SVCNAME" /srv/var/log/nagios3/nagios.log`
	LASTMESS=`echo $LASTSTAT|cut -d ";" -f 32-`
	echo "<B>$LASTMESS</B><BR>"
fi

#Draw 'compressed' graphs if this is for printing

	if [ "$PVERS" = "1" ]; then
		WIDTH=500;HEIGTH=75
		echo "Statistics for the last 10 minutes:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&600&$WIDTH&$HEIGTH><BR>"
		echo "Statistics for the last hour:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&3600&$WIDTH&$HEIGTH><BR>"
		echo "Statistics for the last 24 hours:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&86400&$WIDTH&$HEIGTH><BR>"
		echo "Statistics for the last week:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&604800&$WIDTH&$HEIGTH><BR>"
		echo "Statistics for the last Month:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&2851200&$WIDTH&$HEIGTH><BR>"
		echo "Statistics for the last Year:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&31557600&$WIDTH&$HEIGTH><BR>"
	else
		echo "Statistics for the last 10 minutes:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&600><BR>"
		echo "Statistics for the last hour:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&3600><BR>"
		echo "Statistics for the last 24 hours:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&86400><BR>"
		echo "Statistics for the last week:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&604800><BR>"
		echo "Statistics for the last Month:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&2851200><BR>"
		echo "Statistics for the last Year:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&31557600><BR>"
		echo "Statistics for the last 5 Year:<BR>"
		echo "<IMG SRC=generate-sql.cgi?$SVCIDX&157788000><BR>"
	fi
if [ "$PVERS" = "1" ]; then
	echo "<B>Created by APAN, apan.sf.net</B>"
else
	echo "<A HREF=javascript:history.go(-1)>Back</A><BR><BR>"
	echo "<H4>Created by APAN, <A HREF='http://apan.sf.net'>apan.sf.net </A></H4>"
fi
echo "</BODY></HTML>"
