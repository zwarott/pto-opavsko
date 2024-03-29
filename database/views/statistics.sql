-- Total length of fortification in meters.
CREATE VIEW views.prekazky_delka_celkem AS
    SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie;

-- Total length (Absolute in meters + relative) of each stav category (completed/uncompleted) and feature count.
CREATE VIEW views.prekazky_stav AS

WITH total AS (
    SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie
)

SELECT  stav, 
        ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m,  
        ROUND((((SUM(ST_Length(geom)))/(total.delka_celkem_m))*100)::numeric, 2) AS zastoupeni_perc,
        COUNT(*) AS pocet_casti

FROM main.prekazky_linie, total
GROUP BY stav, total.delka_celkem_m
ORDER BY zastoupeni_perc DESC;

-- Detail of completed fortification (OP-S, category, length in meters and feature count).
CREATE VIEW views.prekazky_dokoncene_detail AS
    SELECT ops, kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m, COUNT(*) AS pocet_casti
    FROM main.prekazky_linie
    WHERE stav = 'dokončeno'
    GROUP BY ops, kategorie
    ORDER BY ops ASC;

-- Detail of uncompleted fortification (OP-S, category, length in meters and feature count).
CREATE VIEW views.prekazky_nedokoncene_detail AS
    SELECT ops, kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m, COUNT(*) AS pocet_casti
    FROM main.prekazky_linie
    WHERE stav = 'nedokončeno'
    GROUP BY ops, kategorie
    ORDER BY ops ASC;

-- Total length in meters and feature count of each fortification category.
CREATE VIEW views.prekazky_kategorie AS

WITH total AS (
    SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie
)

SELECT  kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m, 
        ROUND((((SUM(ST_Length(geom)))/(total.delka_celkem_m))*100)::numeric, 2) AS zastoupeni_perc,
        COUNT(*) AS pocet_casti
FROM main.prekazky_linie, total
GROUP BY kategorie, total.delka_celkem_m
ORDER BY delka_m desc;

-- Overview of completed fortification (total length in meters, share of the total completed fortifications, feature count) grouped by fortification category.
CREATE VIEW views.prekazky_dokoncene AS

WITH total AS (
    SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie
	WHERE stav = 'dokončeno'
)

SELECT  kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m,
        ROUND((((SUM(ST_Length(geom)))/(total.delka_celkem_m))*100)::numeric, 2) AS zastoupeni_perc,
        COUNT(*) AS pocet_casti
FROM main.prekazky_linie, total
WHERE stav = 'dokončeno'
GROUP BY kategorie, stav, total.delka_celkem_m
ORDER BY zastoupeni_perc desc;

-- Overview of uncompleted fortification (total length in meters, share of the total uncompleted fortifications, feature count) grouped by fortification category.
CREATE VIEW views.prekazky_nedokoncene AS

WITH total AS (
    SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie
	WHERE stav = 'nedokončeno'
)

SELECT  kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_m,
        ROUND((((SUM(ST_Length(geom)))/(total.delka_celkem_m))*100)::numeric, 2) AS zastoupeni_perc,
        COUNT(*) AS pocet_casti
FROM main.prekazky_linie, total
WHERE stav = 'nedokončeno'
GROUP BY kategorie, stav, total.delka_celkem_m
ORDER BY zastoupeni_perc desc;

-- Overview of each OP-S (total length in meters, completed length, uncompleted length and realtive values).
CREATE VIEW views.prekazky_ops_stav AS

WITH total AS (
	SELECT main.prekazky_linie.ops, ROUND((SUM(ST_Length(main.prekazky_linie.geom)))::numeric, 2) AS delka_celkem_m
	FROM main.prekazky_linie
	GROUP BY prekazky_linie.ops
)

