# 🐟 Análisis de Pesquerías Globales y Locales (FAO)

Este módulo contiene un flujo de trabajo de **Ciencia de Datos** aplicado a estadísticas pesqueras históricas (1950-2024). 

El objetivo es contrastar las tendencias globales de la "Revolución Azul" (el auge de la acuacultura) contra la realidad pesquera específica de México, utilizando la base de datos oficial de la FAO a través de R.

## 🎯 Objetivos del Análisis
1.  **Ingeniería de Datos (ETL):** Conexión a la API/Paquete `{fishstat}` para extraer series de tiempo de Captura y Acuacultura (+1 Millón de registros).
2.  **Relational Joins:** Cruce de tablas de producción con diccionarios taxonómicos (Especies) y geográficos (Países) para decodificar los datos.
3.  **Visualización Comparativa:** Generación de un póster analítico que contrasta el panorama mundial vs. el contexto nacional.

## 📊 Principales Hallazgos
* **Tendencia Global:** Existe un "cruce" histórico donde la **Acuacultura** supera a la pesca extractiva en volumen, impulsada principalmente por especies de agua dulce (Carpas).
* **El Caso México 🇲🇽:** A diferencia del promedio mundial, México mantiene una fuerte dependencia de la **Pesca de Captura** (principalmente Sardina y Atún), con la acuacultura creciendo a un ritmo menor.

## 📂 Contenido de la Carpeta

| Archivo | Descripción |
| :--- | :--- |
| `03_Analisis_Pesquero_FAO.R` | **Script Principal.** Contiene todo el flujo: Carga de librerías, limpieza de datos, análisis de Top 5 especies y generación del Póster Final (Patchwork). |
| `POSTER_FINAL_PESCA_OFICIAL.png` | Visualización final exportada en alta calidad. |

## 🛠️ Stack Tecnológico
* **Lenguaje:** R
* **Librerías:** `tidyverse` (manipulación), `fishstat` (datos FAO), `patchwork` (composición gráfica).
* **Fuente de Datos:** FAO Fisheries and Aquaculture Division.

---
[⬅️ Volver al Portafolio Principal](../)