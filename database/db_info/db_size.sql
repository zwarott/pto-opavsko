SELECT 
  datname,
  pg_size_pretty(pg_database_size(datname))
FROM 
  pg_database
WHERE 
  datname = 'pto_opavsko'; 
