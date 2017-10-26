#!/bin/bash
source /etc/procs/db-conf.sh

echo "1. gencaidas.sh :: Generando Informe de Caidas"
date 
mysql  -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=nagios  <  /etc/procs/gensla/genera-caida.sql > load-caida.sql

echo "2. Cargando Informacion de Multas.. Update... "
date
mysql  -h $DBSRV -u $RUSER --password=$RPSS  -f --column-names=0 --database=nagios_stats < load-caida.sql
date

echo "3. Update Informacion de Multas.. Update... "
mysql  -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=nagios_stats < update-caida.sql
date

