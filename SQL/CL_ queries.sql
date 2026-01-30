USE cultural_loom;



-- Data quality check : "how many BASILIC rows are usable for commune joins?"

SELECT
  COUNT(*) AS total_venues,
  SUM(code_insee IS NOT NULL AND code_insee <> '') AS venues_with_code,
  SUM(code_insee LIKE '%,%') AS multi_code_rows,                                -- % : 'joker' character
  (SELECT COUNT(*) FROM v_basilic_single_commune) AS single_commune_rows
FROM basilic_for_sql;               -- venues with code : 88037 ; multi code row : 12 ; single commune rows : 88025


-- Join integrity verification : search of Basilic codes who do not match any commune
SELECT
  COUNT(*) AS unmatched_basilic_rows
FROM v_basilic_single_commune b
LEFT JOIN communes_for_sql c
  ON c.commune_code = b.code_insee
WHERE c.commune_code IS NULL;              -- 5005


-- Department, by order: "where are the most cultural venues?" (top 10)
SELECT
  d.dept_code,
  d.dept_name,
  COUNT(*) AS venue_count
FROM departments_for_sql d
JOIN basilic_for_sql b
  ON b.dept_code = d.dept_code
GROUP BY d.dept_code, d.dept_name
ORDER BY venue_count DESC
LIMIT 10;


-- Business insight : Commune + income + venue count (top 10)
SELECT
  c.commune_code,
  c.commune_name,
  ic.median_income,
  COUNT(*) AS venue_count
FROM communes_for_sql c
JOIN income_communes_for_sql ic
  ON ic.code_insee = c.commune_code
JOIN v_basilic_single_commune b
  ON b.code_insee = c.commune_code
GROUP BY c.commune_code, c.commune_name, ic.median_income
ORDER BY venue_count DESC
LIMIT 10;                            -- 1 : Bordeaux



