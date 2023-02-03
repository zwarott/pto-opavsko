-- TRIGGERS FOR NORMAL TABLES.
-- Create trigger for geodeticke_zamereni table.
CREATE TRIGGER geodeticke_zamereni_trigger
BEFORE UPDATE ON detail.geodeticke_zamereni
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for centroidy_atlas table.
CREATE TRIGGER centroidy_atlas_trigger
BEFORE UPDATE ON main.centroidy_atlas
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for hranice_cr table.
CREATE TRIGGER hranice_cr_trigger
BEFORE UPDATE ON main.hranice_cr
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for mrizka_m2000 table.
CREATE TRIGGER mrizka_m2000_trigger
BEFORE UPDATE ON main.mrizka_m2000
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for palebne_zvony table.
CREATE TRIGGER palebne_zvony_trigger
BEFORE UPDATE OR INSERT ON main.palebne_zvony
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_coordinates_tf();

-- Create trigger for pomocne_linie table.
CREATE TRIGGER pomocne_linie_trigger
BEFORE UPDATE ON main.pomocne_linie
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for pozice_srubu_main table.
CREATE TRIGGER pozice_srubu_main_trigger
BEFORE UPDATE OR INSERT ON main.pozice_srubu_main
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_coordinates_tf();

-- Create trigger for pozorovatel_pohled table.
CREATE TRIGGER pozorovatel_pohled_trigger
BEFORE UPDATE ON main.pozorovatel_pohled
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for pozorovatel_pozice table.
CREATE TRIGGER pozorovatel_pozice_trigger
BEFORE UPDATE OR INSERT ON main.pozorovatel_pozice
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_coordinates_tf();

-- Create trigger for prekazky_buffer_50m table.
CREATE TRIGGER prekazky_buffer_50m_trigger
BEFORE UPDATE ON main.prekazky_buffer_50m
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for prekazky_linie table.
CREATE TRIGGER prekazky_linie_trigger
BEFORE UPDATE OR INSERT ON main.prekazky_linie
	FOR EACH ROW EXECUTE PROCEDURE public.prekazky_linie_tf();

-- Create trigger for sruby_ruian table.
CREATE TRIGGER sruby_ruian_trigger
BEFORE UPDATE ON main.sruby_ruian
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for csr_pred_zaborem table.
CREATE TRIGGER csr_pred_zaborem_trigger
BEFORE UPDATE ON overview_13kk.csr_pred_zaborem
	FOR EACH ROW EXECUTE PROCEDURE public.csr_pred_zaborem_tf();

-- Create trigger for pozice_srubu_overview table.
CREATE TRIGGER pozice_srubu_overview_trigger
BEFORE UPDATE OR INSERT ON overview_75k.pozice_srubu_overview
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_coordinates_tf();

-- Create trigger for prubeh_prekazek table.
CREATE TRIGGER prubeh_prekazek_trigger
BEFORE UPDATE ON overview_75k.prubeh_prekazek
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- TRIGGERS FOR LOOKUP TABLES.
-- Create trigger for kat_vp_lookup table.
CREATE TRIGGER kat_vp_lookup_trigger
BEFORE UPDATE ON lookups.kat_vp_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for katastr_lookup table.
CREATE TRIGGER katastr_lookup_trigger
BEFORE UPDATE ON lookups.katastr_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for kategorie_lookup table.
CREATE TRIGGER kategorie_lookup_trigger
BEFORE UPDATE ON lookups.kategorie_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for ops_lookup table.
CREATE TRIGGER ops_lookup_trigger
BEFORE UPDATE ON lookups.ops_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for podusek_lookup table.
CREATE TRIGGER podusek_lookup_trigger
BEFORE UPDATE ON lookups.podusek_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for srub_nazev_lookup table.
CREATE TRIGGER srub_nazev_lookup_trigger
BEFORE UPDATE ON lookups.srub_nazev_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for srub_typ_lookup table.
CREATE TRIGGER srub_typ_lookup_trigger
BEFORE UPDATE ON lookups.srub_typ_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for stav_lookup table.
CREATE TRIGGER stav_lookup_trigger
BEFORE UPDATE ON lookups.stav_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();

-- Create trigger for usek_lookup table.
CREATE TRIGGER usek_lookup_trigger
BEFORE UPDATE ON lookups.usek_lookup
	FOR EACH ROW EXECUTE PROCEDURE public.modified_metadata_tf();