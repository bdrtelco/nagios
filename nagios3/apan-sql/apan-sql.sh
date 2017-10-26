#!/bin/bash

# Change this if you are not installing apan in the default location
DEFSFILE=/etc/nagios3/apan-sql/apan.defs
#
# Don't change anything below...
#

# Source the configuration
. $DEFSFILE

# Source SQL configuration
. $SQLCONF

#Source the plugin-functions
for file in ${PLUGSDIR}/*.sh; do
	. $file
done

#debug "Args: $*"

#Read arguments from the command-line
PLUGIN=$1
HOST=$2
SVCNAME=$3
TIME=$4
WARN=$5
CRIT=$6
XARGS=$7

RETVAL=0
RETSTR=""

#Get configuration for this service
SVCIDX=`echo "select idx from apanservices where host='$HOST' and service='$SVCNAME';"|$SQLCOMM`
if [ "$SVCIDX" = "" ]; then
	debug "Apan could not find service '$SVCNAME' on host '$HOST'."
	echo "Apan could not find service."
	exit 3
fi
RRDFILE=`echo "select rrdfile from apanservices where idx=$SVCIDX;"|$SQLCOMM`
ARGIDS=`echo "select idx from apanserviceargs where apanservice=$SVCIDX order by serviceargnumber;"|$SQLCOMM|tr "\n" " "`

#debug "svc-ID: '$SVCIDX', Args: $ARGIDS, File: $RRDFILE"

if [ ! -w $RRDFILE ]; then
	debug "$HOST/$SVCNAME: RRD-file does not exist or is not writeable ($RRDFILE)"
	echo "RRD-file does not exist or is not writeable ($RRDFILE)"
	exit 3
fi

N=0
ERR=0
DATA="$TIME"
TEMPL=""

################################################################3
case $PLUGIN in
	disk) disk
	;;
	nt-net) nt_net
	;;
	nt_disk) nt_disk
	;;
	nt_disk2) nt_disk2
	;;
	nt_smtp) nt_smtp
	;;
	nt_load) nt_load
	;;
	load) unix_load
	;;
	unix_load) unix_load
	;;
	ping) ping
	;;
	ping_any) ping_any
	;;
	lxk_pages) lxk_pages
	;;
	snmpget) snmpget
	;;
	disk_by_snmp) disk_by_snmp
	;;
	proc_by_snmp) proc_by_snmp
	;;
	http) http
	;;
	tcp) tcp
	;;
	*)
		debug "Unknown plugin: '$PLUGIN on host '$HOST'"
		echo "Unknown Apan-plugin: $PLUGIN"
		exit 3
	;;
esac

if [ $ERR = 0 ]; then
	if [ `echo $TEMPL|cut -b 1-1` = ":" ]; then
		TEMPL=`echo $TEMPL|cut -b 2-`
	fi
	$RRDTOOL update $RRDFILE -t $TEMPL $DATA
	#debug "Inserting '$TEMPL' , '$DATA' into $RRDFILE"
else
	debug "${HOST}:${SVCNAME}, Could not insert '$TEMPL' , '$DATA' into $RRDFILE"
fi

#debug "Returning '$RETSTR' , $RETVAL"
echo $RETSTR
exit $RETVAL
