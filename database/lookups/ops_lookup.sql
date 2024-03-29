-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.ops_lookup;
CREATE TABLE lookups.ops_lookup (
	fid SERIAL NOT NULL,
	ops VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
  date_created TIMESTAMPTZ DEFAULT now(),
  modified_by VARCHAR(255),
  date_modified TIMESTAMPTZ,
  PRIMARY KEY (ops),
  CONSTRAINT ops_lookup_unique UNIQUE (fid, ops)
);

-- Prepopulate lookup table.
INSERT INTO lookups.ops_lookup(ops) 
  SELECT DISTINCT ops FROM main.prekazky_linie
  ORDER BY ops ASC;

-- Set up foreign key constraint.
ALTER TABLE main.prekazky_linie ADD CONSTRAINT "ops_fk"
  FOREIGN KEY (ops) REFERENCES lookups.ops_lookup(ops);
