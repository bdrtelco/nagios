#!/usr/bin/perl

my $infile= shift(@ARGV);
$fecha=substr($infile,7,6);
$anio=substr($fecha,0,4);
$mes=substr($fecha,4,2);
$fech=$anio.$mes;

$indir="/etc/procs/gensla/";
$outdir="/etc/procs/gensla/";
$outf1= "sla-fec.sql";
$outf2= "cargaremotosla.sql";
$outf3= "genera_multa.sql";
$outf4= "sla-report.sql";
$outf5= "genera-caida.sql";
$outf6= "update-caida.sql";

$data_file="$indir$infile";

$outfile=  $outdir.$outf1;
$outfile2= $outdir.$outf2;
$outfile3= $outdir.$outf3;
$outfile4= $outdir.$outf4;
$outfile5= $outdir.$outf5;
$outfile6= $outdir.$outf6;

system ("rm $outfile");
print "Abriendo : $data_file";

open(INFILE, $data_file);
open(OUTFILE, ">>$outfile");


print OUTFILE "use nagios_stats;\n";

while(<INFILE>)
{
  my($line) = $_;

  chomp($line);

        my @data= split(/,/,$line);
        $host=$data[0];

        my @tmp1= split(/%/, $data[8]);
	$up = $tmp1[0];

        my @tmp2= split(/%/, $data[17]);
	$down= $tmp2[0];

        my @tmp3= split(/%/, $data[26]);
	$unreach = $tmp3[0];

        my @tmp4= split(/%/, $data[33]);
	$undet = $tmp4[0];

        	print OUTFILE "insert into nagios_stats.sladata  values ( $anio, $mes, $host, $up, $down , $unreach, $undet);\n";
	#        print "insert into nagios_stats.sladata  values ( $anio, $mes, $host, $up, $down , $unreach, $undet);\n";
}

close (INFILE);
close (OUTFILE);


open(OUTF2, ">$outfile2");
print OUTF2 "use nagios_stats;\n";
print OUTF2 "insert into nagios_stats.remoto_sla ";
print OUTF2 "SELECT ";
print OUTF2 "sl_anio, sl_mes, en_enlace, en_remoto, en_proveedor,sl_uptime, en_costo_mensual, 0, rm_prioridad, en_codigo_proveedor ";
print OUTF2 "FROM enlaces.enlace r , nagios_stats.sladata, enlaces.remoto ";
print OUTF2 "where r.en_nagios = nagios_stats.sladata.sl_host ";
print OUTF2 "and en_remoto = rm_remoto ";
print OUTF2 "and en_estado = 7 ";
print OUTF2 "and en_tipo_enlace='PRI' ";
print OUTF2 "and  sl_anio = $anio ";
print OUTF2 "and sl_mes= $mes ;\n";
close (OUTF2) ;

open(OUTF3, ">$outfile3");
print  OUTF3 "use nagios_stats;\n";
print  OUTF3 "select distinct 'update remoto_sla set rs_porc_credito =' as k1, ";
print  OUTF3 "(  select max(sp_penalizacion/100)  from slaparametro s2  where r.rs_proveedor = s2.sp_proveedor and r.rs_prioridad = s2.sp_prioridad and r.rs_uptime < s2. sp_limite_inf) as pena, ";
print  OUTF3 "'where rs_anio= ' as k2, rs_anio,";
print  OUTF3 "' and rs_mes = ' as k3, rs_mes, ";
print  OUTF3 "' and rs_enlace = ' as k0, rs_enlace, ";
print  OUTF3 "' and rs_remoto=' as k4 , rs_remoto, ";
print  OUTF3 "' and rs_proveedor  = ',  concat('''', rs_proveedor, '''') as kkk, ';' ";
print  OUTF3 "from remoto_sla r, slaparametro s1 ";
print  OUTF3 "where r.rs_proveedor = s1.sp_proveedor ";
print  OUTF3 "and r.rs_prioridad = s1.sp_prioridad ";
print  OUTF3 "and rs_uptime < s1. sp_limite_inf ";
print  OUTF3 "and rs_anio = $anio ";
print  OUTF3 "and rs_mes =  $mes  ";
print  OUTF3 "order by rs_enlace;\n ";

open(OUTF4, ">$outfile4");
print OUTF4 "select  rs_proveedor, rs_codigo_proveedor, \n"; 
print OUTF4 " rs_remoto as cod_age, rm_descripcion as nom_age,rs_prioridad, \n"; 
print OUTF4 " rs_uptime,  rs_costo_mensual,format(rs_porc_credito,2) as Porc, rs_costo_mensual * rs_porc_credito as Monto, \n"; 
print OUTF4 " (select mu_descripcion from enlaces.municipio where mu_codigo = mid(r.rm_municipio,1,2)) depto, \n"; 
print OUTF4 " (select mu_descripcion from enlaces.municipio where mu_codigo = r.rm_municipio ) as municipio \n"; 
print OUTF4 " from nagios_stats.remoto_sla, enlaces.remoto r \n"; 
print OUTF4 " where rs_remoto = rm_remoto \n "; 
print OUTF4 " and  rs_anio = $anio \n"; 
print OUTF4 " and  rs_mes = $mes  \n"; 
print OUTF4 " and rs_porc_credito > 0 "; 
print OUTF4 " order by rs_proveedor, rs_codigo_proveedor ; \n"; 
close (OUTF4) ;

