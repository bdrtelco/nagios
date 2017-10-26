ftp -v -n -i  140.254.1.20  < ftp_getfile.ftp > ftplist.txt

FILE=`cat ftplist.txt | grep csv | tail -n 1 | cut -c 50-150`
DATE=`cat ftplist.txt | grep csv | tail -n 1 | cut -c 85-92`


echo "user mitel mitel2013" > ftp_latestfile.ftp
echo "pasv" >> ftp_latestfile.ftp
echo "bin" >> ftp_latestfile.ftp
echo "get $FILE lastfile.csv" >> ftp_latestfile.ftp
echo "get $FILE mitel_$DATE.csv" >> ftp_latestfile.ftp
echo "exit" >> ftp_latestfile.ftp

ftp -v -n -i  140.254.1.20  <  ftp_latestfile.ftp 

./procesa_dirPlanta.sh  lastfile.csv
rm lastfile.csv
rm ftplist.txt
rm k5.txt
rm 
