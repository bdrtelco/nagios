use enlaces;
select "update crmremoto set crm_remoto = ", cn_remoto , "where crm_remoto = ",  cn_crm_remoto , ";" from crmremoto, crm2nag  where crm_remoto = cn_crm_remoto ;
