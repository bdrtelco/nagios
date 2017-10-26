#!/bin/bash
source /etc/procs/db-conf.sh

mysql -h $DBSRV -u $RUSER --password=$RPSS   enlaces <<!!
SELECT \"insert into re_enlace (re_oficina, re_ancho_banda, re_proveedor, re_estado) values (\" as d,  en_remoto,en_ancho_banda,en_proveedor,en_estado FROM enlace
where en_remoto < 900
and en_estado = 7
and en_tipo_enlace = 'PRI'
order by en_remoto;
quit
!!
