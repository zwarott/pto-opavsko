-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.geodeticke_zamereni_history;
CREATE TABLE audit.geodeticke_zamereni_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	id INTEGER,
	geom GEOMETRY(PointZ,5514),
	x FLOAT,
	y FLOAT,
	z FLOAT,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX geodeticke_zamereni_history_geom_x
	ON audit.geodeticke_zamereni_history USING GIST (geom);

CREATE INDEX geodeticke_zamereni_history_tstz_x
	ON audit.geodeticke_zamereni_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.geodeticke_zamereni_history
	(fid, id, geom, x, y, z, valid_range, created_by)
	SELECT fid, id, geom, x, y, z, tstzrange(now(), NULL), current_user
		FROM detail.geodeticke_zamereni;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.geodeticke_zamereni_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.geodeticke_zamereni_history
				(fid, id, geom, x, y, z, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.id, NEW.geom, NEW.x, NEW.y, NEW.z, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER geodeticke_zamereni_insert_trigger
AFTER INSERT ON detail.geodeticke_zamereni
	FOR EACH ROW EXECUTE PROCEDURE public.geodeticke_zamereni_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.geodeticke_zamereni_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.geodeticke_zamereni_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER geodeticke_zamereni_delete_trigger
AFTER DELETE ON detail.geodeticke_zamereni
	FOR EACH ROW EXECUTE PROCEDURE public.geodeticke_zamereni_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.geodeticke_zamereni_update_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.geodeticke_zamereni_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.geodeticke_zamereni_history 
					(fid, id, geom, x, y, z, valid_range, created_by)
				VALUES
					(NEW.fid, NEW.id, NEW.geom, NEW.x, NEW.y, NEW.z, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER geodeticke_zamereni_update_trigger
AFTER UPDATE ON detail.geodeticke_zamereni
	FOR EACH ROW EXECUTE PROCEDURE public.geodeticke_zamereni_update_tf();