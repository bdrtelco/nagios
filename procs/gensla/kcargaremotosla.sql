use nagios_stats;
insert into nagios_stats.remoto_sla SELECT sl_anio, sl_mes, en_enlace, en_remoto, en_proveedor,sl_uptime, en_costo_mensual, 0, rm_prioridad, en_codigo_proveedor FROM enlaces.enlace r , nagios_stats.sladata, enlaces.remoto where r.en_nagios = nagios_stats.sladata.sl_host and en_remoto = rm_remoto and en_estado = 7 and en_tipo_enlace='PRI' and  sl_anio = 2012 and sl_mes= 04 ;
