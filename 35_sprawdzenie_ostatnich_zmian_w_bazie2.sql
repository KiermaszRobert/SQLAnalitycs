SELECT  
a.table_name,
a.column_name ,
a.column_id
FROM ALL_TAB_COLS a
join 
    (SELECT
    table_name,
    max(column_id)-5 as max
    FROM ALL_TAB_COLS
    WHERE 
    --column_name LIKE '%A%' and 
    OWNER='A' 
    group by table_name) b on (a.table_name=b.table_name and b.max<a.column_id)

order by a.table_name;