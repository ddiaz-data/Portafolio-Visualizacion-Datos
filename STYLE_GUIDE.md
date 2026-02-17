# 🍌 Banana Plot Style Guide & Workflow

Este documento define los estándares de codificación y estructura para el portafolio de Data Science de **Dylan Díaz**.

## 1. Estructura de Proyectos
Cada análisis debe vivir en su propia carpeta numerada para mantener el orden cronológico y temático:
- `00_Config`: Scripts de configuración global o estilos.
- `01_Nombre_Proyecto`: Primer análisis.
- `02_Nombre_Proyecto`: Segundo análisis.

## 2. Encabezado de Scripts (Standard Header)
Todo script de R o Python debe comenzar obligatoriamente con este bloque:

```r
# ==============================================================================
# 🍌 PROYECTO: Portafolio de Data Science | [Visualización / Modelado]
# ------------------------------------------------------------------------------
# SCRIPT:     [Numero]_[Nombre_Descriptivo].R
# AUTOR:      M. en C. Dylan Díaz (@ddiaz-data)
# FECHA:      [Mes Año]
#
# DESCRIPCIÓN:
# [Breve resumen de qué hace el script y qué problema biológico/de datos resuelve]
#
# FUENTES DE DATOS:
# [Lista de librerías clave o fuentes de datos como FAO, CONAPESCA, etc.]
# ==============================================================================
Convenciones de Código
Librerías: Usar tidyverse como base para manipulación de datos.

Gráficos: ggplot2 con tema minimalista (theme_minimal) y patchwork para composición.

Comentarios: Usar líneas separadoras para secciones importantes:
# ------------------------------------------------------------------------------

4. Filosofía de Visualización
Storytelling: Cada gráfico debe responder una pregunta clara (ej. "¿Quién alimenta al mundo?").

Comparación: Priorizar comparaciones de contexto (Global vs Local).

Colores: Usar paletas semánticas consistentes (ej. Azul para Pesca, Verde para Acuacultura).
```
