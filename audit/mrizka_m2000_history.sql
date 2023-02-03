-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.mrizka_m2000_history;
CREATE TABLE audit.mrizka_m2000_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Polygon,5514),
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX mrizka_m2000_history_geom_x
	ON audit.mrizka_m2000_history USING GIST (geom);

CREATE INDEX mrizka_m2000_history_tstz_x
	ON audit.mrizka_m2000_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.mrizka_m2000_history
	(fid, geom, valid_range, created_by)
	SELECT fid, geom, tstzrange(now(), NULL), current_user
		FROM main.mrizka_m2000;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.mrizka_m2000_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.mrizka_m2000_history
				(fid, geom, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER mrizka_m2000_insert_trigger
AFTER INSERT ON main.mrizka_m2000
	FOR EACH ROW EXECUTE PROCEDURE public.mrizka_m2000_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.mrizka_m2000_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.mrizka_m2000_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;


CREATE TRIGGER mrizka_m2000_delete_trigger
AFTER DELETE ON main.mrizka_m2000
	FOR EACH ROW EXECUTE PROCEDURE public.mrizka_m2000_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.mrizka_m2000_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.mrizka_m2000_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.mrizka_m2000_history
				(fid, geom, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER mrizka_m2000_update_trigger
AFTER UPDATE ON main.mrizka_m2000
	FOR EACH ROW EXECUTE PROCEDURE public.mrizka_m2000_update_tf();