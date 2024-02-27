-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.kat_vp_lookup;
CREATE TABLE lookups.kat_vp_lookup (
	fid SERIAL NOT NULL,
	kat_vp VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (kat_vp),
    CONSTRAINT kat_vp_lookup_unique UNIQUE (fid, kat_vp)
);

-- Prepopulate lookup table.
INSERT INTO lookups.kat_vp_lookup(kat_vp) 
    SELECT DISTINCT kat_vp FROM main.prekazky_linie
    ORDER BY kat_vp ASC;

-- Set up foreign key constraint.
ALTER TABLE main.prekazky_linie ADD CONSTRAINT "kat_vp_fk"
    FOREIGN KEY (kat_vp) REFERENCES lookups.kat_vp_lookup(kat_vp);