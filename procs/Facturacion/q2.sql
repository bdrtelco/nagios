 select rm_oficinacontable,  
 ifnull((select  rm_descripcion from  enlaces.remoto r2 where r2.rm_remoto=r. rm_oficinacontable ), ' ')  as descripcion, 
 format(sum(9873 /679 ),2) as monto_USD$ 
 from enlaces.enlace, enlaces.remoto r 
 where  en_remoto=rm_remoto 
 and en_estado = 7  and en_tipo_enlace = 'PRI'  and rm_region > 0 
 and en_proveedor in ('CLARO', 'NAVEGA', 'COLUMBUS', 'TELNOR') 
 group by rm_oficinacontable 
