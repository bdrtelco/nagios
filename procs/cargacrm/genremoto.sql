select
'insert into crmremoto ' as x1  ,
'(crm_remoto , crm_reg , crm_descripcion , crm_dir, crm_tel , crm_agw_ini , crm_agw_fin, ' as xx21,
' crm_ags_ini , crm_ags_fin , crm_agd_ini ,' as xx2  ,
'crm_agd_fin , crm_vtw_ini , crm_vtw_fin , crm_vts_ini , crm_vts_fin , crm_vtd_ini ,' as xx23,
'crm_vtd_fin , crm_atw_ini , crm_atw_fin , crm_ats_ini , crm_ats_fin ,' as xx3  ,
'crm_atd_ini , crm_atd_fin , crm_got_age , crm_got_vent, crm_got_aut , crm_got_atm ) ' as xx4  ,
' values ('  as xx5 ,
 rm_remoto as x,
', ' as x2,
rm_region as reg,
concat(', "', rtrim (rm_descripcion) , '", ') as agen,
concat('"' , rtrim(rm_direccion),'", ') as agedir,
concat('"' , rtrim ("2339-8888 ext 1690"), '", ') as tel1 ,
400, ',' as agelvini ,
2200, ',' as agelvfin ,
400, ',' as agesini  ,
2200, ',' as agesfin  ,
400, ',' as agedini  ,
2200, ',' as agedfin  ,
400, ',' as vntlvini ,
2200, ',' as vntlvfin ,
400, ',' as vntsini  ,
2200, ',' as vntsfin  ,
400, ',' as vntdini  ,
2200, ',' as vntdfin  ,
400, ',' as autlvini ,
2200, ',' as autlvfin ,
400, ',' as autsini  ,
2200, ',' as autsfin  ,
400, ',' as autdini  ,
2200, ',' as autdfin  ,
'"N",' as gotage   ,
'"N",' as gotvent  ,
'"N",' as gotaut   ,
'"N" );' as gotatm 
from remoto
where rm_tipo_remoto = 10 
and  exists (select 1 from enlace where en_remoto = remoto.rm_remoto  and en_estado = 7)
and not exists (select 1 from crmremoto where crm_remoto = remoto.rm_remoto)
;

