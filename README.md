# Chile CO₂ Historical Evolution: Regional Emissions Study (1990–2022)

## 📌 Visión General del Proyecto

Este proyecto analiza la evolución histórica de las emisiones y absorciones de dióxido de carbono (CO₂) en Chile a nivel regional durante el período **1990–2022**.

Utilizando registros oficiales del *Observatorio de Carbono Neutralidad*, el estudio integra información de las **16 regiones de Chile** para identificar patrones sectoriales, tendencias regionales y cambios relevantes en las emisiones y absorciones a lo largo de **33 años**.

Los datos regionales fueron consolidados y transformados para permitir su análisis por período, región y sector mediante Google BigQuery y Google Looker Studio.

---

## 🎯 Objetivos de Análisis

* **Análisis sectorial:** Identificar los sectores con mayor contribución a las emisiones y analizar su comportamiento entre regiones.

* **Emisiones y absorciones regionales:** Identificar las regiones con mayores niveles de emisión y aquellas con una mayor contribución a la absorción de CO₂.

* **Análisis temporal:** Examinar la evolución histórica de las emisiones y absorciones durante el período 1990–2022.

* **Detección de anomalías:** Identificar variaciones o cambios relevantes en las series temporales para su posterior análisis.

* **Visualización interactiva:** Desarrollar un dashboard con filtros dinámicos por período, región y sector.

---

## 🛠️ Stack Tecnológico

* **Lenguaje:** Python 3.x
* **Procesamiento de datos:** `pandas`, `glob`, `os`
* **Fuente de datos:** Observatorio de Carbono Neutralidad
* **Datos de origen:** 16 archivos regionales en formato `.xlsx`
* **ETL y consolidación:** Python / Google Colab
* **Base de datos:** Google BigQuery
* **Transformación de datos:** Conversión de formato ancho a formato largo mediante `UNPIVOT`
* **Visualización:** Google Looker Studio
* **Presentación:** Google Slides
