use crm
go
select x1  = 'insert into crmremoto ', xx2  = '(crm_age , crm_reg , crm_descripcion , crm_dir, crm_tel , crm_agw_ini , crm_agw_fin , crm_ags_ini , crm_ags_fin , crm_agd_ini ,', xx3  = 'crm_agd_fin , crm_vtw_ini , crm_vtw_fin , crm_vts_ini , crm_vts_fin , crm_vtd_ini , crm_vtd_fin , crm_atw_ini , crm_atw_fin , crm_ats_ini , crm_ats_fin ,', xx4  = 'crm_atd_ini , crm_atd_fin , crm_got_age , crm_got_vent, crm_got_aut , crm_got_atm ) ', xx5  = ' values (' , x=  agen_codigo,
x2= ', ',
reg= agen_region,
agen= ', '' + rtrim ( REPLACE( agen_nombre ,',','')) + '', ',
agedir= ''' + rtrim ( REPLACE( REPLACE(agen_dir1,'
',''),',','')) + '', ',
tel1= '''+  REPLACE( agen_linea1, ',','') + ' '+ REPLACE( agen_linea2, ',' ,'')+ '', ',
agelvini = case agen_agel_ini  when ''  then ''0:00',' else '''+ agen_agel_ini   + '' , ' end,
agelvfin = case agen_agel_fin  when ''  then ''0:00',' else '''+ agen_agel_fin   + '' , ' end,
agesini  = case agen_ages_ini  when ''  then ''0:00',' else '''+ agen_ages_ini   + '' , ' end,
agesfin  = case agen_ages_fin  when ''  then ''0:00',' else '''+ agen_ages_fin   + '' , ' end,
agedini  = case agen_aged_ini  when ''  then ''0:00',' else '''+ agen_aged_ini   + '' , ' end,
agedfin  = case agen_aged_fin  when ''  then ''0:00',' else '''+ agen_aged_fin   + '' , ' end,
vntlvini = case agen_venl_ini  when ''  then ''0:00',' else '''+ agen_venl_ini   + '' , ' end,
vntlvfin = case agen_venl_fin  when ''  then ''0:00',' else '''+ agen_venl_fin   + '' , ' end,
vntsini  = case agen_vens_ini  when ''  then ''0:00',' else '''+ agen_vens_ini   + '' , ' end,
vntsfin  = case agen_vens_fin  when ''  then ''0:00',' else '''+ agen_vens_fin   + '' , ' end,
vntdini  = case agen_vend_ini  when ''  then ''0:00',' else '''+ agen_vend_ini   + '' , ' end,
vntdfin  = case agen_vend_fin  when ''  then ''0:00',' else '''+ agen_vend_fin   + '' , ' end,
autlvini = case agen_autol_ini when ''  then ''0:00',' else '''+ agen_autol_ini  + '' , ' end,
autlvfin = case agen_autol_fin when ''  then ''0:00',' else '''+ agen_autol_fin  + '' , ' end,
autsini  = case agen_autos_ini when ''  then ''0:00',' else '''+ agen_autos_ini  + '' , ' end,
autsfin  = case agen_autos_fin when ''  then ''0:00',' else '''+ agen_autos_fin  + '' , ' end,
autdini  = case agen_autod_ini when ''  then ''0:00',' else '''+ agen_autod_ini  + '' , ' end,
autdfin  = case agen_autod_fin when ''  then ''0:00',' else '''+ agen_autod_fin  + '' , ' end,
gotage= '''+agen_agencia  + '', ',
gotvent= '''+agen_ventanilla  + '', ',
gotaut= '''+agen_auto        + '', ',
gotatm = '''+agen_cajero + '');'
from GS_AGENCIAS
go

