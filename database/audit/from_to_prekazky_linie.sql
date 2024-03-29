-- Show me changes in table from specific date to specific date
-- lower(valid_range) refers to the first timestamp in tstzrange
-- upper(valid_range) refers to the second timestamp in tstzrange
-- Run this script in psql from /database directory in format below
-- \set _fid 76 \i audit/from_to_prekazky_linie.sql
-- 
SELECT 
  hid,
  fid,
  ops,
  kategorie,
  stav,
  provedeni,
  kat_vp,
  delka_gis,
  valid_range
FROM 
  audit.prekazky_linie_history
WHERE
tstzrange(:'_from', :'_to', '[)') && valid_range AND
    (
      lower(valid_range) >= :'_from'::timestamp OR
      upper(valid_range) <= :'_to'::timestamp
    )
ORDER BY
  hid DESC;
