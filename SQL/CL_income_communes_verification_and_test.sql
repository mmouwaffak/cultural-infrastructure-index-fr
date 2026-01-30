
USE cultural_loom;

TRUNCATE TABLE income_communes_for_sql;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/income_communes_for_sql.csv'
INTO TABLE income_communes_for_sql
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(code_insee, median_income, poverty_rate, income_d1, income_d9, income_inequality_ratio, gini_index, income_q1, income_q3);
;

SELECT COUNT(*) FROM income_communes_for_sql;   -- 1887


SELECT COUNT(*) AS header_like_rows
FROM income_communes_for_sql
WHERE code_insee LIKE '%code_insee%';

SELECT COUNT(*) AS empty_keys
FROM income_communes_for_sql
WHERE code_insee IS NULL OR TRIM(code_insee) = '';