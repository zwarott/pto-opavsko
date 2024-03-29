-- Reset primary key autoincrement after deletion all records in table
-- Run this script in psql from /database directory in format below
-- \set _table 'prekazky_linie' pk_column 'fid' \i constraints/pk_setval_reset.sql
SELECT 
  setval(
    pg_get_serial_sequence(
      :'_table', 
      :'pk_column'
    ), 
    1, 
    FALSE
  );
