
 select "update trans_remoto set tr_pos_ntrans = " as x, 
 @rownum:=@rownum+1 as xx1, 
 " where  tr_anio = ", y.tr_anio , " and tr_mes = ", y.tr_mes, " and tr_remoto = ", tr_remoto, ";" 
 from trans_remoto y, (SELECT @rownum:=0) r 
 where y.tr_anio = 2015 
 and y.tr_mes = 12 
 order by tr_ntrans desc, tr_monto desc,  tr_remoto asc; 
 select "update trans_remoto set tr_pos_monto = " as x, 
 @rownum:=@rownum+1 as xx1, 
 " where  tr_anio = ", y.tr_anio , " and tr_mes = ", y.tr_mes, " and tr_remoto = ", tr_remoto, ";" 
 from trans_remoto y, (SELECT @rownum:=0) r 
 where y.tr_anio = 2015 
 and y.tr_mes = 12 
 order by tr_monto desc,  tr_ntrans desc, tr_remoto asc; 