SELECT  total.ops,
        total.delka_celkem_m,
        ROUND(((SELECT SUM(ST_Length(main.prekazky_linie.geom)) AS SUM FROM main.prekazky_linie
            WHERE (((main.prekazky_linie.stav)::text = 'dokončeno'::text) AND ((main.prekazky_linie.ops)::text = (total.ops)::text))))::numeric, 2) AS dokonceno_delka_m,
        ROUND(((SELECT SUM(ST_Length(main.prekazky_linie.geom)) AS SUM FROM main.prekazky_linie
            WHERE (((main.prekazky_linie.stav)::text = 'nedokončeno'::text) AND ((main.prekazky_linie.ops)::text = (total.ops)::text))))::numeric, 2) AS nedokonceno_delka_m,
        ROUND((((((SELECT ROUND((SUM(ST_Length(main.prekazky_linie.geom)))::numeric, 2) AS ROUND FROM main.prekazky_linie
            WHERE (((main.prekazky_linie.stav)::text = 'dokončeno'::text) AND 
                ((main.prekazky_linie.ops)::text = (total.ops)::text))))::double precision / SUM(ST_Length(prekazky_linie.geom))) * (100)::double precision))::numeric, 2) AS dokonceno_per,
        ROUND((((((SELECT ROUND((SUM(ST_Length(main.prekazky_linie.geom)))::numeric, 2) AS ROUND FROM main.prekazky_linie
            WHERE (((main.prekazky_linie.stav)::text = 'nedokončeno'::text) AND 
                ((main.prekazky_linie.ops)::text = (total.ops)::text))))::double precision / SUM(ST_Length(prekazky_linie.geom))) * (100)::double precision))::numeric, 2) AS nedokonceno_per
FROM main.prekazky_linie, total
WHERE ((prekazky_linie.ops)::text = (total.ops)::text)
GROUP BY total.ops, total.delka_celkem_m
ORDER BY total.ops;

-- Overview of each fortification category (total length in meters, completed length, uncompleted length and realtive values).
CREATE VIEW views.prekazky_kategorie_stav AS

WITH total AS (
    SELECT kategorie, ROUND(SUM(ST_Length(geom))::numeric, 2) AS delka_celkem_m
    FROM main.prekazky_linie
    GROUP BY kategorie
)
	
SELECT  total.kategorie,
        total.delka_celkem_m,
		ROUND((SELECT SUM(ST_Length(geom)) FROM main.prekazky_linie WHERE stav = 'dokončeno' AND kategorie = total.kategorie)::numeric, 2) AS dokonceno_delka_m,
		ROUND((SELECT SUM(ST_Length(geom)) FROM main.prekazky_linie WHERE stav = 'nedokončeno' AND kategorie = total.kategorie)::numeric, 2) AS nedokonceno_delka_m,
		ROUND(((SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) FROM main.prekazky_linie
            WHERE stav = 'dokončeno' AND kategorie = total.kategorie)::float / SUM(ST_Length(geom)) * 100)::numeric, 2) AS dokonceno_per,
		ROUND(((SELECT ROUND(SUM(ST_Length(geom))::numeric, 2) FROM main.prekazky_linie
            WHERE stav = 'nedokončeno' AND kategorie = total.kategorie)::float / SUM(ST_Length(geom)) * 100)::numeric, 2) AS nedokonceno_per
FROM main.prekazky_linie, total
WHERE prekazky_linie.kategorie = total.kategorie
GROUP BY total.kategorie, total.delka_celkem_m
ORDER BY kategorie ASC;

-- Overview of fortification parts whose relative length deviation is greater than 5 % ordered descending.
CREATE VIEW views.prekazky_odchylka_5_perc AS

SELECT  ops,
        kategorie,
        delka_gis,
        delka_vp,
        ABS(ROUND(((delka_gis-delka_vp)/(delka_vp/100))::numeric, 2)) AS odchylka_rel
FROM main.prekazky_linie
WHERE delka_vp IS NOT NULL AND ABS(ROUND(((delka_gis-delka_vp)/(delka_vp/100))::numeric, 2)) > 5
GROUP BY ops, kategorie, delka_gis, delka_vp
ORDER BY odchylka_rel desc;