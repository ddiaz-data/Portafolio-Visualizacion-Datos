# ==============================================================================
# 🍌 PROYECTO: Portafolio de Data Science | Visualización
# ------------------------------------------------------------------------------
# SCRIPT:     03_Analisis_Pesquero_FAO.R
# AUTOR:      M. en C. Dylan Díaz (@ddiaz-data)
# FECHA:      Febrero 2026
#
# DESCRIPCIÓN:
# Análisis comparativo de tendencias de producción pesquera (Mundo vs. México).
# Se utiliza 'Big Data' de la FAO para contrastar la transición global hacia
# la acuacultura frente a la persistencia de la pesca de captura en México.
#
# OBJETIVO VISUAL:
# Generar un póster (Patchwork) que muestre tendencias temporales (Area Plots)
# y especies principales (Bar Charts) comparando escala Global vs Local.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONFIGURACIÓN Y CARGA DE DATOS
# ------------------------------------------------------------------------------
if (!require("fishstat")) install.packages("fishstat")
if (!require("patchwork")) install.packages("patchwork")

library(tidyverse)
library(fishstat)
library(patchwork)

# Cargar bases de datos de la FAO
data(capture)      # Captura Salvaje
data(aquaculture)  # Acuacultura
data(species)      # Diccionario de Especies
data(country)      # Diccionario de Países

# ------------------------------------------------------------------------------
# 2. PROCESAMIENTO: TENDENCIA MUNDIAL (Global Trend)
# ------------------------------------------------------------------------------
# Objetivo: Unificar captura y acuacultura global por año

total_capture <- capture %>%
  filter(measure == "Q_tlw") %>%
  group_by(year) %>% summarise(tonnes = sum(value, na.rm = TRUE)) %>%
  mutate(sector = "Pesca de Captura")

total_aqua <- aquaculture %>%
  filter(measure == "Q_tlw") %>%
  group_by(year) %>% summarise(tonnes = sum(value, na.rm = TRUE)) %>%
  mutate(sector = "Acuacultura")

global_trend <- bind_rows(total_capture, total_aqua)

# Gráfico A: Tendencia Mundial
grafico_fao <- ggplot(global_trend, aes(x = year, y = tonnes / 1e6, fill = sector)) +
  geom_area(alpha = 0.85, color = "white", size = 0.2) +
  scale_fill_manual(values = c("Pesca de Captura" = "#1f78b4", "Acuacultura" = "#33a02c")) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Tendencia Mundial 🌍",
       y = "Millones de Toneladas", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom", plot.title = element_text(face = "bold"))

# ------------------------------------------------------------------------------
# 3. PROCESAMIENTO: TENDENCIA MÉXICO (Local Trend)
# ------------------------------------------------------------------------------
# Función auxiliar para filtrar por país (DRY Principle)
preparar_pais <- function(dataset, nombre_iso3, sector_nombre) {
  dataset %>%
    left_join(country, by = "country") %>%
    filter(iso3 == nombre_iso3, measure == "Q_tlw") %>%
    group_by(year) %>% summarise(tonnes = sum(value, na.rm = TRUE)) %>%
    mutate(sector = sector_nombre)
}

mex_capture <- preparar_pais(capture, "MEX", "Pesca de Captura")
mex_aqua    <- preparar_pais(aquaculture, "MEX", "Acuacultura")
mexico_trend <- bind_rows(mex_capture, mex_aqua)

# Gráfico B: Tendencia México
grafico_mexico <- ggplot(mexico_trend, aes(x = year, y = tonnes / 1000, fill = sector)) +
  geom_area(alpha = 0.85, color = "white", size = 0.2) +
  scale_fill_manual(values = c("Pesca de Captura" = "#1f78b4", "Acuacultura" = "#33a02c")) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Tendencia México 🇲🇽",
       y = "Miles de Toneladas", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none", plot.title = element_text(face = "bold")) 

# ------------------------------------------------------------------------------
# 4. PROCESAMIENTO: TOP 5 ESPECIES (Mundo vs México)
# ------------------------------------------------------------------------------

# 4.1 Top 5 Mundial (Enfoque: Acuacultura / Verde)
top_especies <- aquaculture %>%
  left_join(species, by = "species") %>%
  filter(measure == "Q_tlw") %>%
  group_by(species_name) %>% 
  summarise(total_tonnes = sum(value, na.rm = TRUE)) %>%
  arrange(desc(total_tonnes)) %>%
  head(5)

grafico_top_global <- ggplot(top_especies, aes(x = reorder(species_name, total_tonnes), y = total_tonnes/1e6)) +
  geom_col(fill = "#33a02c") + 
  coord_flip() +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Top 5 Mundial (Cultivo) 🌍",
       y = "Millones de Toneladas", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# 4.2 Top 5 México (Enfoque: Captura / Azul)
top_mex_capture <- capture %>%
  left_join(country, by = "country") %>%
  filter(iso3 == "MEX", measure == "Q_tlw") %>%
  left_join(species, by = "species") %>%
  group_by(species_name) %>% 
  summarise(total = sum(value, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  head(5)

grafico_top_mex <- ggplot(top_mex_capture, aes(x = reorder(species_name, total), y = total/1e6)) +
  geom_col(fill = "#1f78b4") + 
  coord_flip() +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Top 5 México (Captura) 🇲🇽",
       y = "Millones de Toneladas", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# ------------------------------------------------------------------------------
# 5. MONTAJE FINAL (PATCHWORK) Y EXPORTACIÓN
# ------------------------------------------------------------------------------

poster_final <- (grafico_fao + grafico_mexico) / 
  (grafico_top_global + grafico_top_mex) +
  
  # Diseño General
  plot_layout(guides = "collect") + 
  
  plot_annotation(
    title = 'DEL OCÉANO GLOBAL A LA COSTA MEXICANA 🌊',
    subtitle = 'Comparativa: Mientras el mundo cultiva (Verde), México pesca (Azul).',
    caption = 'Data Science Portfolio: @ddiaz-data | Fuente: FAO FishStat (2024)',
    theme = theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5, color = "grey30"),
      legend.position = "bottom"
    )
  ) & 
  theme(legend.position = "bottom")

# Guardar
print(poster_final)
ggsave("POSTER_FINAL_PESCA_OFICIAL.png", plot = poster_final, width = 12, height = 10, dpi = 300)

# ==============================================================================
# FIN DEL SCRIPT
# ==============================================================================