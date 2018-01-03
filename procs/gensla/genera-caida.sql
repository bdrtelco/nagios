select 'insert into enlace_caida values (' as a0,
 concat('"',display_name,'",') as a1,
 en_enlace,','  as a11,
concat('',en_remoto,',') as a2,  concat('"', en_proveedor, '",') as a3,
 concat('"', en_codigo_proveedor, '",') as a3, 
concat('"', (select x.state_time from nagios.nagios_statehistory x  where  x.object_id = s.object_id  and  x.statehistory_id < s.statehistory_id  and state_change = 1 and state = 1 and last_state = 0  order by x.state_time desc  limit 1  ),'",') as a42,
concat('"', state_time,  '",') as a4,
' null, null );' as a5 
from nagios.nagios_statehistory s, nagios.nagios_hosts n, enlaces.enlace 
where s.object_id= n.host_object_id 
 and state_change = 1 and state = 0 and last_state = 1 
 and year(state_time)  = 2017 
 and month(state_time) = 12  
 and en_nagios = display_name 
 and en_estado = 7 and en_tipo_enlace = 'PRI';
