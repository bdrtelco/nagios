#!/bin/bash
#Archivo a importar
INPUT=20170710ATM.csv
while IFS=";" read A B C D
do
echo "ATM$A,"
#Reemplazar por ruta
done < $INPUT 
#>> /etc/nagios3/objects/atm.cfg
