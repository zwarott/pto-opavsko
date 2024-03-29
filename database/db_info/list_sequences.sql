SELECT
  seq.sequence_schema,
  seq.sequence_name
FROM
  information_schema.sequences AS seq
ORDER BY
  sequence_name;
