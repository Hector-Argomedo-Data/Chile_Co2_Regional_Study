CREATE OR REPLACE TABLE `proyecto01-486204.Co2_Caso.niveles_co2` AS
SELECT 
  * EXCEPT(periodo),
  DATE(CAST(periodo AS INT64), 1, 1) AS periodo
FROM `proyecto01-486204.Co2_Caso.niveles_co2`;


CREATE OR REPLACE TABLE `proyecto01-486204.Co2_Caso.niveles_co2` AS
SELECT
  region,
  periodo,
  ind_energia,
  ind_manufactura_const,
  transporte,
  otros_sectores,
  no_especificado,
  emisiones_fugitivas,
  transporte_co2,
  procesos_industriales,
  agricultura,
  uso_tierra_silvicultura,
  residuos,
  est_inventario,
  inventario
FROM `proyecto01-486204.Co2_Caso.niveles_co2`
ORDER BY region ASC, periodo ASC;
