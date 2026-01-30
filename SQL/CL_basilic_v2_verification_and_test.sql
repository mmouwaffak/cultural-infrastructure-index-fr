

TRUNCATE TABLE cultural_loom.basilic_for_sql;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/basilic_for_sql_v2.csv'
INTO TABLE cultural_loom.basilic_for_sql
CHARACTER SET utf8mb4
FIELDS TERMINATED BY '|'
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@skip_id, nom, latitude, longitude, code_insee, code_postal, region, type_equipement_ou_lieu,
 departement, dept_code, domaine, sous_domaine, identifiant_qpv_24, label_et_appellation,
 nombre_fauteuils_de_cinema, nombre_ecrans, multiplexe, type_de_cinema,
 nombre_de_salles_de_theatre, jauge_du_theatre, surface_bibliotheque,
 nom_du_reseau_de_bibliotheques, adresse, annee_label_appellation, precision_equipement);

SELECT COUNT(*) AS total FROM cultural_loom.basilic_for_sql;


