 select count(1) as xx  from enlaces.enlace, enlaces.remoto 
 where  en_remoto=rm_remoto 
 and en_estado = 7  and en_tipo_enlace = "PRI"  and rm_region > 0  
 and en_proveedor in ("CLARO", "NAVEGA", "COLUMBUS", "TELNOR") 
