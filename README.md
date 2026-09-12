# 🌿 Chile CO₂ Historical Evolution: Regional Emissions Study (1990–2022)

Este repositorio contiene el código fuente, los scripts de transformación ETL y la estructura analítica del estudio sobre la **Evolución Histórica de Emisiones y Absorciones de CO₂ en Chile**.

🌐 **[👉 Volver a la Presentación Completa del Proyecto en el Portafolio](https://sites.google.com/view/hector-argomedo-portafolio/inicio)**

---

### 📂 Estructura del Repositorio

* 📝 **[`docs/`](./docs/)**: Bitácora técnica de desarrollo (`data_journal.md`) bajo la metodología **P.D.A.R.** (Problema, Decisión, Acción, Resultado).
* 📜 **[`scripts/`](./scripts/)**: Scripts de Python para la consolidación de 16 archivos regionales `.xlsx` y automatización del proceso ETL.
* 📊 **[`sql/`](./sql/)**: Consultas y scripts de transformación en Google BigQuery para la reestructuración de formato ancho a formato largo mediante `UNPIVOT`.

---

### 🛠️ Tech Stack & Herramientas

* **Processing & ETL:** Python (`pandas`, `glob`, `os`) / Google Colab.
* **Data Warehouse:** Google BigQuery (Consultas SQL y `UNPIVOT`).
* **Data Visualization:** Google Looker Studio.
* **Data Source:** Observatorio de Carbono Neutralidad (16 datasets regionales, 1990–2022).

---

> **Nota:** Este proyecto analiza 33 años de datos históricos de las 16 regiones de Chile para identificar patrones sectoriales, tendencias regionales y capacidad de absorción de CO₂ se usa Google Sheets, Python,Bigquery SQL y Data Studios
