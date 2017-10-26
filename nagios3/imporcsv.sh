#!/bin/bash
#Archivo a importar
INPUT=20170710ATM.csv
while IFS=";" read A B C D
do
echo "##########  ATM $A ######"
echo "		define host{"
echo "		use            agexxx		; Name of host template to use"
echo "		host_name      ATM$A"
echo "		parents        gw_agencias"
echo "		alias	       ATM$A AGE$C 	; alias"
echo "		address        $B"
echo "		contact_groups agencias"
echo "		}"
echo ""
#Reemplazar por ruta
done < $INPUT >> /etc/nagios3/objects/atm.cfg
