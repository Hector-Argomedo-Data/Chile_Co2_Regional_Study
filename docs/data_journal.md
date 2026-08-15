# 📓 Data Journal - Proyecto Chile_Co2_Regional_Study

## [Fase 1: Preparación y Estructuración en Google Sheets]

### 1. Tratamiento de Encabezados y Simbología de Tablas Regionales
- **[P] Problema:** Las planillas originales del Observatorio de Carbono Neutralidad venían fragmentadas por regiones, en formato .xlsx, con títulos de columnas con caracteres especiales incompatibles con bases de datos.
- **[D] Decisión:** Crear un molde estándar para la nomenclatura de las planillas en cada región y mantener la estructura original intacta para ser procesada de forma automatizada mediante un script de ETL.
- **[A] Acción:** Se aplicó una limpieza inicial en Google Sheets a los 16 archivos regionales, renombrándolos de manera estandarizada para facilitar su lectura dinámica desde el sistema de archivos.
- **[R] Resultado:** 16 archivos .xlsx estandarizados y listos en Google Drive para ser procesados en bloque por el pipeline de Python.

## [Fase 2: Automatización de Pipeline ETL en Python (Google Colab)]

### 2. Extracción, Transformación, Limpieza Regex e Ingesta a CSV Consolidado

* **[P] Problema:** Combinar manualmente 16 planillas Excel generaba inconsistencias, riesgo de error humano y pérdida de la dimensión geográfica de origen. Además, el año 2024 contenía datos incompletos y los nombres de columnas excedían la longitud óptima para SQL.

* **[D] Decisión:** Diseñar un script automatizado en Python (`pandas`, `glob`, `re`) en Google Colab para consolidar los archivos, inyectar la región mediante metadatos del nombre de archivo, renombrar columnas a formato `snake_case` e imputar nulos.

* **[A] Acción:** Se ejecutó el pipeline ETL con los siguientes pasos clave:

  * **Lectura Dinámica & Metadatos:** Uso de `glob.glob()` para leer los 16 archivos `.xlsx` e inyección de la columna `origen_archivo` con el nombre del fichero.

  * **Consolidación (Union All):** Concatenación de todos los DataFrames mediante `pd.concat()`.

  * **Filtrado de Calidad:** Eliminación de registros pertenecientes al año 2024 por inconsistencia de datos de origen.

  * **Normalización a `snake_case`:** Mapeo mediante un diccionario de nombres (`dicc_col`) para acortar y homogeneizar los 15 encabezados de sectores de emisión.

  * **Limpieza Geográfica con Regex:** Aplicación de Expresiones Regulares (`r"\d+|.xlsx|_"`) sobre la columna `region` para eliminar prefijos numéricos y extensiones, dejando únicamente el nombre limpio de la región.

  * **Imputación de Nulos:** Manejo de valores vacíos con `.fillna(0)` para garantizar la consistencia en cálculos posteriores.

* **[R] Resultado:** Generación automatizada del dataset maestro `Co2_regional_limpio.csv`, totalmente procesado, normalizado y listo para ser cargado en Google BigQuery.

## 🛠️ 3. Fase BigQuery: Ingesta y Transformación de Datos (ETL)

### Step 2.1: Ingesta y Conversión de Tipos de Datos (Date Casting)
* **Problema:** La columna `periodo` se cargó originalmente como `INT64` (ej. `1990`). Los motores de BI no reconocen un entero como una dimensión temporal nativa, lo que impedía construir gráficos de serie de tiempo de forma correcta.
* **Solución SQL:** Se aplicó una transformación utilizando `CAST` y la función `DATE(year, month, day)` para convertir el entero a formato fecha estándar (`YYYY-01-01`).
* **Optimización Adicional:** Se reordenó la estructura de columnas y se ordenó el dataset indexando por `region ASC, periodo ASC`.

### Step 2.2: Normalización de Datos ("Tidy Data" / UNPIVOT)
* **Problema:** Los sectores económicos venían modelados como 11 columnas individuales (*wide format*), dificultando la agregación y el filtrado dinámico en BI.
* **Solución SQL:** Se diseñó la vista `vw_sectores_unpivot` mediante el operador `UNPIVOT`, consolidando las 11 columnas sectoriales en dos únicas dimensiones: `sector` (nombre del sector) y `emision` (métrica en Mt CO₂eq).
* **Aprendizaje de Arquitectura:** Una sola tabla/vista bien modelada en formato largo (*long format*) es capaz de alimentar el 100% de los componentes interactivos del dashboard (gráficos de línea, columnas apiladas, mapas y tablas).

---

## 📊 4. Fase Looker Studio: Modelado Visual y UX

### Step 3.1: Configuración Geográfica
* **Capa Técnica vs. Capa Visual:** Se utilizó la columna `codigo_iso_region` (ej. `CL-AN`) exclusivamente para el motor de geocodificación de Google Maps, asignando la columna `region` para tooltips y controles legibles.
* **Ordenamiento Territorial:** Para evitar el ordenamiento alfabético por defecto, se creó el campo calculado `orden_geografico` (valores numéricos del 1 al 16) para ordenar a Chile lógicamente de Norte a Sur.

### Step 3.2: Limpieza de Etiquetas de Dominio
* **Formateo de Texto:** Las etiquetas técnicas en `snake_case` (ej. `uso_tierra_silvicultura`) se transformaron mediante un campo calculado `CASE` (`sector_formateado`) para presentar nombres ejecutivos con ortografía y tildes oficiales.
