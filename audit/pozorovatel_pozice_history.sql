-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.pozorovatel_pozice_history;
CREATE TABLE audit.pozorovatel_pozice_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Point,5514),
	poznamka VARCHAR(200),
	ops VARCHAR(30),	
	foto VARCHAR(200),
	foto_zdroj VARCHAR(250),
	foto_pohled VARCHAR(200),
	foto_porizeni VARCHAR(200),
	x FLOAT,
	y FLOAT,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX pozorovatel_pozice_history_geom_x
	ON audit.pozorovatel_pozice_history USING GIST (geom);

CREATE INDEX pozorovatel_pozice_history_tstz_x
	ON audit.pozorovatel_pozice_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.pozorovatel_pozice_history
	(fid, geom, poznamka, ops, foto, foto_zdroj, foto_pohled, foto_porizeni, x, y, valid_range, created_by)
	SELECT fid, geom, poznamka, ops, foto, foto_zdroj, foto_pohled, foto_porizeni, x, y, tstzrange(now(), NULL), current_user
		FROM main.pozorovatel_pozice;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.pozorovatel_pozice_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.pozorovatel_pozice_history
				(fid, geom, poznamka, ops, foto, foto_zdroj, foto_pohled, foto_porizeni, x, y, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poznamka, NEW.ops, NEW.foto, NEW.foto_zdroj, NEW.foto_pohled, NEW.foto_porizeni, NEW.x, NEW.y, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozorovatel_pozice_insert_trigger
AFTER INSERT ON main.pozorovatel_pozice
	FOR EACH ROW EXECUTE PROCEDURE public.pozorovatel_pozice_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.pozorovatel_pozice_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.pozorovatel_pozice_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozorovatel_pozice_delete_trigger
AFTER DELETE ON main.pozorovatel_pozice
	FOR EACH ROW EXECUTE PROCEDURE public.pozorovatel_pozice_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.pozorovatel_pozice_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.pozorovatel_pozice_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.pozorovatel_pozice_history
				(fid, geom, poznamka, ops, foto, foto_zdroj, foto_pohled, foto_porizeni, x, y, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poznamka, NEW.ops, NEW.foto, NEW.foto_zdroj, NEW.foto_pohled, NEW.foto_porizeni, NEW.x, NEW.y, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pozorovatel_pozice_update_trigger
AFTER UPDATE ON main.pozorovatel_pozice
	FOR EACH ROW EXECUTE PROCEDURE public.pozorovatel_pozice_update_tf();