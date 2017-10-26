use crm 
go 
select 
'insert into crmremoto ' as x1  , 
'(crm_remoto , crm_reg , crm_descripcion , crm_dir, crm_tel , crm_agw_ini , crm_agw_fin, ' as xx21, 
' crm_ags_ini , crm_ags_fin , crm_agd_ini ,' as xx2  , 
'crm_agd_fin , crm_vtw_ini , crm_vtw_fin , crm_vts_ini , crm_vts_fin , crm_vtd_ini ,' as xx23, 
'crm_vtd_fin , crm_atw_ini , crm_atw_fin , crm_ats_ini , crm_ats_fin ,' as xx3  , 
'crm_atd_ini , crm_atd_fin , crm_got_age , crm_got_vent, crm_got_aut , crm_got_atm ) ' as xx4  , 
' values ('  as xx5  , 
 agen_codigo as x, 
', ' as x2, 
agen_region as reg, 
',#%' + rtrim (REPLACE (agen_nombre ,',','')) + '#%, ' as agen, 
' #%' + rtrim( 	 
		REPLACE( 
		REPLACE( 
	  	REPLACE( agen_dir1	,'"','')
					,',','')
					,'
','')
) + '#% , '  as agedir,
'#%'+  REPLACE( agen_linea1, ',','') + ' '+ REPLACE( agen_linea2, ',' ,'')+ '#%, ' as tel1 ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_agel_ini  , ':', ''), '.', ''), ';', ''))), ',' as agelvini ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_agel_fin  , ':', ''), '.', ''), ';', ''))), ',' as agelvfin ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_ages_ini  , ':', ''), '.', ''), ';', ''))), ',' as agesini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_ages_fin  , ':', ''), '.', ''), ';', ''))), ',' as agesfin  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_aged_ini  , ':', ''), '.', ''), ';', ''))), ',' as agedini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_aged_fin  , ':', ''), '.', ''), ';', ''))), ',' as agedfin  ,

convert(smallint ,rtrim(  replace (replace ( replace ( agen_venl_ini  , ':', ''), '.', ''), ';', ''))), ',' as vntlvini ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_venl_fin  , ':', ''), '.', ''), ';', ''))), ',' as vntlvfin ,

convert(smallint ,rtrim(  replace (replace ( replace ( agen_vens_ini  , ':', ''), '.', ''), ';', ''))), ',' as vntsini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_vend_fin  , ':', ''), '.', ''), ';', ''))), ',' as vntsfin  ,

convert(smallint ,rtrim(  replace (replace ( replace ( agen_vend_ini  , ':', ''), '.', ''), ';', ''))), ',' as vntdini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_vend_fin  , ':', ''), '.', ''), ';', ''))), ',' as vntdfin  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autol_ini , ':', ''), '.', ''), ';', ''))), ',' as autlvini ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autol_fin , ':', ''), '.', ''), ';', ''))), ',' as autlvfin ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autos_ini , ':', ''), '.', ''), ';', ''))), ',' as autsini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autos_fin , ':', ''), '.', ''), ';', ''))), ',' as autsfin  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autod_ini , ':', ''), '.', ''), ';', ''))), ',' as autdini  ,
convert(smallint ,rtrim(  replace (replace ( replace ( agen_autod_fin , ':', ''), '.', ''), ';', ''))), ',' as autdfin  ,
'#%' + rtrim( agen_agencia)   + '#%,  ' as gotage   ,
'#%' + rtrim( agen_ventanilla)+ '#%,  ' as gotvent  ,
'#%' + rtrim( agen_auto )     + '#%,  ' as gotaut   ,
'#%' + rtrim( agen_cajero )   + '#%); ' as gotatm
from gs_agencias, gs_config_tipo, gs_geo_departamento d, gs_geo_municipio m
where agen_empresa = 'BDR' 
and agen_codigo not in (select agen_codigo from gs_agencias where agen_codigo >= 9200 and agen_codigo <= 9259)
and agen_codigo not in (9297)
and agen_estado = 1
and agen_estado_tipo = 'A'
and cfgt_empresa = agen_empresa
and cfgt_valor = agen_region
and cfgt_tipo = 'REGION_AGENCIAS'
and d.dep_codigo = agen_geo_dept
and m.mun_codigo = agen_geo_muni 
go

