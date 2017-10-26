#!/bin/bash
#ANIO=$1
#MES=$2

ANIO=2015
MES=12

OUTFILE="./outgendata.sql"
SALIDA="./outcambiadata.sql"
DB="enlaces"

source /etc/procs/db-conf.sh

#echo "" >$OUTFILE
#echo " select \"update trans_remoto set tr_pos_ntrans = \", " >> $OUTFILE
#echo " (select count(tr_ntrans) +1   from trans_remoto x where x.tr_anio =y .tr_anio and x.tr_mes = y.tr_mes  and y.tr_ntrans < x.tr_ntrans) as npos," >> $OUTFILE
#echo " \", tr_pos_monto = \" as d," >> $OUTFILE
#echo "(select count(tr_monto) +1   from trans_remoto x where x.tr_anio =y .tr_anio and x.tr_mes = y.tr_mes  and y.tr_monto < x.tr_monto) as nmonto," >> $OUTFILE
#echo "\"where  tr_anio = \", y.tr_anio , \" and tr_mes = \", y.tr_mes, \"and tr_remoto = \", tr_remoto, \";\"" >> $OUTFILE
#echo "from trans_remoto y" >> $OUTFILE
#echo "where y.tr_anio = $ANIO" >> $OUTFILE
#echo "and y.tr_mes = $MES" >> $OUTFILE


echo "" >$OUTFILE
echo " select \"update trans_remoto set tr_pos_ntrans = \" as x, " >> $OUTFILE
echo " @rownum:=@rownum+1 as xx1, " >> $OUTFILE
echo " \" where  tr_anio = \", y.tr_anio , \" and tr_mes = \", y.tr_mes, \" and tr_remoto = \", tr_remoto, \";\" " >> $OUTFILE
echo " from trans_remoto y, (SELECT @rownum:=0) r " >> $OUTFILE
echo " where y.tr_anio = $ANIO " >> $OUTFILE
echo " and y.tr_mes = $MES " >> $OUTFILE
echo " order by tr_ntrans desc, tr_monto desc,  tr_remoto asc; " >> $OUTFILE

echo " select \"update trans_remoto set tr_pos_monto = \" as x, " >> $OUTFILE
echo " @rownum:=@rownum+1 as xx1, " >> $OUTFILE
echo " \" where  tr_anio = \", y.tr_anio , \" and tr_mes = \", y.tr_mes, \" and tr_remoto = \", tr_remoto, \";\" " >> $OUTFILE
echo " from trans_remoto y, (SELECT @rownum:=0) r " >> $OUTFILE
echo " where y.tr_anio = $ANIO " >> $OUTFILE
echo " and y.tr_mes = $MES " >> $OUTFILE
echo " order by tr_monto desc,  tr_ntrans desc, tr_remoto asc; " >> $OUTFILE

echo " Modifica_trans.sh: Generando datos a modificar..." 
mysql -h $DBSRV -u $RUSER --password=$RPSS  --skip-column-names  -D $DB <$OUTFILE >$SALIDA
echo "Se generaron ..." 
cat $SALIDA | wc
echo ""
echo "Modificando..." 
mysql  -h $DBSRV -u $RUSER --password=$RPSS -f  -D $DB < $SALIDA
echo "Fin..." 
#rm $SALIDA $OUTFILE 

