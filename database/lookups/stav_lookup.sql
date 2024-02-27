-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.stav_lookup;
CREATE TABLE lookups.stav_lookup (
	fid SERIAL NOT NULL,
	stav VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (stav),
    CONSTRAINT stav_lookup_unique UNIQUE (fid, stav)
);

-- Prepopulate lookup table.
INSERT INTO lookups.stav_lookup(stav) 
    SELECT DISTINCT stav FROM main.prekazky_linie
    ORDER BY stav ASC;

-- Set up foreign key constraint.
ALTER TABLE main.prekazky_linie ADD CONSTRAINT "stav_fk"
    FOREIGN KEY (stav) REFERENCES lookups.stav_lookup(stav);