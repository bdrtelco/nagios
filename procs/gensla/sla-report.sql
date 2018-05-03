select  rs_proveedor, rs_codigo_proveedor, 
 rs_remoto as cod_age, rm_descripcion as nom_age,rs_prioridad, 
 rs_uptime,  rs_costo_mensual,format(rs_porc_credito,2) as Porc, rs_costo_mensual * rs_porc_credito as Monto, 
 (select mu_descripcion from enlaces.municipio where mu_codigo = mid(r.rm_municipio,1,2)) depto, 
 (select mu_descripcion from enlaces.municipio where mu_codigo = r.rm_municipio ) as municipio 
 from nagios_stats.remoto_sla, enlaces.remoto r 
 where rs_remoto = rm_remoto 
  and  rs_anio = 2018 
 and  rs_mes = 04  
 and rs_porc_credito > 0  order by rs_proveedor, rs_codigo_proveedor ; 
