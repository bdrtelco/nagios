
ls -l -R --time-style="+%Y %m %d"  /srv/www/manuales/solicitudes  > k.txt
sed -i '/total/d' k.txt
sed -i '/\//d'   k.txt
sed -i '/^$/d'  k.txt


echo "Numero de Doctos Generados "
sed 's/\s\s*/ /g' k.txt | cut -d " " -f 6 | sort | uniq -c

echo "Numero de Doctos Generados 2013"
sed 's/\s\s*/ /g' k.txt | grep 2013 | cut -d " " -f 7 | sort | uniq -c
echo "Numero de Doctos Generados 2014"
sed 's/\s\s*/ /g' k.txt | grep 2014 | cut -d " " -f 7 | sort | uniq -c

echo "Total de Documentos"
cat k.txt | wc


