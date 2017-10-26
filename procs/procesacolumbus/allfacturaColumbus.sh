#!bash 

source /etc/procs/db-conf.sh

cp $1 columbustemp.txt


dataf=$1

f1="columbustemp.txt"

sed -i 's/"//g' $f1
sed -i "s/'//g" $f1
sed -i "s/,//g" $f1
sed -i "s/^ *//;s/ *$//;s/ \{1,\}/ /g" $f1
sed -i '/Valor(Q)/d' $f1
sed -i '/Servicio Direcci/d' $f1
sed -i '/Enlace Serv/d' $f1
sed -i '/FIN DETALLE DE CARGOS/d' $f1

cat $f1 | grep "DETALLE DE FACTURA" | cut -d " " -f 1,2,3,4 |  uniq > columbus.txt
cat $f1 | grep "ENLACE DIGITAL TELERED"   |uniq  	>>  columbus1.txt
cat $f1 | grep "DETALLE DE ENLACES"   | uniq     	>> columbus1.txt
cat $f1 | grep "TOTALES" | cut -d " " -f 1,10| uniq 	>> columbus1.txt
cat $f1 | grep "CARGO MENSUAL"  	            > columbus.txt

numfact=`cat columbus1.txt | grep "DETALLE DE FACTURA" | cut -d " " -f 4`

#anio="${dataf:5:4}"
#mes="${dataf:9:2}" 
anio=$2
mes=$3 

echo "$numfact" 

./procesafile.pl $anio $mes $numfact


mysql -h $DBSRV -u $RUSER  --password=$RPSS --column-names=0 -f  --database=facturacion < loadcolumbus.sql 

