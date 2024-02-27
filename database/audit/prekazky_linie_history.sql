-- Create history table and set indexes.
DROP TABLE IF EXISTS audit.prekazky_linie_history;
CREATE TABLE audit.prekazky_linie_history (
	hid SERIAL PRIMARY KEY,
	fid INTEGER,
	geom GEOMETRY(Multilinestring,5514),
	poznamka VARCHAR(250),
	ops VARCHAR(100),
	stav VARCHAR(100),
	kategorie VARCHAR(100),
	kat_vp VARCHAR(100),
	provedeni VARCHAR(250),
	delka_gis FLOAT,
	delka_vp FLOAT,
	delka_sv FLOAT,
	valid_range TSTZRANGE,
	created_by VARCHAR(32),
	deleted_by VARCHAR(32)
);

CREATE INDEX prekazky_linie_history_geom_x
	ON audit.prekazky_buffer_50m_history USING GIST (geom);

CREATE INDEX prekazky_linie_history_tstz_x
	ON audit.prekazky_linie_history USING GIST (valid_range);

-- Insert data from parent table into history table.
INSERT INTO audit.prekazky_linie_history
	(fid, geom, poznamka, ops, stav, kategorie, kat_vp, provedeni, delka_gis, delka_vp, delka_sv, valid_range, created_by)
	SELECT fid, geom, poznamka, ops, stav, kategorie, kat_vp, provedeni, delka_gis, delka_vp, delka_sv, tstzrange(now(), NULL), current_user
		FROM main.prekazky_linie;

-- Create trigger function for insert.
CREATE OR REPLACE FUNCTION public.prekazky_linie_insert_tf() RETURNS trigger AS
	$$
		BEGIN
			INSERT INTO audit.prekazky_linie_history
				(fid, geom, poznamka, ops, stav, kategorie, kat_vp, provedeni, delka_gis, delka_vp, delka_sv, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poznamka, NEW.ops, NEW.stav, NEW.kategorie, NEW.kat_vp, NEW.provedeni, NEW.delka_gis, NEW.delka_vp, NEW.delka_sv, tstzrange(current_timestamp, NULL), current_user);
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prekazky_linie_insert_trigger
AFTER INSERT ON main.prekazky_linie
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_linie_insert_tf();

-- Create trigger function for delete.
CREATE OR REPLACE FUNCTION public.prekazky_linie_delete_tf() RETURNS trigger AS
  $$
    BEGIN
      UPDATE audit.prekazky_linie_history
        SET valid_range = tstzrange(lower(valid_range), current_timestamp),
            deleted_by = current_user
        WHERE valid_range @> current_timestamp AND fid = OLD.fid;
      RETURN NULL;
    END;
  $$
  LANGUAGE plpgsql;

CREATE TRIGGER prekazky_linie_delete_trigger
AFTER DELETE ON main.prekazky_linie
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_linie_delete_tf();

-- Create trigger function for update.
CREATE OR REPLACE FUNCTION public.prekazky_linie_update_tf() RETURNS trigger AS
	$$
		BEGIN

			UPDATE audit.prekazky_linie_history
				SET valid_range = tstzrange(lower(valid_range), current_timestamp), deleted_by = current_user
				WHERE valid_range @> current_timestamp AND fid = OLD.fid;

			INSERT INTO audit.prekazky_linie_history
				(fid, geom, poznamka, ops, stav, kategorie, kat_vp, provedeni, delka_gis, delka_vp, delka_sv, valid_range, created_by)
			VALUES
				(NEW.fid, NEW.geom, NEW.poznamka, NEW.ops, NEW.stav, NEW.kategorie, NEW.kat_vp, NEW.provedeni, NEW.delka_gis, NEW.delka_vp, NEW.delka_sv, tstzrange(current_timestamp, NULL), current_user);

			RETURN NEW;

		END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER prekazky_linie_update_trigger
AFTER UPDATE ON main.prekazky_linie
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_linie_update_tf();