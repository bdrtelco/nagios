use nagios_stats;
select distinct 'update remoto_sla set rs_porc_credito =' as k1, (  select max(sp_penalizacion/100)  from slaparametro s2  where r.rs_proveedor = s2.sp_proveedor and r.rs_prioridad = s2.sp_prioridad and r.rs_uptime < s2. sp_limite_inf) as pena, 'where rs_anio= ' as k2, rs_anio,' and rs_mes = ' as k3, rs_mes, ' and rs_enlace = ' as k0, rs_enlace, ' and rs_remoto=' as k4 , rs_remoto, ' and rs_proveedor  = ',  concat('''', rs_proveedor, '''') as kkk, ';' from remoto_sla r, slaparametro s1 where r.rs_proveedor = s1.sp_proveedor and r.rs_prioridad = s1.sp_prioridad and rs_uptime < s1. sp_limite_inf and rs_anio = 2018 and rs_mes =  03  order by rs_enlace;
 