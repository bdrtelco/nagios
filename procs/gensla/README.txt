Para generar el SLA 


1. Correr 

	SLACargaFull.sh 

    Esto Generara el archivo uptime-anio+mes .txt        Ejemplo para uptime 2011 09 = 2011 Sep


2. Generar modificaciones a los SLA's

select distinct "update remoto_sla set rs_porc_credito =" as k1,
(  select max(sp_penalizacion)  from slaparametro s2  where r.rs_proveedor = s2.sp_proveedor and r.rs_prioridad = s2.sp_prioridad and r.rs_uptime < s2. sp_limite_inf) as pena,
"where rs_anio= " as k2, rs_anio,
" and rs_mes = " as k3, rs_mes,
" and rs_enlace = " as k0, rs_enlace,
" and rs_remoto=" as k4 , rs_remoto,
" and rs_proveedor = " as k4 , rs_proveedor
 from remoto_sla r, slaparametro s1
where r.rs_proveedor = s1.sp_proveedor
and r.rs_prioridad = s1.sp_prioridad
and rs_uptime < s1. sp_limite_inf
and rs_anio =  <anio>
and rs_mes = <mes> 
order by rs_enlace

3. Correr
	Gencaidas.sh





