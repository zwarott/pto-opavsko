-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.podusek_lookup;
CREATE TABLE lookups.podusek_lookup (
	fid SERIAL NOT NULL,
	podusek VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (podusek),
    CONSTRAINT podusek_lookup_unique UNIQUE (fid, podusek)
);

-- Prepopulate lookup table.
INSERT INTO lookups.podusek_lookup(podusek) 
    SELECT DISTINCT podusek FROM overview_75k.pozice_srubu_overview
    ORDER BY podusek ASC;

-- Set up foreign key constraint.
ALTER TABLE overview_75k.pozice_srubu_overview ADD CONSTRAINT "podusek_fk"
    FOREIGN KEY (podusek) REFERENCES lookups.podusek_lookup(podusek);