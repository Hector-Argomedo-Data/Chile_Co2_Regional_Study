# 📓 Data Journal - Proyecto Chile_Co2_Regional_Study

## [Fase 1: Preparación y Estructuración en Google Sheets]

### 1. Tratamiento de Archivos y Estandarización Inicial

- **[P] Problema:** Los datos originales del Observatorio de Carbono Neutralidad se encontraban distribuidos en 16 archivos `.xlsx`, uno por cada región de Chile. Además, las planillas contenían información de años recientes que no se encontraba completamente cerrada.

- **[D] Decisión:** Utilizar información consolidada hasta 2022, correspondiente a un período de 33 años (1990-2022), evitando incorporar años con información incompleta o estimada.

- **[A] Acción:** Se revisaron los archivos regionales originales y se estandarizaron sus nombres para facilitar su identificación y procesamiento automatizado. También se eliminaron las columnas y registros correspondientes a la estimación de inventario que podían generar duplicidad o incorporar información no definitiva.

- **[R] Resultado:** 16 archivos `.xlsx` regionales, correspondientes a 33 años de información (1990-2022), preparados para su procesamiento automatizado mediante Python.


### 2. Normalización de Estructura y Encabezados

- **[P] Problema:** Los archivos presentaban diferencias en nombres de columnas, espacios y nomenclaturas que podían generar problemas al cargar los datos en BigQuery.

- **[D] Decisión:** Estandarizar los nombres de las variables antes de realizar la carga, manteniendo nombres simples y compatibles con SQL.

- **[A] Acción:** Se simplificaron nombres extensos de sectores, se eliminaron espacios problemáticos y se estableció una nomenclatura uniforme para las variables.

- **[R] Resultado:** Las 16 planillas quedaron estructuradas de forma homogénea y listas para ser procesadas como un conjunto.


---

## [Fase 2: Automatización y Consolidación en Python]

### 3. Extracción y Consolidación de los Datos

- **[P] Problema:** Procesar manualmente los 16 archivos regionales aumentaría el riesgo de errores y dificultaría mantener la trazabilidad de la región de origen.

- **[D] Decisión:** Automatizar la lectura y consolidación utilizando Python y Pandas en Google Colab.

- **[A] Acción:** Se utilizaron `glob` para localizar dinámicamente los archivos `.xlsx`, `pandas` para leerlos y `pd.concat()` para unirlos en un único DataFrame maestro. El nombre del archivo fue utilizado temporalmente para identificar automáticamente la región correspondiente.

- **[R] Resultado:** Se obtuvo una tabla maestra de 528 registros:

  **16 regiones × 33 años = 528 registros.**


### 4. Limpieza y Normalización mediante Python

- **[A] Acción:** Se realizaron las siguientes transformaciones:

  * Limpieza de los nombres de las regiones a partir del nombre de archivo.
  * Corrección específica de las regiones `Los Ríos` y `Los Lagos`.
  * Conversión de `periodo` a formato fecha.
  * Resolución de una columna duplicada relacionada con industrias manufactureras y de construcción.
  * Normalización de nombres de columnas para facilitar su utilización en BigQuery.
  * Conversión de `no_especificado` y `trans_co2` a tipo numérico `float`.
  * Reordenamiento de las columnas, colocando `periodo` y `region` al comienzo de la tabla.

- **[R] Resultado:** Se generó el archivo consolidado `datos_co2_1990_2022.csv`, con una estructura homogénea y compatible con BigQuery.


---

## [Fase 3: BigQuery - Carga y Transformación]

### 5. Ingesta del Dataset Consolidado

- **[P] Problema:** El dataset consolidado necesitaba una estructura adecuada para realizar consultas y alimentar posteriormente la herramienta de visualización.

- **[A] Acción:** El archivo CSV generado mediante Python fue cargado en Google BigQuery como tabla histórica regional.

- **[R] Resultado:** Se obtuvo una tabla maestra con 528 registros, correspondiente a las 16 regiones y los 33 años analizados.


### 6. Transformación de Formato Ancho a Formato Largo

- **[P] Problema:** Los 11 sectores de actividad estaban representados como columnas independientes. Esta estructura funciona para almacenar los datos, pero dificulta realizar análisis y visualizaciones dinámicas por sector.

- **[D] Decisión:** Transformar los sectores a formato largo mediante `UNPIVOT`, manteniendo el campo `inventario` fuera de la transformación.

