-- =============================================================================
-- Project: Chile CO2 / GHG Inventory Analysis (1990-2022)
-- Script: 01_create_vw_sectores_unpivot.sql
-- Engine: Google BigQuery
-- Author: Hector Daniel Argomedo Carrasco
-- Description: Se cambia el tipo de la columna fecha para que sea compatible
                con la ingesta de datos en los graficos y evitar que genere conflicto
-- =============================================================================

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


-- =============================================================================
-- Project: Chile CO2 / GHG Inventory Analysis (1990-2022)
-- Script: 02_create_vw_sectores_unpivot.sql
-- Engine: Google BigQuery
-- Author: Hector Daniel Argomedo Carrasco
-- Description: Despivotar las columnas de sector a un esquema normalizado (formato largo)
--              para optimizar la agregación y el filtrado cruzado en Looker Studio.
-- =============================================================================

CREATE OR REPLACE VIEW `proyecto01-486204.Co2_Caso.vw_sectores_unpivot` AS
SELECT
  region,
  codigo_iso_region,
  periodo,
  sector,
  emision
FROM
  `proyecto01-486204.Co2_Caso.niveles_co2`
UNPIVOT(
  emision FOR sector IN (
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
    residuos
  )
);


-- =============================================================================
-- Project: Chile CO2 / GHG Inventory Analysis (1990-2022)
-- Script: 03_looker_orden_geografico.sql
-- Tool: Looker Studio Calculated Field / BigQuery SQL
-- Description: Asocia las regiones con su secuencia geográfica (de norte a sur, del 1 al 16)
--              para garantizar una ordenación espacial lógica en las visualizaciones.
-- =============================================================================

CASE
  WHEN REGEXP_CONTAINS(region, 'Arica') THEN 1
  WHEN REGEXP_CONTAINS(region, 'Tarapac') THEN 2
  WHEN REGEXP_CONTAINS(region, 'Antofagasta') THEN 3
  WHEN REGEXP_CONTAINS(region, 'Atacama') THEN 4
  WHEN REGEXP_CONTAINS(region, 'Coquimbo') THEN 5
  WHEN REGEXP_CONTAINS(region, 'Valpara') THEN 6
  WHEN REGEXP_CONTAINS(region, 'Metropolitana|RM') THEN 7
  WHEN REGEXP_CONTAINS(region, 'Higgins') THEN 8
  WHEN REGEXP_CONTAINS(region, 'Maule') THEN 9
  WHEN REGEXP_CONTAINS(region, 'Ñuble|Nuble') THEN 10
  WHEN REGEXP_CONTAINS(region, 'Bio|Bío') THEN 11
  WHEN REGEXP_CONTAINS(region, 'Araucan') THEN 12
  WHEN REGEXP_CONTAINS(region, 'Ríos|Rios') THEN 13
  WHEN REGEXP_CONTAINS(region, 'Lagos') THEN 14
  WHEN REGEXP_CONTAINS(region, 'Aysén|Aysen|Ibáñez|Ibañez') THEN 15
  WHEN REGEXP_CONTAINS(region, 'Magallanes') THEN 16
  ELSE 99
END


-- =============================================================================
-- Project: Chile CO2 / GHG Inventory Analysis (1990-2022)
-- Script: 04_looker_sector_formateado.sql
-- Tool: Looker Studio Calculated Field
-- Description: Limpiar snake_case en sectores tecnicos para que tenga una lectura
                mas comprensible y humana 
-- =============================================================================

CASE
  WHEN LOWER(sector) = 'ind_energia' THEN 'Industria Energética'
  WHEN LOWER(sector) = 'ind_manufactura_const' THEN 'Manufactura y Construcción'
  WHEN LOWER(sector) = 'transporte' THEN 'Transporte'
  WHEN LOWER(sector) = 'otros_sectores' THEN 'Otros Sectores'
  WHEN LOWER(sector) = 'no_especificado' THEN 'No Especificado'
  WHEN LOWER(sector) = 'emisiones_fugitivas' THEN 'Emisiones Fugitivas'
  WHEN LOWER(sector) = 'transporte_co2' THEN 'Transporte CO₂'
  WHEN LOWER(sector) = 'procesos_industriales' THEN 'Procesos Industriales'
  WHEN LOWER(sector) = 'agricultura' THEN 'Agricultura'
  WHEN LOWER(sector) = 'uso_tierra_silvicultura' THEN 'Uso de la Tierra y Silvicultura'
  WHEN LOWER(sector) = 'residuos' THEN 'Residuos'
  ELSE sector
END