open(OUTF5, ">$outfile5");
print OUTF5 "select 'insert into enlace_caida values (' as a0,\n ";
print OUTF5 "concat('\"',display_name,'\",') as a1,\n";
print OUTF5 " en_enlace,";
print OUTF5 "','  as a11,\n";
print OUTF5 "concat('',en_remoto,',') as a2,  concat('\"', en_proveedor, '\",') as a3,\n";
print OUTF5 " concat('\"', en_codigo_proveedor, '\",') as a3, \n";
print OUTF5 "concat('\"', ";
print OUTF5 "(select x.state_time from nagios.nagios_statehistory x ";
print OUTF5 " where  x.object_id = s.object_id  and  x.statehistory_id < s.statehistory_id ";
print OUTF5 " and state_change = 1 and state = 1 and last_state = 0 ";
print OUTF5 " order by x.state_time desc ";
print OUTF5 " limit 1 ";
print OUTF5 " ),";
print OUTF5 "'\",') as a42,\n";
print OUTF5 "concat('\"', state_time,  '\",') as a4,\n";
print OUTF5 "' null, null );' as a5 \n";
print OUTF5 "from nagios.nagios_statehistory s, nagios.nagios_hosts n, enlaces.enlace \n";
print OUTF5 "where s.object_id= n.host_object_id \n";
print OUTF5 " and state_change = 1 and state = 0 and last_state = 1 \n";
print OUTF5 " and year(state_time)  = $anio \n";
print OUTF5 " and month(state_time) = $mes  \n";
print OUTF5 " and en_nagios = display_name \n";
print OUTF5 " and en_estado = 7 and en_tipo_enlace = 'PRI';\n";
close(OUTF5);

#print OUTF5 "select 'insert into enlace_caida values (' as a0, \n ";
#print OUTF5 "concat('\"',display_name,'\",') as a1,\n ";
#print OUTF5 "en_enlace, \n";
#print OUTF5 "','  as a11,\n ";
#print OUTF5 "concat('',en_remoto,',') as a2,  concat('\"', en_proveedor, '\",') as a3,\n ";
#print OUTF5 "concat('\"', en_codigo_proveedor, '\",') as a3, concat('\"', state_time,  '\",') as a4,\n ";
#print OUTF5 "concat('\"', \n ";
#print OUTF5 "(select x.state_time from nagios.nagios_statehistory x \n";
#print OUTF5 " where  x.object_id = s.object_id  and    x.statehistory_id > s.statehistory_id\n ";
#print OUTF5 " and state_change = 1 and state = 0  and last_state = 1 limit 1 )\n";
#print OUTF5 ", '\", null, null );' )  as a5 \n";
#print OUTF5 "from nagios.nagios_statehistory s, nagios.nagios_hosts n, enlaces.enlace \n";
#print OUTF5 "where s.object_id= n.host_object_id \n";
#print OUTF5 "and state_change = 1 \n";
#print OUTF5 "and year(state_time)  = $anio \n ";
#print OUTF5 "and month(state_time) = $mes  \n ";
#print OUTF5 "and hour(state_time) > 5 and Hour(state_time) < 23 \n";
#print OUTF5 "and en_nagios = display_name \n";
#print OUTF5 "and en_estado = 7 and en_tipo_enlace = 'PRI' \n";
#print OUTF5 "and state = 1 and last_state = 0 \n";
#print OUTF5 "and exists ( select 1 from nagios.nagios_statehistory x  where  x.object_id = s.object_id \n";
#print OUTF5 "and x.statehistory_id > s.statehistory_id and state_change = 1  and state = 0 and  last_state = 1 ) ;\n";

open(OUTF6, ">$outfile6");
print OUTF6 "update enlace_caida \n ";
print OUTF6 "set ec_duracion = nagios.nagtime(ec_fecha_ini, ec_fecha_fin, 0), \n";
print OUTF6 "  ec_duracion_formato=nagios.nagtime(ec_fecha_ini, ec_fecha_fin, 1) \n "; 
print OUTF6 "where ec_fecha_ini > '$anio-$mes-01 00:00:00' \n ";
print OUTF6 "and year(ec_fecha_ini)=$anio \n ";
print OUTF6 "and month(ec_fecha_ini) = $mes; \n ";
close(OUTF6);

