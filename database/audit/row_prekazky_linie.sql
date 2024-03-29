-- Show me history of specific row/record (feature) within main.prekazky_linie_history table
-- Run this script in psql from /database directory in format below
-- \set _fid 76 \i audit/record_history.sql
SELECT 
  hid,
  fid,
  ops,
  kategorie,
  stav,
  provedeni,
  kat_vp,
  poznamka,
  delka_gis,
  delka_vp,
  delka_sv,
  valid_range
FROM 
  audit.prekazky_linie_history
WHERE
  fid = :_fid
ORDER BY
  hid DESC;
