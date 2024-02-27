-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.csr_pred_zaborem_history;
CREATE TABLE audit.csr_pred_zaborem_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(MultiPolygon,5514),
	vymera_skm FLOAT,  
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX csr_pred_zaborem_history_geom_x
	ON audit.csr_pred_zaborem_history USING GIST (geom);

CREATE INDEX csr_pred_zaborem_history_tstz_x
	ON audit.csr_pred_zaborem_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.csr_pred_zaborem_history
	(fid, geom, vymera_skm, valid_range, created_by)
	SELECT fid, geom, vymera_skm,tstzrange(now(), NULL), current_user
		FROM overview_13kk.csr_pred_zaborem;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.csr_pred_zaborem_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.csr_pred_zaborem_history
				(fid, geom, vymera_skm, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.vymera_skm, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER csr_pred_zaborem_insert_trigger
AFTER INSERT ON overview_13kk.csr_pred_zaborem
	FOR EACH ROW EXECUTE PROCEDURE public.csr_pred_zaborem_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.csr_pred_zaborem_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.csr_pred_zaborem_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER csr_pred_zaborem_delete_trigger
AFTER DELETE ON overview_13kk.csr_pred_zaborem
	FOR EACH ROW EXECUTE PROCEDURE public.csr_pred_zaborem_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.csr_pred_zaborem_update_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.csr_pred_zaborem_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.csr_pred_zaborem_history
					(fid, geom, vymera_skm, valid_range, created_by)
				VALUES
					(NEW.fid, NEW.geom, NEW.vymera_skm, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER csr_pred_zaborem_update_trigger
AFTER UPDATE ON overview_13kk.csr_pred_zaborem
	FOR EACH ROW EXECUTE PROCEDURE public.csr_pred_zaborem_update_tf();