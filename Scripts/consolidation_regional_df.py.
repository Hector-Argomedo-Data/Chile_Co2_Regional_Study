# ==============================================================================
# CASO DE ESTUDIO 3: HUELLA DE CO2 REGIONAL EN CHILE
# Script de ETL (Extracción, Transformación y Carga) para consolidación de datos
# ==============================================================================

import os
import glob
import pandas as pd
from google.colab import drive

# 1. Conexión a Google Drive
drive.mount('/content/drive')

# 2. Búsqueda y lectura dinámica de archivos de origen (.xlsx)
ruta_origen = '/content/drive/MyDrive/Caso de estudio 3 Huella de Co2 Regional en Chile/Archivos Originales/*.xlsx'
archivos_xlsx = glob.glob(ruta_origen)

lista_dataframes = []

for archivo in archivos_xlsx:
    df_temp = pd.read_excel(archivo)
    # Conservar el nombre del archivo de origen para extraer la región posteriormente
    df_temp['origen_archivo'] = os.path.basename(archivo)
    lista_dataframes.append(df_temp)

# 3. Consolidación de tablas regionales en un DataFrame maestro (UNION ALL)
df_maestro = pd.concat(lista_dataframes, ignore_index=True)

# 4. Limpieza de datos: Filtrar registros del año 2024 (datos incompletos/vacíos)
df_maestro.drop(df_maestro[df_maestro['año'] == 2024].index, inplace=True)

# 5. Estandarización y acortamiento de encabezados (Mapeo a snake_case)
dicc_col = {
    'año': 'periodo',
    'Industrias de la energía': 'ind_energia',
    'Industrias manufactureras y de la construcción': 'ind_manufactura_const',
    'Transporte': 'transporte',
    'Otros sectores': 'otros_sectores',
    'No especificado': 'no_especificado',
    'Emisiones fugitivas de combustibles': 'emisiones_fugitivas',
    'Transporte y almacenamiento de CO2': 'transporte_co2',
    'Procesos industriales y uso de productos (IPPU)': 'procesos_industriales',
    'Agricultura': 'agricultura',
    'Uso de la tierra, cambio de uso de la tierra y silvicultura': 'uso_tierra_silvicultura',
    'Residuos': 'residuos',
    'Estimación Inventario': 'est_inventario',
    'Inventario': 'inventario',
    'origen_archivo': 'region'
}

df_maestro.rename(columns=dicc_col, inplace=True)

# 6. Limpieza de la columna 'region' mediante expresiones regulares (Regex)
# Se eliminan prefijos numéricos, la extensión .xlsx y guiones bajos
df_maestro["region"] = (
    df_maestro["region"]
    .str.replace(r"\d+|.xlsx|_", "", regex=True)
    .str.strip()
)

# 7. Tratamiento de valores nulos (Imputación con 0 para mantener consistencia de negocio)
df_maestro = df_maestro.fillna(0)

# 8. Exportación del dataset consolidado y limpio a formato CSV
ruta_guardado = "/content/drive/MyDrive/Caso de estudio 3 Huella de Co2 Regional en Chile/Archivo Procesado/Co2_regional_limpio.csv"
df_maestro.to_csv(ruta_guardado, index=False, encoding="utf-8")

print("¡Proceso ETL completado con éxito! Archivo CSV guardado en Drive.")
