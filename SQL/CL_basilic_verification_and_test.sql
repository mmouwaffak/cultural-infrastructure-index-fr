USE cultural_loom;

-- See the table
SELECT * 
FROM cultural_loom.basilic_for_sql
LIMIT 10;

-- Total row
SELECT COUNT(*) AS total
FROM cultural_loom.basilic_for_sql;

--  Verification : columns
DESCRIBE cultural_loom.basilic_for_sql;

-- NULL ?
SELECT
  SUM(latitude IS NULL)  AS lat_null,
  SUM(longitude IS NULL) AS lon_null,
  COUNT(*)               AS total
FROM cultural_loom.basilic_for_sql;

-- Top 10  cultural infrastructures 
SELECT region, COUNT(*) AS n
FROM cultural_loom.basilic_for_sql
GROUP BY region
ORDER BY n DESC
LIMIT 10;

-- 6) infrastructure equipments - department
SELECT departement, dept_code, COUNT(*) AS n
FROM cultural_loom.basilic_for_sql
GROUP BY departement, dept_code
ORDER BY n DESC
LIMIT 10;

-- Domains- repartition
SELECT domaine, COUNT(*) AS n
FROM cultural_loom.basilic_for_sql
GROUP BY domaine
ORDER BY n DESC;

-- Repartition by type of infrastructure
SELECT type_equipement_ou_lieu, COUNT(*) AS n
FROM cultural_loom.basilic_for_sql
GROUP BY type_equipement_ou_lieu
ORDER BY n DESC
LIMIT 20;

-- 9) Filter on PACA region
SELECT nom, departement, domaine, adresse
FROM cultural_loom.basilic_for_sql
WHERE region = "Provence-Alpes-Côte d'Azur"
LIMIT 50;

-- Random key name research : 'Archives' 
SELECT nom, region, departement, domaine
FROM cultural_loom.basilic_for_sql
WHERE nom LIKE '%Archives%'
LIMIT 50;

-- 11) Verification : latitude and longitude corrects
SELECT nom, latitude, longitude, region, dept_code
FROM cultural_loom.basilic_for_sql
WHERE latitude IS NOT NULL
  AND longitude IS NOT NULL
LIMIT 100;

-- 12) Test of postal code (missing values, abnormal character ...)
SELECT code_postal, COUNT(*) AS n
FROM cultural_loom.basilic_for_sql
WHERE code_postal IS NOT NULL
  AND CHAR_LENGTH(code_postal) > 5
GROUP BY code_postal
ORDER BY n DESC
LIMIT 20;
