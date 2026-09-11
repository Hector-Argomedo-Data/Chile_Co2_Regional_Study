-- =============================================================================
-- Project: Chile CO2 / GHG Inventory Analysis (1990-2022)
-- Script: Co2_Caso.unpivot_co2
-- Engine: Google BigQuery
-- Author: Hector Daniel Argomedo Carrasco
-- Description: -- Transforma la tabla histórica desde formato ancho a formato
-- largo mediante la función UNPIVOT, convirtiendo los sectores
-- de actividad en filas y consolidando sus emisiones en una
-- única columna.
-- =============================================================================

CREATE OR REPLACE TABLE `proyecto01-486204.Co2_Caso.unpivot_co2` AS

SELECT
  periodo,
  region,
  sector,
  emision,
  inventario

FROM `proyecto01-486204.Co2_Caso.co2_historico_nacional`

UNPIVOT(
  emision
  FOR sector IN (
    energia,
    `in_manufactur_y_const`,
    transporte,
    otros_sectores,
    no_especificado,
    emisiones_fugitivas,
    trans_co2,
    ippu,
    agricultura,
    silvicultura,
    residuos
  )
)

ORDER BY
  periodo,
  region,
  sector;
