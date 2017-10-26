#!/usr/bin/perl
#
# Check Mitel Script for Nagios
#
# Written By Jon Smith <smithj@thelazysysadmin.net>
#
# Ver 0.1 - Initial Version


use strict;

use Net::SNMP;

my %alarmStates = (
        1       => 'OK',
        2       => 'MINOR',
        3       => 'MAJOR',
        4       => 'CRITICAL'
);

my %ERRORS = (
        'OK'            => 0,
        'WARNING'       => 1,
        'CRITICAL'      => 2,
        'UNKNOWN'       => 3,
        'DEPENDENT'     => 4
);

if (!(@ARGV > 0)) {
	printf("\nERROR: No Command Line Options Specified\n\n");
	printf("Usage: ./check_mitel.pl hostname [snmp community: Defaults to \"public\"] [snmp port: Defaults to \"161\"]\n\n");
	exit $ERRORS{'UNKNOWN'};
}

my $HOST = shift;
my $COMMUNITY = shift || 'public';
my $PORT = shift || 161;

my ($session, $error) = Net::SNMP->session(
	-hostname	=> $HOST,
	-community	=> $COMMUNITY,
	-port		=> $PORT
);

if (!defined($session)) {
	printf("ERROR: %s\n", $error);
	exit $ERRORS{'UNKNOWN'};
}

my $mitelAlarmState = '1.3.6.1.4.1.1027.4.1.1.2.2.1.0';

my $result = $session->get_request(
	-varbindlist	=> [$mitelAlarmState]
);

if (!defined($result)) {
	printf("ERROR: %s\n", $session->error);
	$session->close;
	exit $ERRORS{'UNKNOWN'};	
}

my $alarmState = $result->{$mitelAlarmState};

if ($alarmState > 1) {
	my $mitelAlarmCategories = '1.3.6.1.4.1.1027.4.1.1.2.2.4.1.8';
	
	$result = $session->get_table($mitelAlarmCategories);
	my %results = %{$result};
	$error = $session->error;

	if ($error) {
		printf("ERROR: %s\n", $error);
		$session->close;
		exit $ERRORS{'UNKNOWN'};
	}
	
	my $errorString = '';
	while (my($key, $value) = each(%results)) {
		$errorString = $errorString . $value .',';
	}
	$errorString = substr($errorString, 0, length($errorString)-1);
	
	if ($alarmState == 2) {
		printf("WARNING - Minor Alarm on %s: %s\n", $session->hostname, $errorString);
		$session->close;
		exit $ERRORS{'WARNING'};
	} elsif ($alarmState == 3) {
		printf("CRITICAL - Major Alarm on %s: %s\n", $session->hostname, $errorString);
		$session->close;
		exit $ERRORS{'CRITICAL'};
	} elsif ($alarmState == 4) {
		printf("CRITICAL - Critical Alarm on %s: %s\n", $session->hostname, $errorString);
		$session->close;
		exit $ERRORS{'CRITICAL'};
	} else {
		printf("UNKNOWN STATE\n");
		$session->close;
		exit $ERRORS{'UNKNOWN'};
	}
} else {
	printf("OK - No Alarms on %s\n", $session->hostname);
	$session->close;
	exit $ERRORS{'OK'};
}

$session->close;
exit $ERRORS{'UNKNOWN'};

