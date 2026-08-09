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
