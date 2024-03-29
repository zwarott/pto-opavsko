SELECT
  tgname as trigger_name
FROM
  pg_trigger
ORDER BY trigger_name;
