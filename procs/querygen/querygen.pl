#!/usr/bin/perl

open archi,"archivo";
open archi2,"archivo2";
open archi3,">archivo3";

$i=0;
while ($linea = <archi>)
{
	@texto1[$i]="# Service definition\n";
	@texto1[$i+1]="       define service{\n";
	@texto1[$i+2]="               use                             generic-service         ; Name of service template to use\n";
	@texto1[$i+3]="               service_description             " . $linea;
	@texto1[$i+4]="               host_name                       monitor_telecom\n";
	@texto1[$i+5]="               is_volatile                     0 \n";
	@texto1[$i+6]="               check_period                    horario-age\n";
	@texto1[$i+7]="               max_check_attempts              3\n";
	@texto1[$i+8]="               normal_check_interval           5\n";
	@texto1[$i+9]="               retry_check_interval            2\n";
	@texto1[$i+10]="               contact_groups                  telecom\n";
	@texto1[$i+11]="               notification_interval           20\n";
	@texto1[$i+12]="               notification_period             horario-age\n";
	@texto1[$i+13]="               notification_options            c,r\n";
	@texto1[$i+14]="               notifications_enabled           0       ; Service notifications are enabled\n";
	@texto1[$i+15]="               check_command                   check_nrpe!" . $linea;
	@texto1[$i+16]="               }\n";
	@texto1[$i+17]="\n";
	$i=$i+18;
	}

print archi3 @texto1;
