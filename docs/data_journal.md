# 📓 Data Journal - Proyecto Chile_Co2_Regional_Study

## [Fase 1: Preparación y Estructuración en Google Sheets]

### 1. Tratamiento de Inconsistencias, Encabezados y Simbología CMF
- **[P] Problema:** Las planillas originales del Observatorio de Carbono Neutralidad venia fragmentada y con títulos incompatible con SQL símbolos acentos etc.
- **[D] Decisión:** Se decide unir y uniformar las tablas dejándolas listas para la ingesta en Pyhton para su convalidación 
- **[A] Acción:** Se crea un molde estándar para los encabezados y se guardan con un nombre estandar para cada región para fácil identificación y poder usar como referencia para el script en Python para añadir la columna región 
- **[R] Resultado:** 16 archivos uniformados y estandarizados con su nombre respectivo listo para la ingesta en Jupiter Pyhton 
