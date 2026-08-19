# ============================================================
# Proyecto: Análisis de emisiones de CO2 en Chile (1990-2022)
# Proceso: Consolidación y preparación de datos
# Herramientas: Python / Pandas / Google Colab
# Autor: Hector Daniel Argomedo Carrasco
# ============================================================
import os
import glob
import pandas as pd
# ------------------------------------------------------------
# 1. Conectar Google Drive y localizar los archivos originales
# ------------------------------------------------------------

from google.colab import drive
drive.mount('/content/drive')

archivos_xlsx = glob.glob(
    '/content/drive/MyDrive/Caso de estudio 3 Huella de Co2 Regional en Chile/Archivos Originales/*.xlsx'
)


# ------------------------------------------------------------
# 2. Leer y consolidar los 16 archivos regionales
# ------------------------------------------------------------

lista_dataframes = []

for archivo in archivos_xlsx:
    df_temp = pd.read_excel(archivo)

    # Se conserva el nombre del archivo para identificar la región
    df_temp['region'] = os.path.basename(archivo)

    lista_dataframes.append(df_temp)

# Se unen todos los DataFrames en una única tabla maestra
df_maestro = pd.concat(lista_dataframes, ignore_index=True)


# ------------------------------------------------------------
# 3. Limpiar y normalizar el nombre de las regiones
# ------------------------------------------------------------

# Se eliminan números, extensión del archivo y guiones bajos
# utilizados originalmente para identificar los archivos regionales.
df_maestro["region"] = (
    df_maestro["region"]
    .str.replace(r"\d+|\.xlsx|_", "", regex=True)
    .str.strip()
)


# ------------------------------------------------------------
# 4. Convertir el período a formato fecha
# ------------------------------------------------------------

# Los datos son anuales, por lo que cada año se convierte
# al formato de fecha para facilitar su uso posterior.
df_maestro['periodo'] = pd.to_datetime(
    df_maestro['periodo'].astype(str),
    format='%Y'
)


# ------------------------------------------------------------
# 5. Unificar una columna con nombre duplicado
# ------------------------------------------------------------

# Algunos archivos contenían la misma variable con dos nombres
# diferentes. Se utilizan ambas columnas para recuperar los
# valores disponibles y posteriormente eliminar la duplicada.

df_maestro['in_manufactur_y_ const'] = (
    df_maestro['in_manufactur_y_ const']
    .fillna(df_maestro['ind_manufactur_y_ const'])
)

df_maestro = df_maestro.drop(
    columns=['ind_manufactur_y_ const']
)


# ------------------------------------------------------------
# 6. Normalizar nombres específicos de regiones
# ------------------------------------------------------------

# Se corrigen los nombres de Los Ríos y Los Lagos para evitar
# problemas de interpretación y facilitar su utilización
# posterior en visualizaciones geográficas.

correccion_regiones = {
    'LosRios': 'Los Ríos',
    'LosLagos': 'Los Lagos'
}

df_maestro['region'] = df_maestro['region'].replace(
    correccion_regiones
)


# ------------------------------------------------------------
# 7. Definir la estructura final de la tabla
# ------------------------------------------------------------

# Esta lista selecciona las columnas que se conservarán
# y establece su orden final.
#
# Se coloca período y región al comienzo para facilitar el
# análisis posterior en BigQuery y Looker Studio.

columnas = [
    'periodo',
    'region',
    'energia',
    'in_manufactur_y_ const',
    'transporte',
    'otros_sectores',
    'no_especificado',
    'emisiones_fugitivas',
    'trans_co2',
    'ippu',
    'agricultura',
    'silvicultura',
    'residuos',
    'inventario'
]

df_maestro = df_maestro[columnas]


# ------------------------------------------------------------
# 8. Normalizar nombres de columnas
# ------------------------------------------------------------

# Se eliminan espacios y caracteres problemáticos para
# asegurar compatibilidad con BigQuery y SQL.

df_maestro = df_maestro.rename(columns={
    "in_manufactur_y_ const": "in_manufactur_y_const"
})


# ------------------------------------------------------------
# 9. Normalizar tipos de datos
# ------------------------------------------------------------

# Se convierten estas columnas a FLOAT64 para mantener
# consistencia entre los sectores antes de cargarlos
# posteriormente en BigQuery.

df_maestro["no_especificado"] = (
    df_maestro["no_especificado"].astype(float)
)

df_maestro["trans_co2"] = (
    df_maestro["trans_co2"].astype(float)
)


# ------------------------------------------------------------
# 10. Exportar el DataFrame consolidado a CSV
# ------------------------------------------------------------

ruta_salida = (
    '/content/drive/MyDrive/'
    'Caso de estudio 3 Huella de Co2 Regional en Chile/'
    'datos_co2_1990_2022.csv'
)

df_maestro.to_csv(
    ruta_salida,
    index=False,
    encoding='utf-8-sig'
)

print("CSV guardado correctamente.")
