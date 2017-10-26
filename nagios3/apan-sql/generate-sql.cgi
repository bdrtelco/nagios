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
# Source the debug-function
. ${PLUGSDIR}/debug.sh

# Generate a valid header
case $IMGTYPE in
	PNG) echo "Content-type: image/png"
	;;
	GIF) echo "Content-type: image/gif"
	;;
	GD ) echo "Content-type: image/gd"
	;;
esac
echo ""

# Get the params from the URL
SVCIDX=`echo $QUERY_STRING|cut -d "&" -f 1`
TIME=`echo $QUERY_STRING|cut -d "&" -f 2`
WIDTH=`echo $QUERY_STRING|cut -d "&" -f 3`
HEIGTH=`echo $QUERY_STRING|cut -d "&" -f 4`
#cgidebug "QS: $QUERY_STRING, Width: $WIDTH, Height: $HEIGTH"

RRDFILE=`echo "select rrdfile from apanservices where idx=$SVCIDX;"|$SQLCOMM`
UNIT=`echo "select unit from apanservices where idx=$SVCIDX;"|$SQLCOMM`
EXTRA=`echo "select extraargs from apanservices where idx=$SVCIDX;"|$SQLCOMM`
ARGIDS=`echo "select idx from apanserviceargs where apanservice=$SVCIDX order by serviceargnumber;"|$SQLCOMM`

if [ "$WIDTH" = "" ] || [ "$HEIGTH" = "" ]; then
	WIDTH=640
	HEIGTH=100
fi


#cgidebug "File: $RRDFILE, Unit: $UNIT, Argids: $ARGIDS"
N=0
ARG=""
for ARGID in $ARGIDS; do
	DSNAME=`echo "select dsname from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
	TYPE=`echo "select drawtype from apanserviceargs where idx=$ARGID;"|$SQLCOMM`
	COL=`echo "select color from apancolors where idx=$N;"|$SQLCOMM`
	#DSNAME=`echo $DS|cut -d ":" -f 1|tr "/" "-"`
	#TYPE=`echo $DS|cut -d ":" -f 2`
	ARG="$ARG DEF:var$N=$RRDFILE:$DSNAME:AVERAGE $TYPE:var${N}$COL:$DSNAME:"
	N=`expr $N + 1`
done

# Generate the image
$RRDTOOL graph - -s -$TIME -a $IMGTYPE -v $UNIT -w $WIDTH -h $HEIGTH  $EXTRA $ARG
#cgidebug "$RRDTOOL graph - -s -$TIME -a $IMGTYPE -v $UNIT -w $WIDTH -h $HEIGTH  $EXTRA $ARG"

