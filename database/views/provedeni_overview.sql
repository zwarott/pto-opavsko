-- Create overviews for each fortification part
DROP VIEW IF EXISTS views.provedeni_06;
CREATE VIEW views.provedeni_06 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '06'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_09;
CREATE VIEW views.provedeni_09 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '09'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_10;
CREATE VIEW views.provedeni_10 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '10'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_11;
CREATE VIEW views.provedeni_11 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '11'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_12;
CREATE VIEW views.provedeni_12 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '12'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_13;
CREATE VIEW views.provedeni_13 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '13'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_14;
CREATE VIEW views.provedeni_14 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '14'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_15;
CREATE VIEW views.provedeni_15 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '15'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_16;
CREATE VIEW views.provedeni_16 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '16'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_17;
CREATE VIEW views.provedeni_17 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '17'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_18;
CREATE VIEW views.provedeni_18 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '18'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_19;
CREATE VIEW views.provedeni_19 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '19'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_20;
CREATE VIEW views.provedeni_20 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '20'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_21;
CREATE VIEW views.provedeni_21 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '21'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_22;
CREATE VIEW views.provedeni_22 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '22'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_23;
CREATE VIEW views.provedeni_23 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '23'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_24;
CREATE VIEW views.provedeni_24 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '24'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_25;
CREATE VIEW views.provedeni_25 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '25'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_26;
CREATE VIEW views.provedeni_26 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '26'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_27;
CREATE VIEW views.provedeni_27 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '27'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_28;
CREATE VIEW views.provedeni_28 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '28'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_29;
CREATE VIEW views.provedeni_29 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '29'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_30;
CREATE VIEW views.provedeni_30 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '30'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_31;
CREATE VIEW views.provedeni_31 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '31'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_32;
CREATE VIEW views.provedeni_32 AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '32'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_36a;
CREATE VIEW views.provedeni_36a AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '36a'
GROUP BY provedeni
ORDER BY provedeni;

DROP VIEW IF EXISTS views.provedeni_36b;
CREATE VIEW views.provedeni_36b AS
SELECT 
    provedeni,
    STRING_AGG(kategorie, ', ') AS kategorie,
    STRING_AGG(stav, ', ') AS stav,
    STRING_AGG(CAST(delka_gis AS VARCHAR), ', ') AS delka_gis,
    STRING_AGG(CAST(delka_vp AS VARCHAR), ', ') AS delka_vp,
    STRING_AGG(CAST(delka_sv AS VARCHAR), ', ') AS delka_sv    
FROM main.prekazky_linie
WHERE ops = '36b'
GROUP BY provedeni
ORDER BY provedeni;
