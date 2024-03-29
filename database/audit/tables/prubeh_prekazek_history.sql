-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.prubeh_prekazek_history;
CREATE TABLE audit.prubeh_prekazek_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Linestring,5514),
	typ INTEGER,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX prubeh_prekazek_history_geom_x
	ON audit.prubeh_prekazek_history USING GIST (geom);

CREATE INDEX prubeh_prekazek_history_tstz_x
	ON audit.prubeh_prekazek_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.prubeh_prekazek_history
	(fid, geom, typ, valid_range, created_by)
	SELECT fid, geom, typ, tstzrange(now(), NULL), current_user
		FROM overview_75K.prubeh_prekazek;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.prubeh_prekazek_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.prubeh_prekazek_history
				(fid, geom, typ, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.typ, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prubeh_prekazek_insert_trigger
AFTER INSERT ON overview_75K.prubeh_prekazek
	FOR EACH ROW EXECUTE PROCEDURE public.prubeh_prekazek_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.prubeh_prekazek_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.prubeh_prekazek_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prubeh_prekazek_delete_trigger
AFTER DELETE ON overview_75k.prubeh_prekazek
	FOR EACH ROW EXECUTE PROCEDURE public.prubeh_prekazek_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.prubeh_prekazek_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.prubeh_prekazek_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.prubeh_prekazek_history
				(fid, geom, typ, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.typ, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prubeh_prekazek_update_trigger
AFTER UPDATE ON overview_75K.prubeh_prekazek
	FOR EACH ROW EXECUTE PROCEDURE public.prubeh_prekazek_update_tf();