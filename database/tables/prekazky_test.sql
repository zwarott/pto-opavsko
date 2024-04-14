-- Create a copy of the table with the same structure
CREATE TABLE 
  main.prekazky_test (
    LIKE main.prekazky_linie 
    INCLUDING ALL
  );

-- Create the sequence
-- It will not be automatically created
CREATE SEQUENCE prekazky_test_id_seq;

-- Isert data to empty table
INSERT INTO
  main.prekazky_test
SELECT
  *
FROM
  main.prekazky_linie;

-- Set the next value of the sequence for the serial primary key column
SELECT setval('prekazky_test_id_seq', COALESCE((SELECT MAX(fid) FROM main.prekazky_test), 1));

-- Create trigger for prekazky_test table
-- It will not be automatically created
CREATE TRIGGER prekazky_test_trigger
BEFORE UPDATE ON main.prekazky_test
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_update_tf();
