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
tstzrange(:'_from', now(), '[)') && valid_range AND
    (
      lower(valid_range) < now()::timestamp AND
      lower(valid_range) >= :'_from'::timestamp
      -- upper(valid_range) < now()::timestamp
    )
ORDER BY
  hid DESC;
