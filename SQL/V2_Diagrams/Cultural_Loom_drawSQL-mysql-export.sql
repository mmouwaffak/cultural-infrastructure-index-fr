CREATE TABLE `regions`(
    `region_code` VARCHAR(10) NOT NULL,
    `region_name` VARCHAR(255) NULL,
    PRIMARY KEY(`region_code`)
);
CREATE TABLE `departments`(
    `dept_code` VARCHAR(10) NOT NULL,
    `dept_name` VARCHAR(255) NULL,
    `region_code` VARCHAR(10) NOT NULL,
    PRIMARY KEY(`dept_code`)
);
CREATE TABLE `communes`(
    `commune_code` VARCHAR(10) NOT NULL,
    `commune_name` VARCHAR(255) NULL,
    `postal_code` VARCHAR(10) NULL,
    `dept_code` VARCHAR(10) NOT NULL,
    `region_code` VARCHAR(10) NOT NULL,
    `population` INT NULL,
    PRIMARY KEY(`commune_code`)
);
ALTER TABLE
    `communes` ADD INDEX `communes_dept_code_index`(`dept_code`);
ALTER TABLE
    `communes` ADD INDEX `communes_region_code_index`(`region_code`);
CREATE TABLE `cultural_venues`(
    `id` VARCHAR(64) NOT NULL,
    `nom` VARCHAR(255) NULL,
    `latitude` DECIMAL(10, 6) NULL,
    `longitude` DECIMAL(10, 6) NULL,
    `code_insee_norm` VARCHAR(10) NULL,
    `code_postal` VARCHAR(10) NULL,
    `region` VARCHAR(255) NULL,
    `departement` VARCHAR(255) NULL,
    `dept_code` VARCHAR(10) NULL,
    `type_equipement_ou_lieu` VARCHAR(255) NULL,
    `domaine` VARCHAR(255) NULL,
    `sous_domaine` VARCHAR(255) NULL,
    `identifiant_qpv_24` VARCHAR(64) NULL,
    `label_et_appellation` TEXT NULL,
    `nombre_fauteuils_de_cinema` INT NULL,
    `nombre_ecrans` INT NULL,
    `multiplexe` VARCHAR(50) NULL,
    `type_de_cinema` VARCHAR(255) NULL,
    `nombre_de_salles_de_theatre` INT NULL,
    `jauge_du_theatre` INT NULL,
    `surface_bibliotheque` INT NULL,
    `nom_du_reseau_de_bibliotheques` VARCHAR(255) NULL,
    `adresse` TEXT NULL,
    `annee_label_appellation` INT NULL,
    `precision_equipement` VARCHAR(255) NULL,
    PRIMARY KEY(`id`)
);
ALTER TABLE
    `cultural_venues` ADD INDEX `cultural_venues_code_insee_norm_index`(`code_insee_norm`);
ALTER TABLE
    `cultural_venues` ADD INDEX `cultural_venues_dept_code_index`(`dept_code`);
CREATE TABLE `income_communes`(
    `code_insee` VARCHAR(10) NOT NULL,
    `median_income` DECIMAL(12, 2) NULL,
    `poverty_rate` DECIMAL(7, 4) NULL,
    `income_d1` DECIMAL(12, 2) NULL,
    `income_d9` DECIMAL(12, 2) NULL,
    `income_inequality_ratio` DECIMAL(10, 4) NULL,
    `gini_index` DECIMAL(10, 4) NULL,
    `income_q1` DECIMAL(12, 2) NULL,
    `income_q3` DECIMAL(12, 2) NULL,
    PRIMARY KEY(`code_insee`)
);
CREATE TABLE `income_iris`(
    `code_iris` VARCHAR(20) NOT NULL,
    `code_insee_norm` VARCHAR(10) NULL,
    `code_insee` VARCHAR(10) NULL,
    `median_income` DECIMAL(12, 2) NULL,
    `poverty_rate` DECIMAL(7, 4) NULL,
    `income_d1` DECIMAL(12, 2) NULL,
    `income_d9` DECIMAL(12, 2) NULL,
    `income_inequality_ratio` DECIMAL(10, 4) NULL,
    `gini_index` DECIMAL(10, 4) NULL,
    `income_q1` DECIMAL(12, 2) NULL,
    `income_q3` DECIMAL(12, 2) NULL,
    PRIMARY KEY(`code_iris`)
);
ALTER TABLE
    `income_iris` ADD INDEX `income_iris_code_insee_norm_index`(`code_insee_norm`);
