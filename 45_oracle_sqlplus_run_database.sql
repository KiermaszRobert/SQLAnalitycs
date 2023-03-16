/* dont run, only check

srvctl status database -db mail

sqlplus / as sysdba

@?/demo/schema/human_resources/hr_main.sql




alter session set "_ORACLE_SCRIPT"=true;

create user hr identified by hr;

drop user hr cascade;

@?/demo/schema/human_resources/hr_main.sql


SET ORACLE_SID=orcl3

*/ 
