-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.sruby_ruian_history;
CREATE TABLE audit.sruby_ruian_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(MultiPolygon,5514),
	gml_id VARCHAR(30),
	kod INTEGER,
	identifika NUMERIC,
	typstavebn INTEGER,
	zpusobvyuz INTEGER,
	isknbudova NUMERIC,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX sruby_ruian_history_geom_x
	ON audit.sruby_ruian_history USING GIST (geom);

CREATE INDEX sruby_ruian_history_tstz_x
	ON audit.sruby_ruian_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.sruby_ruian_history
	(fid, geom, gml_id, kod, identifika, typstavebn, zpusobvyuz, isknbudova, valid_range, created_by)
	SELECT fid, geom, gml_id, kod, identifika, typstavebn, zpusobvyuz, isknbudova, tstzrange(now(), NULL), current_user
		FROM main.sruby_ruian;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.sruby_ruian_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.sruby_ruian_history
				(fid, geom, gml_id, kod, identifika, typstavebn, zpusobvyuz, isknbudova, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.gml_id, NEW.kod, NEW.identifika, NEW.typstavebn, NEW.zpusobvyuz, NEW.isknbudova, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER sruby_ruian_insert_trigger
AFTER INSERT ON main.sruby_ruian
	FOR EACH ROW EXECUTE PROCEDURE public.sruby_ruian_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.sruby_ruian_delete_tf() RETURNS trigger AS
	$$
		BEGIN
			UPDATE audit.sruby_ruian_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;
			RETURN NULL;
		END;
	$$
	LANGUAGE plpgsql;


CREATE TRIGGER sruby_ruian_delete_trigger
AFTER DELETE ON main.sruby_ruian
	FOR EACH ROW EXECUTE PROCEDURE public.sruby_ruian_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.sruby_ruian_update_tf() RETURNS trigger AS
	$$
	BEGIN

		UPDATE audit.sruby_ruian_history
			SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
			WHERE valid_range @> current_timestamp AND fid = OLD.fid;

		INSERT INTO audit.sruby_ruian_history
			(fid, geom, gml_id, kod, identifika, typstavebn, zpusobvyuz, isknbudova, valid_range, created_by)
		VALUES
			(NEW.fid, NEW.geom, NEW.gml_id, NEW.kod, NEW.identifika, NEW.typstavebn, NEW.zpusobvyuz, NEW.isknbudova, tstzrange(current_timestamp, NULL), current_user);

		RETURN NEW;

	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER sruby_ruian_update_trigger
AFTER UPDATE ON main.sruby_ruian
	FOR EACH ROW EXECUTE PROCEDURE public.sruby_ruian_update_tf();