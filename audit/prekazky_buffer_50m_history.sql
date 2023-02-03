-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.prekazky_buffer_50m_history;
CREATE TABLE audit.prekazky_buffer_50m_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(MultiPolygon,5514),
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX prekazky_buffer_50m_history_geom_x
	ON audit.prekazky_buffer_50m_history USING GIST (geom);

CREATE INDEX prekazky_buffer_50m_history_tstz_x
	ON audit.prekazky_buffer_50m_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.prekazky_buffer_50m_history
	(fid, geom, valid_range, created_by)
	SELECT fid, geom, tstzrange(now(), NULL), current_user
		FROM main.prekazky_buffer_50m;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.prekazky_buffer_50m_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.prekazky_buffer_50m_history
				(fid, geom, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prekazky_buffer_50m_insert_trigger
AFTER INSERT ON main.prekazky_buffer_50m
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_buffer_50m_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.prekazky_buffer_50m_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.prekazky_buffer_50m_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prekazky_buffer_50m_delete_trigger
AFTER DELETE ON main.prekazky_buffer_50m
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_buffer_50m_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.prekazky_buffer_50m_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.prekazky_buffer_50m_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.prekazky_buffer_50m_history
				(fid, geom, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prekazky_buffer_50m_update_trigger
AFTER UPDATE ON main.prekazky_buffer_50m
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_buffer_50m_update_tf();