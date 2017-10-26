#!/bin/sh

# This program creates the tables in MySQL that apan needs.

# Change this if you are not installing apan in the default location
CFGFILE=/etc/nagios3/apan-sql/apan.defs

# End of config.


. $CFGFILE
. $SQLCONF


FOUND=`echo "desc apanservices;"|$SQLCOMM 2>/dev/null`
if [ "$FOUND" != "" ]; then
	echo "The table apanservices already exist."
else
	echo "Creating table 'apanservices'..."
	ERR=`echo "CREATE TABLE apanservices (
  idx int(11) NOT NULL auto_increment,
  host varchar(64) NOT NULL default '',
  service varchar(64) NOT NULL default '',
  rrdfile varchar(128) NOT NULL default '',
  label varchar(64) NOT NULL default '',
  unit varchar(64) NOT NULL default '',
  extraargs varchar(64) default NULL,
  comment varchar(255) default NULL,
  changed timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (idx));"|$SQLCOMM 2>&1`
	RES=$?

    



	if [ $RES != 0 ]; then
		echo "Database ERROR: $ERR"
		exit 1
	fi
fi

FOUND=`echo "desc apanserviceargs;"|$SQLCOMM 2>/dev/null`
if [ "$FOUND" != "" ]; then
	echo "The table apanserviceargs already exist."
else
	echo "Creating table 'apanserviceargs'..."
	ERR=`echo "CREATE TABLE apanserviceargs (
  idx int(11) NOT NULL auto_increment,
  apanservice int(11) NOT NULL default '0',
  serviceargnumber int(11) NOT NULL default '0',
  servicearg varchar(255) NOT NULL default '',
  dsname varchar(64) NOT NULL default '',
  drawtype varchar(16) NOT NULL default '',
  PRIMARY KEY  (idx));"|$SQLCOMM 2>&1`
	RES=$?
	if [ $RES != 0 ]; then
		echo "Database ERROR: $ERR"
		exit 1
	fi
fi

FOUND=`echo "desc apancolors;"|$SQLCOMM 2>/dev/null`
if [ "$FOUND" != "" ]; then
	echo "The table apancolors already exist."
else
	echo "Creating table 'apancolors'..."
	ERR=`echo "CREATE TABLE apancolors (
  idx int(11) NOT NULL default '0',
  color varchar(16) NOT NULL default '',
  PRIMARY KEY  (idx),
  UNIQUE KEY color (color),
  UNIQUE KEY idx (idx));"|$SQLCOMM 2>&1`

	RES=$?
	if [ $RES != 0 ]; then
		echo "Database ERROR: $ERR"
		exit 1
	fi
	echo "insert into apancolors values (0,'#ff0000');"|$SQLCOMM
	echo "insert into apancolors values (1,'#00ff00');"|$SQLCOMM
	echo "insert into apancolors values (2,'#0000ff');"|$SQLCOMM
	echo "insert into apancolors values (3,'#ffff00');"|$SQLCOMM
	echo "insert into apancolors values (4,'#ff00ff');"|$SQLCOMM
	echo "insert into apancolors values (5,'#00ffff');"|$SQLCOMM
	echo "insert into apancolors values (6,'#ff8080');"|$SQLCOMM
	echo "insert into apancolors values (7,'#c0c0c0');"|$SQLCOMM
	echo "insert into apancolors values (8,'#808080');"|$SQLCOMM
	echo "insert into apancolors values (9,'#404040');"|$SQLCOMM
	echo "insert into apancolors values (10,'#8080ff');"|$SQLCOMM
	echo "insert into apancolors values (11,'#80ff80');"|$SQLCOMM
fi

