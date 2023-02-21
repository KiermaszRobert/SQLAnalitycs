Create or replace VIEW PROGRAMY_W_ORGAZNIACJI as
SELECT ID_ORGANIZACJI,RODZAJ_PROGRAMU, sum(KWOTA_PRZYZNANA) as suma
from AC_UDZIELONY_INSTRUMENT@AC 
where id_organizacji is not null
and KWOTA_PRZYZNANA is not null
and rodzaj_programu is not null
and id_organizacji < 1000
group by ID_ORGANIZACJI, RODZAJ_PROGRAMU
order by 1,2;

select * from PROGRAMY_W_ORGAZNIACJI;
select distinct rodzaj_programu from PROGRAMY_W_ORGAZNIACJI;



SELECT ID_ORGANIZACJI,RODZAJ_PROGRAMU, suma
from PROGRAMY_W_ORGAZNIACJI 
MODEL
PARTITION BY (ID_ORGANIZACJI) DIMENSION BY (RODZAJ_PROGRAMU)
  MEASURES (suma)
  RULES (
SUMA['WSZYSTKIE'] =  
PRESENTV(suma['FP'],suma['FP'],0)                            
+PRESENTV(suma['pilotażowy'],suma['pilotażowy'],0)
+PRESENTV(suma['EFS systemowy'],suma['EFS systemowy'],0)
+PRESENTV(suma['centralny'],suma['centralny'],0)
+PRESENTV(suma['regionalny'],suma['regionalny'],0)
+PRESENTV(suma['inny'],suma['inny'],0))
order by 1,2;


select nrmiesiaca,
subs_id,
iloscOfertPracy,
round (iloscOfertPracy2,2) as prognoza
from(
    SELECT 
    nrmiesiaca,
    subs_id,
    iloscOfertPracy,
    iloscOfertPracy2
    FROM (
    select
            substr(DATA_PRZYJ_ZGL_ID,0,4) as rok,
            substr(DATA_PRZYJ_ZGL_ID,5,2) as miesiac,
            SUBS_ID,
       
            (cast(substr(DATA_PRZYJ_ZGL_ID,0,4) as number)-2000) *12+ cast(substr(DATA_PRZYJ_ZGL_ID,5,2) as number) as nrmiesiaca,
                 0 as iloscOfertPracy2,
            count(OFERTA_ID) as iloscOfertPracy
        from CBOP_F_OFERTA 
        group by substr(DATA_PRZYJ_ZGL_ID,0,4), substr(DATA_PRZYJ_ZGL_ID,5,2), SUBS_ID, (cast(substr(DATA_PRZYJ_ZGL_ID,0,4) as number)-2000) *12+ cast(substr(DATA_PRZYJ_ZGL_ID,5,2) as number)
        order by 4 desc)
    MODEL
    PARTITION BY (subs_id)
    DIMENSION BY (nrmiesiaca)
    MEASURES (iloscOfertPracy,iloscOfertPracy2)
    (iloscOfertPracy2['61'] = iloscOfertPracy[CV(nrmiesiaca)],
    iloscOfertPracy2[FOR nrmiesiaca FROM 62 TO 217 INCREMENT 1] = (0.5*iloscOfertPracy[CV(nrmiesiaca)-1])+(0.5*iloscOfertPracy2[CV(nrmiesiaca)-1]) )
    order by nrmiesiaca desc
)
where subs_id = 1;