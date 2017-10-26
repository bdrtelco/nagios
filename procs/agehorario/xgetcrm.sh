#!/bin/bash

ANIO=`/bin/date +"%Y"`
MESACT=`/bin/date +"%m"`
MES=`expr $MESACT - 1`

filesql="getcrmagehorario.sql"
outfile="datos.txt"
errorfile="errores.err"
dbuser="telecom"
dbpass="t3l3c0m"

print_help(){
echo ""
echo "  getcrm.sh "
echo ""
echo "	Ingresa los datos de transacciones y montos  por agencia."
echo "          Sintaxis: "
echo ""
echo "         carga_trans.sh [ <filename> <mes a operar> | <-s> ]"
echo ""
echo "         <filename> 	: Nombre del archivo que tiene los resultados del script."
echo "         <mes a operar>	: Pr default el mes anterior, ingresar solo si se va aprocesar mes muy antiguo"
echo "         <-s>       	: genera el script necesario para generar la carga de datos."
echo ""
echo "          Desarrollado por: Karl Monzon"
echo ""
}


getquery(){
`tsql -S crmsql -U $dbuser -P$dbpas -o qfh < $filesql > $outfile`
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
#	print query
	exit 0
fi
if [ "$FILENAME" == "-x" ]; then
   	getquery	
fi

if  [ "$FILENAME" ==  "" ]; then
 	print_help
        exit  0
fi

if  [ "$MANUAL" ==  "" ]; then
	echo "Procesando fecha $ANIO $MES"
else
	MES=$MANUAL
	echo "Procesando fecha $ANIO $MES"
fi

source /etc/procs/db-conf.sh

mysql -h $DBSRV -u $RUSER --password=$RPSS  -D enlaces < $FILENAME
echo "Modificando Datos...."
echo "fin... "
