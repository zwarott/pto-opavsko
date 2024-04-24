SELECT 
    n.nspname AS schema_name,
    c.relname AS table_name
FROM 
    pg_catalog.pg_class c
JOIN 
    pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE 
    c.relkind IN ('r', 'v', 'm')
    AND n.nspname NOT LIKE 'pg_%'
    AND n.nspname <> 'information_schema'
ORDER BY
    schema_name;
