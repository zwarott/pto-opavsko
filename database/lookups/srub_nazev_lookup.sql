-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.srub_nazev_lookup;
CREATE TABLE lookups.srub_nazev_lookup (
	fid SERIAL NOT NULL,
	srub_nazev VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (srub_nazev),
    CONSTRAINT srub_nazev_lookup_unique UNIQUE (fid, srub_nazev)
);

-- Prepopulate lookup table.
INSERT INTO lookups.srub_nazev_lookup(srub_nazev) 
    SELECT DISTINCT nazev FROM overview_75k.pozice_srubu_overview
    ORDER BY nazev ASC;

-- Set up foreign key constraint.
ALTER TABLE overview_75k.pozice_srubu_overview ADD CONSTRAINT "srub_nazev_fk"
    FOREIGN KEY (nazev) REFERENCES lookups.srub_nazev_lookup(srub_nazev);