#!/bin/bash

source /etc/procs/db-conf.sh

echo "\nCargando Datos hacia DB\n"
mysql -h $DBSRV -u $RUSER  --password=$RPSS -f  <  /etc/procs/gensla/sla-fec.sql

echo "\nFin Carga datos\n...\n \n. Inicia Carga de Tabla SLA-Remoto...\n"
mysql  -h $DBSRV -u $RUSER --password=$RPSS -f <  /etc/procs/gensla/cargaremotosla.sql

echo "\nGenerando Multas\n"
mysql -h $DBSRV -u $RUSER --password=$RPSS  -f --column-names=0 <  /etc/procs/gensla/genera_multa.sql > updatemulta.sql

echo "\n...\n \n. Cargando Informacion de Multas..\n Update... \n"
mysql  -h $DBSRV -u $RUSER --password=$RPSS -f  --column-names=0 --database=nagios_stats <  updatemulta.sql


#mysql  -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --delimiter=, <  /etc/procs/gensla/sla-report.sql > sla-report.csv 
echo " preprando query para generar informe" 
cat /etc/procs/gensla/sla-report.sql 


echo "\nGenerando Fork, para cargar Informe de Caidas \n"
./gencaidas.sh

