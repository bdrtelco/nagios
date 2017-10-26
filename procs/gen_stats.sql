use nagios_stats;

insert nagios_stats.enlace_stats (es_proveedor, es_fecha, es_estado, es_tipo_enlace, es_tot_enlace, es_tot_mensual)
select en_proveedor, curdate(), en_estado, en_tipo_enlace, count(en_enlace),  sum(en_costo_mensual)
from  enlaces.enlace
where en_estado <>  10 
group by en_proveedor, en_estado, en_tipo_enlace;
