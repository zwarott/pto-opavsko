-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.kategorie_lookup;
CREATE TABLE lookups.kategorie_lookup (
	fid SERIAL NOT NULL,
	kategorie VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (kategorie),
    CONSTRAINT kategorie_lookup_unique UNIQUE (fid, kategorie)
);

-- Prepopulate lookup table.
INSERT INTO lookups.kategorie_lookup(kategorie) 
    SELECT DISTINCT kategorie FROM main.prekazky_linie
    ORDER BY kategorie ASC;

-- Set up foreign key constraint.
ALTER TABLE main.prekazky_linie ADD CONSTRAINT "kategorie_fk"
    FOREIGN KEY (kategorie) REFERENCES lookups.kategorie_lookup(kategorie);