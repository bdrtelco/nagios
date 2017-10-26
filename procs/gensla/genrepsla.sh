#!/bin/bash
fecha=$1

source /etc/procs/db-conf.sh

BASEDIR="/etc/procs/gensla/"
OUTFILE="reporte-$fechaa.csv"
FILE="tmp-$fechaa.sql"
OUTREP="$BASEDIR$FILE"
OUT="$BASEDIR$OUTFILE"


echo " SELECT en_proveedor, en_remoto, en_estado, en_nagios, rm_descripcion, rm_region, en_codigo_proveedor, en_fecha_activacion, " >> $OUTREP
echo "sl_uptime, sl_downtime, sl_unreachable, sl_undetermined,  en_costo_mensual " >> $OUTREP 
echo "FROM enlaces.enlace r , nagios_stats.sladata, enlaces.remoto " >> $OUTREP 
echo "where r.en_nagios = nagios_stats.sladata.sl_host " >> $OUTREP 
echo "and en_remoto = rm_remoto " >> $OUTREP 
echo "and en_estado = 7 " >> $OUTREP 
echo "and en_tipo_enlace='PRI' " >> $OUTREP 
echo "and rm_banrural =1 " >> $OUTREP 
echo "and  sl_anio =2011 " >> $OUTREP 
echo "and sl_mes = 11; " >> $OUTREP 

mysql    -h $DBSRV -u $RUSER --password=$RPSS   <  $OUTREP  > $OUT

