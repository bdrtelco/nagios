#!/bin/bash
cp /etc/sysconfig/network/routes /etc/procs/routes/rutas-start.txt
#sudo route -n > /etc/procs/routes/rutas-mem.txt
/sbin/route -n > /etc/procs/routes/rutas-mem.txt
cd /etc/procs/routes
/etc/procs/routes/check_routes.pl
