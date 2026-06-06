# 1. Load your package dynamically
devtools::load_all()

# 2. Load dependencies
library(ggplot2)

# 3. Use your package functions immediately
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_portal(palette = "portal") +
  theme_minimal() +
  labs(
    title = "Sepal Length",
  )

ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
  geom_raster() +
  scale_fill_portal(palette = "portal", discrete = FALSE, reverse = TRUE) +
  theme_minimal() +
  labs(
    title = "Eruptions",
  )

# Create a dummy dataset of 6 items
palette_data <- data.frame(
  x = factor(1:6),
  y = 1
)

ggplot(palette_data, aes(x = x, y = y, fill = x)) +
  geom_col(show.legend = FALSE) +
  scale_fill_portal(palette = "portal") +
  theme_void() +
  labs(title = "Portal Palette")
