-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.pozice_srubu_main_history;
CREATE TABLE audit.pozice_srubu_main_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Point,5514),
	ops VARCHAR(50),
	nazev VARCHAR(200),
	typ VARCHAR(200),
	usek VARCHAR(200),
	podusek VARCHAR(200),
	katastr VARCHAR(200),
	stav VARCHAR(50),
	x FLOAT,
	y FLOAT,
	z FLOAT,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX pozice_srubu_main_history_geom_x
	ON audit.pozice_srubu_main_history USING GIST (geom);

CREATE INDEX pozice_srubu_main_history_tstz_x
	ON audit.pozice_srubu_main_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.pozice_srubu_main_history
	(fid, geom, ops, nazev, typ, usek, podusek, katastr, stav, x, y, z, valid_range, created_by)
	SELECT fid, geom, ops, nazev, typ, usek, podusek, katastr, stav, x, y, z, tstzrange(now(), NULL), current_user
		FROM main.pozice_srubu_main;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.pozice_srubu_main_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.pozice_srubu_main_history
				(fid, geom, ops, nazev, typ, usek, podusek, katastr, stav, x, y, z, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.ops, NEW.nazev, NEW.typ, NEW.usek, NEW.podusek, NEW.katastr, NEW.stav, NEW.x, NEW.y, NEW.z, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozice_srubu_main_insert_trigger
AFTER INSERT ON main.pozice_srubu_main
	FOR EACH ROW EXECUTE PROCEDURE public.pozice_srubu_main_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.pozice_srubu_main_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.pozice_srubu_main_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozice_srubu_main_delete_trigger
AFTER DELETE ON main.pozice_srubu_main
	FOR EACH ROW EXECUTE PROCEDURE public.pozice_srubu_main_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.pozice_srubu_main_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.pozice_srubu_main_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.pozice_srubu_main_history
				(fid, geom, ops, nazev, typ, usek, podusek, katastr, stav, x, y, z, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.ops, NEW.nazev, NEW.typ, NEW.usek, NEW.podusek, NEW.katastr, NEW.stav, NEW.x, NEW.y, NEW.z, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozice_srubu_main_update_trigger
AFTER UPDATE ON main.pozice_srubu_main
	FOR EACH ROW EXECUTE PROCEDURE public.pozice_srubu_main_update_tf();