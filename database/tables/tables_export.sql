-- Tabulka 01: obvodove prekazky - celni, tylove.
COPY 
	(
	SELECT ops, kategorie AS obvodova_prekazka, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m, stav, provedeni
		FROM main.prekazky_linie
		WHERE kategorie IN ('CO', 'TO')
		ORDER BY ops, kategorie ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_01.csv' csv header;

-- Tabulka 02: prikopy.
COPY (
    SELECT ops, kategorie AS prikop, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m, stav, provedeni
		FROM main.prekazky_linie
		WHERE kategorie LIKE 'PP-%' OR kategorie LIKE 'LP-%'
		ORDER BY ops, kategorie ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_02.csv' csv header;

-- Tabulka 03: lehke prekazky za prikopem.
COPY (
    SELECT ops, kategorie AS lehka_za_prikopem, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m, stav, provedeni
		FROM main.prekazky_linie
		WHERE kategorie IN ('PLZP', 'LLZP')
		ORDER BY ops, kategorie ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_03.csv' csv header;

-- Tabulka 04: souhrnna delka intervalovych prekazek v ramci useku OP-S.
-- Nelze nektere hodnoty za useky secist, pokud ponechame sloupec "stav" -> nelze sloucit dokoncene x nedokoncene pouze s jednim atributem.
COPY (
    SELECT ops, ROUND(SUM(delka_gis)::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie IN ('PI', 'LI')
		GROUP BY ops
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_04.csv' csv header;

-- Tabulka 05: preruseni intervalovych prekazek.
COPY (
    SELECT ops, kategorie AS intervalova_prekazka, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m, stav, provedeni AS preruseni
		FROM main.prekazky_linie
		WHERE kategorie IN ('PI', 'LI') AND provedeni != 'bez přerušení'
		ORDER BY ops, kategorie ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_05.csv' csv header;

-- Tabulka 06: prirozene prekazky.
COPY (
    SELECT ops, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie = 'PPr'
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_06.csv' csv header;
	
-- Tabulka 07: nahony.
COPY (
    SELECT ops, ROUND(ST_Length(geom)::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie = 'APr'
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_07.csv' csv header;

-- Tabulka 08: obvodove prekazky - celni.
COPY (
    SELECT ops, ROUND(delka_gis::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie = 'CO'
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_08.csv' csv header;

-- Tabulka 09: intervalove prekazky.
COPY (
    SELECT ops, kategorie AS intervalova_prekazka, stav, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie IN ('PI', 'LI')
		GROUP BY ops, kategorie, stav
		ORDER BY ops, kategorie ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_09.csv' csv header;

-- Tabulka 10: prubeh prekazek v ramci OP-S (co videl nepritel).
COPY (
    SELECT ops, ROUND(SUM(ST_LENGTH(geom))::numeric, 2) AS delka_gis_m
		FROM main.prekazky_linie
		WHERE kategorie IN ('PI', 'CO', 'LI', 'LP-s', 'LP-v', 'PP-s', 'PP-v')
		GROUP BY ops
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_10.csv' csv header;

-- Tabulka 11: nadmorska vyska srubu.
COPY (
    SELECT ops, nazev AS nazev_srubu, ROUND((z)::numeric, 2) AS nadmorska_vyska
		FROM main.pozice_srubu_main
		ORDER BY ops ASC
	)
	TO '/Users/zwarott/Documents/GIS/OpavskoPTO/outputs/tabulka_11.csv' csv header;