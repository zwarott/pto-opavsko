-- Create new table as aduplicate from existing table for overview purposes
CREATE TABLE 
  main.prekazky_agregovane AS
    SELECT
      *
    FROM
      main.prekazky_linie;

-- Set up primary key
ALTER TABLE
  main.prekazky_agregovane
ADD PRIMARY KEY (fid);

-- Create sequence and set up it within PK column (default value)
CREATE SEQUENCE main.prekazky_agregovane_id_seq;

ALTER TABLE 
  main.prekazky_agregovane
ALTER COLUMN 
  fid 
    SET DEFAULT nextval('main.prekazky_agregovane_id_seq');

-- Set up spatial index
CREATE INDEX 
  sidx_prekazky_agregovane_geom 
    ON main.prekazky_agregovane
    USING GIST(geom);

-- Create and fill “typ” column
ALTER TABLE
  main.prekazky_agregovane
ADD COLUMN
  typ VARCHAR(100);

UPDATE
  main.prekazky_agregovane
SET typ =
  CASE
    WHEN kategorie IN ('PI', 'LI', 'APr', 'PPr') THEN 'intervalová'
    WHEN kategorie IN ('PP-s', 'PP-v', 'LP-s', 'LP-v', 'PLZP', 'LLZP') THEN 'protitankový příkop'
    ELSE 'obvodová'
  END;

-- Rename “kategorie” column to “kat” to preserve values
ALTER TABLE
  main.prekazky_agregovane
RENAME COLUMN
  kategorie TO
  kat;

-- Create and fill “kategorie” COLUMN
ALTER TABLE
  main.prekazky_agregovane
ADD COLUMN
  kategorie VARCHAR(100);

UPDATE
  main.prekazky_agregovane
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
  main.prekazky_agregovane
SET 
  stav = 'přírodní'
WHERE
  kategorie = 'přírodní';

-- Update “stav” for “stěna”
UPDATE
  main.prekazky_agregovane
SET
  stav = 'nedokončeno'
WHERE
  stav = 'provizorní' AND
  kategorie = 'stěna';

-- Update (rename) “stav” values
UPDATE main.prekazky_agregovane
SET stav =
  CASE
    WHEN stav = 'dokončeno' THEN 'dokončena'
    WHEN stav = 'nedokončeno' THEN 'nedokončena'
  END
WHERE stav IN ('dokončeno', 'nedokončeno');
