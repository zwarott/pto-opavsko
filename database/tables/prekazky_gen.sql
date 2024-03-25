-- Create new table as aduplicate from existing table for visualization purposes
CREATE TABLE 
  main.prekazky_gen AS
    SELECT
      *
    FROM
      main.prekazky_agregovane;

-- Set up primary key
ALTER TABLE
  main.prekazky_gen
ADD PRIMARY KEY (fid);

-- Create sequence and set up it within PK column (default value)
CREATE SEQUENCE main.prekazky_gen_id_seq;

ALTER TABLE 
  main.prekazky_gen
ALTER COLUMN 
  fid 
    SET DEFAULT nextval('main.prekazky_gen_id_seq');

-- Set up spatial index
CREATE INDEX 
  sidx_prekazky_gen_geom 
    ON main.prekazky_gen
    USING GIST(geom);

-- Create and fill “typ” column
ALTER TABLE
  main.prekazky_gen
ADD COLUMN
  typ VARCHAR(100);

UPDATE
  main.prekazky_gen
SET typ =
  CASE
    WHEN kategorie IN ('PI', 'LI', 'APr', 'PPr') THEN 'intervalová'
    WHEN kategorie IN ('PP-s', 'PP-v', 'LP-s', 'LP-v', 'PLZP', 'LLZP') THEN 'protitankový příkop'
    ELSE 'obvodová'
  END;

-- Rename “kategorie” column to “kat” to preserve values
ALTER TABLE
  main.prekazky_gen
RENAME COLUMN
  kategorie TO
  kat;

-- Create and fill “kategorie” COLUMN
ALTER TABLE
  main.prekazky_gen
ADD COLUMN
  kategorie VARCHAR(100);

UPDATE
  main.prekazky_gen
SET kategorie =
  CASE
    WHEN kat IN ('PI', 'LI') THEN 'těžká'
    WHEN kat IN ('APr', 'PPr') THEN 'přírodní'
    WHEN kat IN ('PP-s', 'PP-v', 'LP-s', 'LP-v') THEN 'stěna'
    WHEN kat IN ('PLZP', 'LLZP') THEN 'lehká'
    WHEN kat = 'CO' THEN 'čelní těžká'
    ELSE 'týlová lehká'
  END;

-- Update values in “stav” column for “přírodní” values in “přírodní” column
UPDATE 
  main.prekazky_gen
SET 
  stav = 'přírodní'
WHERE
  kategorie = 'přírodní';

-- Update “stav” for “stěna”
UPDATE
  main.prekazky_gen
SET
  stav = 'nedokončeno'
WHERE
  stav = 'provizorní' AND
  kategorie = 'stěna';

-- Update (rename) “stav” values
UPDATE main.prekazky_gen
SET stav =
  CASE
    WHEN stav = 'dokončeno' THEN 'dokončena'
    WHEN stav = 'nedokončeno' THEN 'nedokončena'
  END
WHERE stav IN ('dokončeno', 'nedokončeno');
