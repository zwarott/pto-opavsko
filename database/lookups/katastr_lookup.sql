-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.katastr_lookup;
CREATE TABLE lookups.katastr_lookup (
	fid SERIAL NOT NULL,
	katastr VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (katastr),
    CONSTRAINT katastr_lookup_unique UNIQUE (fid, katastr)
);

-- Prepopulate lookup table.
INSERT INTO lookups.katastr_lookup(katastr) 
    SELECT DISTINCT katastr FROM overview_75k.pozice_srubu_overview
    ORDER BY katastr ASC;

-- Set up foreign key constraint.
ALTER TABLE overview_75k.pozice_srubu_overview ADD CONSTRAINT "katastr_fk"
    FOREIGN KEY (katastr) REFERENCES lookups.katastr_lookup(katastr);