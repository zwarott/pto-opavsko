-- Create lookup table, set up primary key and unique constraints.
DROP TABLE IF EXISTS lookups.srub_typ_lookup;
CREATE TABLE lookups.srub_typ_lookup (
	fid SERIAL NOT NULL,
	srub_typ VARCHAR(255) NOT NULL,
	created_by VARCHAR(255) DEFAULT "current_user"(),
    date_created TIMESTAMPTZ DEFAULT now(),
    modified_by VARCHAR(255),
    date_modified TIMESTAMPTZ,
    PRIMARY KEY (srub_typ),
    CONSTRAINT srub_typ_lookup_unique UNIQUE (fid, srub_typ)
);

-- Prepopulate lookup table.
INSERT INTO lookups.srub_typ_lookup(srub_typ) 
    SELECT DISTINCT typ FROM overview_75k.pozice_srubu_overview
    ORDER BY typ ASC;

-- Set up foreign key constraint.
ALTER TABLE overview_75k.pozice_srubu_overview ADD CONSTRAINT "srub_typ_fk"
    FOREIGN KEY (typ) REFERENCES lookups.srub_typ_lookup(srub_typ);