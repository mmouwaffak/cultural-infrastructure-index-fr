USE cultural_loom;


SELECT
  (SELECT COUNT(*) FROM regions_for_sql) AS regions,
  (SELECT COUNT(*) FROM departments_for_sql) AS departments,
  (SELECT COUNT(*) FROM communes_for_sql) AS communes,
  (SELECT COUNT(*) FROM income_communes_for_sql) AS income_communes,
  (SELECT COUNT(*) FROM income_iris_for_sql) AS income_iris,
  (SELECT COUNT(*) FROM population_for_sql) AS population;