CREATE TABLE `population_regions`(
    `region_code` VARCHAR(10) NOT NULL,
    `region_name` VARCHAR(255) NULL,
    `nb_arrondissements` INT NULL,
    `nb_cantons` INT NULL,
    `nb_communes` INT NULL,
    `population_municipale` INT NULL,
    `population_totale` INT NULL,
    PRIMARY KEY(`region_code`)
);
CREATE TABLE `department_area`(
    `dept_code` VARCHAR(10) NOT NULL,
    `area_km2` DECIMAL(12, 3) NULL,
    `population_raw` BIGINT NULL,
    `density_raw` DECIMAL(12, 4) NULL,
    `flag_inconsistent` BOOLEAN NULL,
    PRIMARY KEY(`dept_code`)
);
CREATE TABLE `smac_reference`(
    `smac_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `smac_status` VARCHAR(255) NULL,
    `smac_name` VARCHAR(255) NULL,
    `operator_name` VARCHAR(255) NULL,
    `cp` VARCHAR(10) NULL,
    `city` VARCHAR(255) NULL,
    `region` VARCHAR(255) NULL,
    `latitude` DECIMAL(10, 6) NULL,
    `longitude` DECIMAL(10, 6) NULL,
    `dept_code` VARCHAR(10) NULL
);
ALTER TABLE
    `smac_reference` ADD INDEX `smac_reference_dept_code_index`(`dept_code`);
ALTER TABLE
    `cultural_venues` ADD CONSTRAINT `cultural_venues_dept_code_foreign` FOREIGN KEY(`dept_code`) REFERENCES `departments`(`dept_code`);
ALTER TABLE
    `communes` ADD CONSTRAINT `communes_commune_code_foreign` FOREIGN KEY(`commune_code`) REFERENCES `income_communes`(`code_insee`);
ALTER TABLE
    `communes` ADD CONSTRAINT `communes_dept_code_foreign` FOREIGN KEY(`dept_code`) REFERENCES `departments`(`dept_code`);
ALTER TABLE
    `smac_reference` ADD CONSTRAINT `smac_reference_dept_code_foreign` FOREIGN KEY(`dept_code`) REFERENCES `departments`(`dept_code`);
ALTER TABLE
    `departments` ADD CONSTRAINT `departments_dept_code_foreign` FOREIGN KEY(`dept_code`) REFERENCES `department_area`(`dept_code`);
ALTER TABLE
    `cultural_venues` ADD CONSTRAINT `cultural_venues_code_insee_norm_foreign` FOREIGN KEY(`code_insee_norm`) REFERENCES `communes`(`commune_code`);
ALTER TABLE
    `departments` ADD CONSTRAINT `departments_region_code_foreign` FOREIGN KEY(`region_code`) REFERENCES `regions`(`region_code`);
ALTER TABLE
    `regions` ADD CONSTRAINT `regions_region_code_foreign` FOREIGN KEY(`region_code`) REFERENCES `population_regions`(`region_code`);
ALTER TABLE
    `communes` ADD CONSTRAINT `communes_region_code_foreign` FOREIGN KEY(`region_code`) REFERENCES `regions`(`region_code`);
ALTER TABLE
    `income_iris` ADD CONSTRAINT `income_iris_code_insee_norm_foreign` FOREIGN KEY(`code_insee_norm`) REFERENCES `communes`(`commune_code`);