use cob_datawarehouse 
go 
select "insert into enlaces.trans_remoto (tr_remoto, tr_region, tr_anio, tr_mes, tr_ntrans, tr_monto)  values (", 
ce_oficina, ",", ce_region, ",",    datepart (yy, ce_fecha ),  ",", datepart (mm, ce_fecha ),   ",",  sum(ce_numero) ntrans, ","  , 
convert(money,sum(ce_efectivo + ce_chq_propios  + ce_chq_locales  +  ce_chq_ot_plaza)) monto, ");"
from cob_datawarehouse..cj_caja_estadistico_his
where ce_oficina < 2000
and ce_fecha >= '05/01/2018'
and ce_fecha < '06/01/2018'
and ce_moneda >= 0
and ce_transaccion >= 0
and ce_operador not in ('sa', 'reentry')
group by ce_oficina, ce_region, datepart (yy, ce_fecha ), datepart (mm, ce_fecha ) 
go  