- **[A] Acción:** Se utilizó la función `UNPIVOT` de BigQuery para transformar los 11 sectores en registros individuales, creando las columnas `sector` y `emision`.

- **[R] Resultado:** La tabla pasó de:

  **528 registros**

  a:

  **5.808 registros = 33 años × 16 regiones × 11 sectores.**

- **[Nota metodológica]:** El campo `inventario` se mantuvo como una variable independiente y no se incluyó dentro de los sectores sometidos a `UNPIVOT`, evitando duplicar su valor al nivel de cada sector.


### 7. Validación del Balance de Emisiones

- **[P] Problema:** El valor oficial de `inventario` no coincide exactamente con una simple suma de emisiones positivas menos absorciones negativas de los sectores.

- **[A] Acción:** Se realizaron consultas de validación comparando el inventario oficial con el balance calculado directamente a partir de los sectores.

- **[R] Resultado:** Se comprobó que existen pequeñas diferencias entre ambos valores.

- **[Decisión metodológica]:** Para las visualizaciones comparativas se utiliza un balance calculado directamente a partir de las emisiones y absorciones sectoriales, diferenciando explícitamente entre emisiones brutas, absorción bruta y balance neto.

- **[Nota]:** El inventario oficial se conserva en la fuente de datos como referencia, pero no se interpreta como una simple suma aritmética de los sectores.


---

## [Fase 4: Looker Studio - Visualización y Dashboard]

### 8. Configuración de Datos Geográficos

- **[P] Problema:** Looker Studio no reconocía correctamente algunas regiones chilenas mediante sus nombres, provocando que determinadas regiones no aparecieran en el mapa.

- **[D] Decisión:** Crear campos calculados específicos para proporcionar a Looker Studio una referencia geográfica reconocible.

- **[A] Acción:** Se configuró la dimensión geográfica y se ajustó el tipo de campo a ubicación geográfica. También se revisaron individualmente las regiones que presentaban problemas de reconocimiento.

- **[R] Resultado:** Se logró representar las 16 regiones de Chile correctamente en el mapa coroplético.


### 9. Ordenamiento Geográfico

- **[P] Problema:** Las regiones se ordenaban alfabéticamente, lo que dificultaba interpretar la distribución territorial de norte a sur.

- **[D] Decisión:** Crear un campo numérico auxiliar para establecer un orden geográfico.

- **[A] Acción:** Se creó el campo calculado `orden_geografico`, asignando valores del 1 al 16 según la posición de cada región desde Arica hasta Magallanes.

- **[R] Resultado:** Las regiones pueden visualizarse y ordenarse de forma geográfica, de norte a sur.


### 10. Normalización de Etiquetas para Presentación

- **[P] Problema:** Los nombres utilizados en BigQuery están optimizados para SQL, pero algunos no son adecuados para ser mostrados directamente al público.

- **[A] Acción:** Se crearon campos calculados mediante `CASE` para transformar nombres técnicos como `trans_co2`, `ippu` o `silvicultura` en etiquetas legibles y apropiadas para la presentación.

- **[R] Resultado:** Las visualizaciones utilizan nombres descriptivos y legibles sin modificar los nombres técnicos utilizados en la base de datos.


### 11. Métricas de Emisiones y Absorción

- **Emisiones brutas:** Se calculan considerando únicamente los valores positivos de `emision`.

- **Absorción bruta:** Se calculan a partir de los valores negativos de `emision`, transformándolos en valores positivos para representar visualmente la cantidad de CO₂ absorbida.

- **Balance:** Se obtiene mediante la diferencia entre emisiones brutas y absorción bruta.

- **Nota metodológica:** Un sector o región con balance neto positivo puede contener igualmente componentes de absorción. Por esta razón, para el análisis se diferencian explícitamente las emisiones brutas, la absorción bruta y el balance neto.


---

## [Fase 5: Análisis y Visualización]

### 12. Análisis de los 33 años

El dashboard permite analizar la evolución de las emisiones y absorciones de CO₂ en Chile entre 1990 y 2022, comparando:

- Evolución temporal.
- Distribución regional.
- Emisiones por sector.
- Absorción de CO₂.
- Sectores con mayor contribución a las emisiones.
- Diferencias entre regiones.
- Cambios relevantes a lo largo del período.

El objetivo final es transformar los datos regionales originales en información visual que facilite la identificación de patrones, diferencias territoriales y posibles áreas de interés para la toma de decisiones.
