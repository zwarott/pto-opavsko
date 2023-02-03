-- TRIGGER FUNCTIONS

-- Create trigger function for filling selected metadata columns.
-- Tables: lookup tables + most of normal tables.
CREATE FUNCTION public.modified_metadata_tf()
RETURNS trigger AS
	$$
		BEGIN
				NEW.date_modified = now();
				NEW.modified_by = "current_user"();
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

-- Create trigger function for metadata info and x, y coordinates.
-- Tables: palebne_zvony, pozice_srubu_main, pozice_srubu_overview, pozorovatel_pozice.
CREATE FUNCTION public.metadata_coordinates_tf()
RETURNS trigger AS
	$$
		BEGIN
			IF 
				NEW.date_created IS NULL
			THEN
				NEW.x = ROUND(ST_X(NEW.geom)::numeric, 2);
				NEW.y = ROUND(ST_Y(NEW.geom)::numeric, 2);
				NEW.created_by = "current_user"();
				NEW.date_created = now();
			ELSE
				NEW.x = ROUND(ST_X(NEW.geom)::numeric, 2);
				NEW.y = ROUND(ST_Y(NEW.geom)::numeric, 2);
				NEW.modified_by = "current_user"();
				NEW.date_modified = now();
			END IF;
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

-- Create trigger function for prekazky_linie table.
CREATE FUNCTION public.prekazky_linie_tf()
RETURNS trigger AS
	$$
		BEGIN
			IF 
				NEW.date_created IS NOT NULL and NEW.kategorie = 'CO'
			THEN
				NEW.delka_gis = ROUND(ST_Length(NEW.geom)::numeric, 2);
				NEW.provedeni = ROUDN(ST_Length(NEW.geom) / 1.15) ||' sloupů';
				NEW.modified_by = "current_user"(); 
				NEW.date_modified = now();
			END IF;
			IF 
				NEW.date_created IS NOT NULL AND NEW.kategorie != 'CO'
			THEN
				NEW.delka_gis = ROUND(ST_Length(NEW.geom)::numeric, 2); 
				NEW.modified_by = "current_user"(); 
				NEW.date_modified = now();
			END IF;
			IF 
				NEW.date_created IS NULL AND NEW.kategorie = 'CO' 
			THEN
				NEW.delka_gis = ROUND(ST_Length(NEW.geom)::numeric, 2);
				NEW.provedeni = ROUND(ST_Length(NEW.geom) / 1.15) ||' sloupů'; 
				NEW.created_by = "current_user"();
				NEW.date_created = now();
			END IF;
			IF 
				NEW.date_created IS NULL AND NEW.kategorie != 'CO' 
			THEN
				NEW.delka_gis = ROUND(ST_Length(NEW.geom)::numeric, 2);
				NEW.created_by = "current_user"();
				NEW.date_created = now();
			END IF;
			RETURN NEW;
		END;
	$$
	LANGUAGE plpgsql;

-- Create trigger function for csr_pred_zaborem table.
CREATE FUNCTION public.csr_pred_zaborem_tf()
RETURNS trigger AS
	$$
		BEGIN
				NEW.vymera_skm = ROUND(((ST_Area(NEW.geom))/1000000)::numeric, 2);
				NEW.modified_by = "current_user"();
				NEW.date_modified = now();
			RETURN NEW;
		END;
	$$ 
	LANGUAGE plpgsql;