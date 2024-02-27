-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.pomocne_linie_history;
CREATE TABLE audit.pomocne_linie_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Multilinestring,5514),
	typ VARCHAR(50),
	uhel FLOAT,
	poznamka VARCHAR(200),
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX pomocne_linie_history_geom_x
	ON audit.pomocne_linie_history USING GIST (geom);

CREATE INDEX pomocne_linie_history_tstz_x
	ON audit.pomocne_linie_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.pomocne_linie_history
	(fid, geom, typ, uhel, poznamka, valid_range, created_by)
	SELECT fid, geom, typ, uhel, poznamka, tstzrange(now(), NULL), current_user
		FROM main.pomocne_linie;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.pomocne_linie_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.pomocne_linie_history
				(fid, geom, typ, uhel, poznamka, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.typ, NEW.uhel, NEW.poznamka, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pomocne_linie_insert_trigger
AFTER INSERT ON main.pomocne_linie
	FOR EACH ROW EXECUTE PROCEDURE public.pomocne_linie_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.pomocne_linie_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.pomocne_linie_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pomocne_linie_delete_trigger
AFTER DELETE ON main.pomocne_linie
	FOR EACH ROW EXECUTE PROCEDURE public.pomocne_linie_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.pomocne_linie_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.pomocne_linie_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.pomocne_linie_history
				(fid, geom, typ, uhel, poznamka, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.typ, NEW.uhel, NEW.poznamka, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER pomocne_linie_update_trigger
AFTER UPDATE ON main.pomocne_linie
	FOR EACH ROW EXECUTE PROCEDURE public.pomocne_linie_update_tf();