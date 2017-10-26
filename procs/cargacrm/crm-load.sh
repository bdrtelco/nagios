
CRMDIR="/etc/procs/cargacrm/"
CrmFile="data-crm.txt"
TrunkFile="trunk.sql"
RemotogenFile="genremoto.sql"
RemotocarFile="cargaremoto.sql"
sqlcrm2nag="gencrm2nag.sql"
crm2nag="crm2nag.sql"

source /etc/procs/db-conf.sh

# /usr/local/etc/freetds.conf

tsql  -S crmsql -U telecom -P 3GHRtJQN < gencrm.sql  > $CrmFile 

sed -i 's/"//g' $CrmFile 
sed -i "s/'//g" $CrmFile 
sed -i 's/#%/"/g' $CrmFile 
sed -i 's///g' $CrmFile 
sed -i '1,5d'   $CrmFile 
sed -i '/affected/d' $CrmFile
sed -i '/5> 6>/d' $CrmFile 
sed -i '/1> 2>/d' $CrmFile 
sed -i '/charset/d' $CrmFile 
sed -i '/UTF/d' $CrmFile 

#dos2unix $CrmFile
echo "1: Borrando Datos Previo a  Carga de Tabla CRM .."
mysql -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$TrunkFile

echo " 2: Ccargando Datos Inicia Carga de Tabla CRM..."
mysql -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$CrmFile

echo " 3:"
mysql -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$RemotogenFile > $CRMDIR$RemotocarFile

echo " 4:"
mysql -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$RemotocarFile

#echo "5: modificando Codigos de Anexos" 
#mysql  -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$sqlcrm2nag> $CRMDIR$crm2nag

#echo " 6:"
#mysql  -h $DBSRV -u $RUSER --password=$RPSS  --column-names=0 --database=enlaces < $CRMDIR$crm2nag

