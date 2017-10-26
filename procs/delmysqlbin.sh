/etc/init.d/mysql stop 
rm /var/lib/mysql/mysql-bin.000* 
rm /var/lib/mysql/mysql-bin.index  
/etc/init.d/mysql start  
