-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.centroidy_atlas_history;
CREATE TABLE audit.centroidy_atlas_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Point,5514),
	poradi INTEGER,
	rotace INTEGER,
	titulek VARCHAR(200),  
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX centroidy_atlas_history_geom_x
	ON audit.centroidy_atlas_history USING GIST (geom);

CREATE INDEX centroidy_atlas_history_tstz_x
	ON audit.centroidy_atlas_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.centroidy_atlas_history
	(fid, geom, poradi, rotace, titulek, valid_range, created_by)
	SELECT fid, geom, poradi, rotace, titulek, tstzrange(now(), NULL), current_user
		FROM main.centroidy_atlas;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.centroidy_atlas_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.centroidy_atlas_history
				(fid, geom, poradi, rotace, titulek, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poradi, NEW.rotace, NEW.titulek, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;
	
CREATE TRIGGER centroidy_atlas_insert_trigger
AFTER INSERT ON main.centroidy_atlas
	FOR EACH ROW EXECUTE PROCEDURE public.centroidy_atlas_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.centroidy_atlas_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.centroidy_atlas_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER centroidy_atlas_delete_trigger
AFTER DELETE ON main.centroidy_atlas
	FOR EACH ROW EXECUTE PROCEDURE public.centroidy_atlas_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.centroidy_atlas_update_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.centroidy_atlas_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.centroidy_atlas_history
				(fid, geom, poradi, rotace, titulek, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poradi, NEW.rotace, NEW.titulek, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER centroidy_atlas_update_trigger
AFTER UPDATE ON main.centroidy_atlas
	FOR EACH ROW EXECUTE PROCEDURE public.centroidy_atlas_update_tf();