#!/bin/bash

MESACT=`/bin/date +"%m/01/%Y"`
MESANT=`/bin/date +"%m/01/%Y" --date='1 month ago'`

#MESACT=`/bin/date +"01/04/2016"`
#MESANT=`/bin/date +"01/01/2016" `


MES=`/bin/date +"%m" --date='1 month ago'`
ANIO=`/bin/date +"%Y" --date='1 month ago' `

filesql="sybsql.sql"
outfile="datos$ANIO$MES.txt"
errorfile="itesatos$ANIO$MES.err"
MYDB="10.160.130.155"
#dbuser="nagios"
#dbpassword="P@ssw0rdN4g10s"
dbuser="telecom"
dbpassword="j00d34df00"

print_help(){
echo ""
echo "  carga_trans.sh "
echo ""
echo "	Ingresa los datos de transacciones y montos  por agencia."
echo "          Sintaxis: "
echo ""
echo "         carga_trans.sh [ <filename> <mes a operar> | <-s> ]"
echo ""
echo "         <filename> 	: Nombre del archivo que tiene los resultados del script."
echo "         <mes a operar>	: Pr default el mes anterior, ingresar solo si se va aprocesar mes muy antiguo"
echo "         <-s>       	: genera el script necesario para generar la carga de datos."
echo "         <-x>       	: Hace todo,  genera, carga y sube.."
echo ""
echo "          Desarrollado por: Karl Monzon"
echo ""
}


printquery (){
echo ""
echo "select \"insert into enlace.trans_remoto (tr_remoto, tr_region, tr_anio, tr_mes, tr_ntrans, tr_monto)  values (\", "
echo "ce_oficina, \",\", ce_region, \",\",    datepart (yy, ce_fecha ),  \",\", datepart (mm, ce_fecha ),   \",\",  sum(ce_numero) ntrans, \",\"  , "
echo "convert(real,sum(ce_efectivo + ce_chq_propios  + ce_chq_locales  +  ce_chq_ot_plaza)) monto, \");\""
echo "from cob_datawarehouse..cj_caja_estadistico_his"
echo "where ce_oficina < 2000"
echo "and ce_fecha >= '$MESANT'"
echo "and ce_fecha < '$MESACT'"
echo "and ce_moneda >= 0"
echo "and ce_transaccion >= 0"
echo "and ce_operador not in ('sa', 'reentry')"
echo "group by ce_oficina, ce_region, datepart (yy, ce_fecha ), datepart (mm, ce_fecha ) "
echo ""

}


genquery(){
query=""
echo "use cob_datawarehouse " > $filesql
echo "go " >> $filesql
echo "select \"insert into enlaces.trans_remoto (tr_remoto, tr_region, tr_anio, tr_mes, tr_ntrans, tr_monto)  values (\", " >> $filesql
echo "ce_oficina, \",\", ce_region, \",\",    datepart (yy, ce_fecha ),  \",\", datepart (mm, ce_fecha ),   \",\",  sum(ce_numero) ntrans, \",\"  , " >> $filesql
echo "convert(money,sum(ce_efectivo + ce_chq_propios  + ce_chq_locales  +  ce_chq_ot_plaza)) monto, \");\"" >> $filesql 
echo "from cob_datawarehouse..cj_caja_estadistico_his"  >> $filesql 
echo "where ce_oficina < 2000"  >> $filesql 
echo "and ce_fecha >= '$MESANT'"  >> $filesql 
echo "and ce_fecha < '$MESACT'"  >> $filesql 
echo "and ce_moneda >= 0"  >> $filesql 
echo "and ce_transaccion >= 0"  >> $filesql
echo "and ce_operador not in ('sa', 'reentry')"  >> $filesql
echo "group by ce_oficina, ce_region, datepart (yy, ce_fecha ), datepart (mm, ce_fecha ) "  >> $filesql
echo "go  "  >> $filesql
#tsql -S sybaseprod -U $dbuser -P$dbpassword -o qfh < $filesql > $outfile
#echo " tsql -S sybaseprod -U $dbuser -P$dbpassword -o qfh < $filesql > $outfile ::: to execute"
tsql -S 10.161.206.17:4100 -U $dbuser -P$dbpassword -o qfh < $filesql > $outfile
echo " tsql -S 10.161.206.17:4100 -U $dbuser -P$dbpassword -o qfh < $filesql > $outfile ::: to execute"

FILENAME=$outfile
echo "se genero $FILENAME"

}

if [ "$#" -lt 1 ]; then
        print_help
        exit  0
fi

FILENAME=$1
MANUAL=$2

if [ "$FILENAME" == "-s" ]; then
	printquery
	exit 0
fi
if [ "$FILENAME" == "-x" ]; then
   	genquery	
fi

if  [ "$FILENAME" ==  "" ]; then
 	print_help
        exit  0
fi

if  [ "$MANUAL" ==  "" ]; then
	echo "Procesando fecha $ANIO $MES"
else
	MES=$MANUAL
	ANIO=2015
	echo "Procesando fecha $ANIO $MES"
fi

source /etc/procs/db-conf.sh

mysql -h $DBSRV -u $RUSER --password=$RPSS -f  -D enlaces < $FILENAME 


echo "Modificando Datos...."
./modifica_trans.sh $ANIO $MES
echo "fin... "
