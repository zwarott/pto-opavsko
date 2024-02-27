-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.palebne_zvony_history;
CREATE TABLE audit.palebne_zvony_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Point,5514),
	ops VARCHAR(50),
	x FLOAT,
	y FLOAT,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX palebne_zvony_history_geom_x
	ON audit.palebne_zvony_history USING GIST (geom);

CREATE INDEX palebne_zvony_history_tstz_x
	ON audit.palebne_zvony_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.palebne_zvony_history
	(fid, geom, ops, x, y, valid_range, created_by)
	SELECT fid, geom, ops, x, y, tstzrange(now(), NULL), current_user
		FROM main.palebne_zvony;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.palebne_zvony_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.palebne_zvony_history
				(fid, geom, ops, x, y, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.ops, NEW.x, NEW.y, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER palebne_zvony_insert_trigger
AFTER INSERT ON main.palebne_zvony
	FOR EACH ROW EXECUTE PROCEDURE public.palebne_zvony_insert_tf();
  
-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.palebne_zvony_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.palebne_zvony_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER palebne_zvony_delete_trigger
AFTER DELETE ON main.palebne_zvony
	FOR EACH ROW EXECUTE PROCEDURE public.palebne_zvony_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.palebne_zvony_update_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.palebne_zvony_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.palebne_zvony_history
				(fid, geom, ops, x, y, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.ops, NEW.x, NEW.y, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER palebne_zvony_update_trigger
AFTER UPDATE ON main.palebne_zvony
	FOR EACH ROW EXECUTE PROCEDURE public.palebne_zvony_update_tf();