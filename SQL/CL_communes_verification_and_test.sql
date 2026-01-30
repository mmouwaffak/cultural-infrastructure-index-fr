USE cultural_loom;

ALTER TABLE communes_for_sql DROP FOREIGN KEY fk_communes_region;

USE cultural_loom;
TRUNCATE TABLE communes_for_sql;


SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE communes_for_sql;
SET FOREIGN_KEY_CHECKS = 1;


SELECT COUNT(*) FROM communes_for_sql  AS communes;


SELECT COUNT(*) AS invalid_communes
FROM communes_for_sql c
LEFT JOIN regions_for_sql r
  ON r.region_code = c.region_code
WHERE c.region_code IS NOT NULL
  AND c.region_code <> ''
  AND r.region_code IS NULL;                 -- None
  
  
ALTER TABLE communes_for_sql
ADD CONSTRAINT fk_communes_region
FOREIGN KEY (region_code) REFERENCES regions_for_sql(region_code)
ON UPDATE CASCADE
ON DELETE RESTRICT;

SELECT COUNT(*) AS regions FROM regions_for_sql;              -- 18
SELECT COUNT(*) AS departments FROM departments_for_sql;         -- 101
SELECT COUNT(*) AS communes FROM communes_for_sql;                  -- 34875
SELECT COUNT(*) AS income_communes FROM income_communes_for_sql;      -- 0
SELECT COUNT(*) AS income_iris FROM income_iris_for_sql;              -- 0
SELECT COUNT(*) AS population FROM population_for_sql;                 -- 13
