-- Select last PK value
-- Run this query in psql from /database directory in format below
-- \set schema_name 'main' table_name 'prekazky_linie' \i constraints/last_pk_value.sql
SELECT
  fid 
FROM
  :schema_name.:table_name
ORDER BY 
  fid DESC LIMIT 1;
