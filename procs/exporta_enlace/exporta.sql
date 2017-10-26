use enlaces

SELECT
"go insert into re_enlace (en_enlace, en_oficina, en_proveedor, en_medio, en_data, en_equipo, en_ancho_banda, en_costo, en_ifnum, en_equipo_central, en_status, en_fecha_ini, en_usuario_ini,en_prov_id) values (" as d,
en_enlace, ",",  en_remoto,",",
concat( "'", en_proveedor,"',"),
concat( "'", en_medio_trans, "', 'data', 'equipo',"),
en_ancho_banda, ",", 
en_costo_mensual, ",", 
"'1' , 'central',  1,",
concat( "'", en_fecha_activacion ,"', 'telecom',"),
concat( "'", en_codigo_proveedor, "')")
FROM enlace e where en_estado = 7;


