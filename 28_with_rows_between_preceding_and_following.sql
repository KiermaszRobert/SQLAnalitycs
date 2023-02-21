WITH data AS (
select 1 as t ,1 as a from dual
union
select 2 as t ,5 from dual
union
select 3 ,3 from dual
union
select 4 ,5 from dual
union
select 5 ,4 from dual
union
select 6 ,11 from dual

)
SELECT t, a, avg(a) OVER (ORDER BY t ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
FROM data
ORDER BY t

--http://www.dba-oracle.com/t_advanced_sql_windowing_clause.htm


--select INSTR('Tech on the net', 'c') from dual ;