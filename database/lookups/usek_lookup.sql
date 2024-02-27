-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.usek_lookup;
CREATE TABLE lookups.usek_lookup (
	fid SERIAL NOT NULL,
	usek VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (usek),
    CONSTRAINT usek_lookup_unique UNIQUE (fid, usek)
);

-- Prepopulate lookup table.
INSERT INTO lookups.usek_lookup(usek) 
    SELECT DISTINCT usek FROM overview_75k.pozice_srubu_overview
    ORDER BY usek ASC;

-- Set up foreign key constraint.
ALTER TABLE overview_75k.pozice_srubu_overview ADD CONSTRAINT "usek_fk"
    FOREIGN KEY (usek) REFERENCES lookups.usek_lookup(usek);