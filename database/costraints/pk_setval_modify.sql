-- Modify default value -> next primary key value will be 1551
-- Run this script in psql from /database directory in format below
-- \set _schema 'main' _seq 'prekazky_linie_id_seq' last_pk 1550 \i constraints/pk_setval_modify.sql
SELECT 
  setval(
    :'_schema' || '.' || :'_seq',
    :last_pk
  );
