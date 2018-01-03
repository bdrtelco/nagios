update enlace_caida 
 set ec_duracion = nagios.nagtime(ec_fecha_ini, ec_fecha_fin, 0), 
  ec_duracion_formato=nagios.nagtime(ec_fecha_ini, ec_fecha_fin, 1) 
 where ec_fecha_ini > '2017-12-01 00:00:00' 
 and year(ec_fecha_ini)=2017 
 and month(ec_fecha_ini) = 12; 
 