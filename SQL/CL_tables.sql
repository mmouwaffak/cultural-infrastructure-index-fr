USE cultural_loom;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS basilic_communes;
DROP TABLE IF EXISTS basilic_for_sql;
DROP TABLE IF EXISTS income_iris_for_sql;
DROP TABLE IF EXISTS income_communes_for_sql;
DROP TABLE IF EXISTS communes_for_sql;
DROP TABLE IF EXISTS departments_for_sql;
DROP TABLE IF EXISTS population_for_sql;
DROP TABLE IF EXISTS regions_for_sql;

SET FOREIGN_KEY_CHECKS = 1;


-- Risk of confusion is high : similar columns name, multiple codes ...
-- Solution : use of ' COMMENT' -->  metadata are stored in the schema.
-- It’s attached to the column (or table) and can be read later via tools or queries.
-- 'SHOW FULL COLUMNS FROM table_01;' --> show column label + its stored description

-- UTF8 is a deprecated synonym for utf8mb3: will be removed in a future version of MySQL. Specify utfmb3 or (preferably) utfmb4 instead.



CREATE TABLE regions_for_sql (
  region_name VARCHAR(255) NULL COMMENT 'Region name (source)',
  region_code VARCHAR(255) NOT NULL COMMENT 'INSEE region code (source)',
  PRIMARY KEY (region_code)
);




CREATE TABLE population_for_sql (
  region_code VARCHAR(255) NOT NULL COMMENT 'INSEE region code (FK to regions_for_sql)',
  region_name VARCHAR(255) NULL COMMENT 'Region name (source)',
  nb_arrondissements VARCHAR(255) NULL,
  nb_cantons VARCHAR(255) NULL,
  nb_communes VARCHAR(255) NULL,
  population_municipale VARCHAR(255) NULL,
  population_totale VARCHAR(255) NULL,
  PRIMARY KEY (region_code),
  CONSTRAINT fk_population_region
    FOREIGN KEY (region_code) REFERENCES regions_for_sql(region_code)
);




CREATE TABLE departments_for_sql (
  dept_code VARCHAR(255) NOT NULL COMMENT 'Department code column as in CSV (may be swapped)',
  dept_name VARCHAR(255) NOT NULL COMMENT 'Department name column as in CSV (may be swapped)',
  region_code VARCHAR(255) NOT NULL COMMENT 'Parent region code',
  PRIMARY KEY (dept_code),
  KEY idx_departments_region_code (region_code),
  CONSTRAINT fk_departments_region
    FOREIGN KEY (region_code) REFERENCES regions_for_sql(region_code)
);




CREATE TABLE communes_for_sql (
  commune_name VARCHAR(255) NULL,
  postal_code VARCHAR(255) NULL,
  dept_code VARCHAR(255) NULL,
  region_code VARCHAR(255) NULL,
  commune_code VARCHAR(255) NOT NULL COMMENT 'INSEE commune code',
  population VARCHAR(255) NULL,
  PRIMARY KEY (commune_code),
  KEY idx_communes_postal_code (postal_code),
  KEY idx_communes_dept_code (dept_code),
  KEY idx_communes_region_code (region_code),
  CONSTRAINT fk_communes_region
    FOREIGN KEY (region_code) REFERENCES regions_for_sql(region_code)
);




CREATE TABLE income_communes_for_sql (
  code_insee VARCHAR(64) NOT NULL COMMENT 'INSEE commune code',
  median_income VARCHAR(255) NULL,
  poverty_rate VARCHAR(255) NULL,
  income_d1 VARCHAR(255) NULL,
  income_d9 VARCHAR(255) NULL,
  income_inequality_ratio VARCHAR(255) NULL,
  gini_index VARCHAR(255) NULL,
  income_q1 VARCHAR(255) NULL,
  income_q3 VARCHAR(255) NULL,
  PRIMARY KEY (code_insee),
  CONSTRAINT fk_income_communes_commune
    FOREIGN KEY (code_insee) REFERENCES communes_for_sql(commune_code)
);



CREATE TABLE income_iris_for_sql (
  code_iris VARCHAR(255) NOT NULL,
  code_insee VARCHAR(255) NULL COMMENT 'Parent commune INSEE code',
  median_income VARCHAR(255) NULL,
  poverty_rate VARCHAR(255) NULL,
  income_d1 VARCHAR(255) NULL,
  income_d9 VARCHAR(255) NULL,
  income_inequality_ratio VARCHAR(255) NULL,
  gini_index VARCHAR(255) NULL,
  income_q1 VARCHAR(255) NULL,
  income_q3 VARCHAR(255) NULL,
  PRIMARY KEY (code_iris),
  KEY idx_income_iris_code_insee (code_insee),
  CONSTRAINT fk_income_iris_commune
    FOREIGN KEY (code_insee) REFERENCES communes_for_sql(commune_code)
);



CREATE TABLE basilic_for_sql (
  id VARCHAR(32) NOT NULL,
  nom VARCHAR(255) NULL,
  latitude VARCHAR(32) NULL,
  longitude VARCHAR(32) NULL,
  code_insee VARCHAR(255) NULL COMMENT 'Raw field; may contain multiple comma-separated INSEE codes',
  code_postal VARCHAR(255) NULL,
  region VARCHAR(255) NULL,
  type_equipement_ou_lieu VARCHAR(255) NULL,
  departement VARCHAR(255) NULL,
  dept_code VARCHAR(10) NULL,
  domaine VARCHAR(255) NULL,
  sous_domaine VARCHAR(255) NULL,
  identifiant_qpv_24 VARCHAR(255) NULL,
  label_et_appellation TEXT NULL,
  nombre_fauteuils_de_cinema VARCHAR(32) NULL,
  nombre_ecrans VARCHAR(32) NULL,
  multiplexe VARCHAR(32) NULL,
  type_de_cinema VARCHAR(255) NULL,
  nombre_de_salles_de_theatre VARCHAR(32) NULL,
  jauge_du_theatre VARCHAR(32) NULL,
  surface_bibliotheque VARCHAR(32) NULL,
  nom_du_reseau_de_bibliotheques VARCHAR(255) NULL,
  adresse TEXT NULL,
  annee_label_appellation VARCHAR(32) NULL,
  precision_equipement VARCHAR(255) NULL,
  PRIMARY KEY (id),
  KEY idx_basilic_code_insee (code_insee),
  KEY idx_basilic_dept_code (dept_code),
  KEY idx_basilic_domaine (domaine)
);



