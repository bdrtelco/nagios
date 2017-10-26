#!/bin/bash

source /etc/procs/db-conf.sh 

cp $1  k2.txt

sed -i 's#\(.*\)#\L\1#g' k2.txt
sed -i 's#\"\([a-z0-9. ]*\)\,\([a-z0-9. ]*\)\"#\1 \2#g'  k2.txt
sed -i '1,3d' k2.txt
sed -i '/^$/d' k2.txt
sed -i 's#\"##g' k2.txt 


cat k2.txt  | cut -d "," -f 1,2,5 > k3.txt
cat k2.txt  | cut -d "," -f 2 > k5.txt
cat k3.txt  | awk -F ',' '{print  "insert into dirplanta  values ($"$2"$,$"$3"$,$"$1"$);"  }' > k4.txt
sed -i 's#\$#\"#g' k4.txt 
mv k4.txt dirplanta.sql 
rm k2.txt
rm k3.txt



echo "Borrando datos de directorio"
mysql -h $DBSRV -u $RUSER --password=$RPSS  -f --column-names=0 --database=inventario <  borradirplanta.sql
echo "Cargando Nuevo Directorio.... "
mysql  -h $DBSRV -u $RUSER --password=$RPSS -f --column-names=0 --database=inventario <  dirplanta.sql
