# -------------------------------------------------------
# PROYECTO: Banana Plot #01 - El Hibisco (Corrección Tallo + Flor)
# AUTOR: Dylan Díaz (@banana.plot)
# -------------------------------------------------------

library(ggplot2)
library(dplyr)

# 1. PARÁMETROS
n_puntos_flor <- 100000
n_puntos_tallo <- 5000 # Menos puntos para el tallo, para que sea sutil
set.seed(123)

# 2. DATOS DE LA FLOR (Hibisco de 5 pétalos)
flor_datos <- tibble(
  theta = runif(n_puntos_flor, 0, 2 * pi),
  r_intento = runif(n_puntos_flor, 0, 1)
) %>%
  mutate(
    # La fórmula de los 5 pétalos
    limite_petalo = abs(sin(2.5 * theta)) * 0.9 + 0.1
  ) %>%
  filter(r_intento <= limite_petalo) %>%
  mutate(
    # Movemos la flor un poco hacia arriba (y + 0.2) para que quede sobre el tallo
    x = r_intento * cos(theta),
    y = r_intento * sin(theta) + 0.2, 
    dist_centro = r_intento / limite_petalo
  )

# 3. DATOS DEL TALLO (Curva Cuadrática)
tallo_datos <- tibble(
  y = seq(-1.5, 0.2, length.out = n_puntos_tallo),
  # Curva suave hacia la izquierda
  x_base = -0.15 * (y - 0.2)^2, 
  # Ruido para efecto puntillista
  x = x_base + rnorm(n_puntos_tallo, sd = 0.015), 
  y_final = y + rnorm(n_puntos_tallo, sd = 0.01)
)

# 4. EL PLOT (A prueba de fallos)
ggplot() +
  
  # CAPA 1: EL TALLO
  # Lo pintamos de un color verde fijo y transparente
  geom_point(data = tallo_datos, aes(x = x, y = y_final), 
             color = "#4CAF50", size = 0.05, alpha = 0.3) +
  
  # CAPA 2: LA FLOR
  # Aquí sí usamos aes(color=...) para el gradiente rosa
  geom_point(data = flor_datos, aes(x = x, y = y, color = dist_centro), 
             size = 0.05, alpha = 0.6, shape = 16) +
  
  # ESCALA DE COLOR (Solo afecta a la flor)
  scale_color_gradientn(colours = c("#560027", "#C51162", "#FF4081", "#FF80AB")) +
  
  # ESTÉTICA FINAL
  coord_fixed() +
  theme_void() +
  theme(
    legend.position = "none",
    plot.background = element_rect(fill = "white", color = NA), # Fondo casi negro
    plot.margin = margin(0, 0, 0, 0, "cm")
  )

# ggsave("hibisco_final.png", width = 8, height = 8, dpi = 300)
