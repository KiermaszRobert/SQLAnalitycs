select nrmiesiaca,
parametr_1,
wartosc_y,
round (wartosc_y2,2) as prognoza
from(
    SELECT 
    nrmiesiaca,
    parametr_1,
    wartosc_y,
    wartosc_y2
    FROM (
    select
            substr(DATA_ID,0,4) as rok,
            substr(DATA_ID,5,2) as miesiac,
            parametr_1,
       
            (cast(substr(DATA_ID,0,4) as number)-2000) *12+ cast(substr(DATA_ID,5,2) as number) as nrmiesiaca,
                 0 as wartosc_y2,
            count(OFERTA_ID) as wartosc_y
        from CBOP_F_OFERTA 
        group by substr(DATA_ID,0,4), substr(DATA_ID,5,2), parametr_1, (cast(substr(DATA_ID,0,4) as number)-2000) *12+ cast(substr(DATA_ID,5,2) as number)
        order by 4 desc)
    MODEL
    PARTITION BY (parametr_1)
    DIMENSION BY (nrmiesiaca)
    MEASURES (wartosc_y,wartosc_y2)
    (wartosc_y2['61'] = wartosc_y[CV(nrmiesiaca)],
    wartosc_y2[FOR nrmiesiaca FROM 62 TO 217 INCREMENT 1] = (0.5*wartosc_y[CV(nrmiesiaca)-1])+(0.5*wartosc_y2[CV(nrmiesiaca)-1]) )
    order by nrmiesiaca desc
)
where parametr_1 = 1;