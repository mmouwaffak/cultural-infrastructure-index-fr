SELECT
  COUNT(*) AS total_rows,
  SUM(code_insee LIKE '%,%') AS multi_code_rows,
  ROUND(100 * SUM(code_insee LIKE '%,%') / COUNT(*), 2) AS multi_code_pct
FROM basilic_for_sql
WHERE code_insee IS NOT NULL AND code_insee <> ''; -- multirow : problem



CREATE OR REPLACE VIEW v_basilic_single_commune AS
SELECT *
FROM basilic_for_sql
WHERE code_insee IS NOT NULL
  AND code_insee <> ''
  AND code_insee NOT LIKE '%,%';           -- 12 rows ; integrity
  
SELECT
  (SELECT COUNT(*) FROM basilic_for_sql WHERE code_insee IS NOT NULL AND code_insee <> '') AS total_with_code,
  (SELECT COUNT(*) FROM basilic_for_sql WHERE code_insee LIKE '%,%') AS multi_code_rows,
  (SELECT COUNT(*) FROM v_basilic_single_commune) AS single_commune_rows;             -- total code: 88037 ; multi code row : 12 ; single commune row : 88025
  

SELECT
  COUNT(*) AS total_venues_single_commune,
  COUNT(DISTINCT code_insee) AS communes_covered
FROM v_basilic_single_commune;                      -- total venue : 88025 ; commune covered : 22421


