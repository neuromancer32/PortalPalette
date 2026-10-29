# Regenerates the README figures in man/fig/.
# Run from the package root: source("test.R")

devtools::load_all()
library(ggplot2)

save_fig <- function(plot, file, width = 920, height = 618) {
  ggsave(file.path("man", "fig", file), plot,
         width = width / 96, height = height / 96, dpi = 96)
}

# 1. All palettes, in color and in greyscale ------------------------------
to_grey <- function(hex) {
  rgb <- grDevices::col2rgb(hex) / 255
  lin <- ifelse(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  y <- colSums(lin * c(0.2126, 0.7152, 0.0722))
  g <- ifelse(y <= 0.0031308, 12.92 * y, 1.055 * y^(1 / 2.4) - 0.055)
  grDevices::rgb(g, g, g)
}

swatches <- do.call(rbind, lapply(names(portal_palettes_list()), function(p) {
  cols <- portal_colors(p)
  rbind(
    data.frame(palette = p, version = "color", i = seq_along(cols),
               n = length(cols), hex = unname(cols)),
    data.frame(palette = p, version = "greyscale", i = seq_along(cols),
               n = length(cols), hex = to_grey(unname(cols)))
  )
}))
swatches$palette <- factor(swatches$palette,
                           levels = names(portal_palettes_list()))
swatches$xmin <- (swatches$i - 1) / swatches$n
swatches$xmax <- swatches$i / swatches$n

p_palettes <- ggplot(swatches) +
  geom_rect(aes(xmin = xmin, xmax = xmax, ymin = 0, ymax = 1, fill = hex),
            colour = "white", linewidth = 1) +
  geom_text(data = subset(swatches, version == "color"),
            aes(x = (xmin + xmax) / 2, y = 0.5, label = hex),
            size = 3.2, colour = ifelse(
              subset(swatches, version == "color")$hex %in%
                c("#fce0b6", "#abe1ff", "#c6e8f6", "#bcc699", "#e0a475"),
              "grey20", "white")) +
  scale_fill_identity() +
  facet_grid(palette ~ version, switch = "y") +
  theme_void() +
  theme(strip.text.y.left = element_text(angle = 0, hjust = 1,
                                         face = "bold", size = 12),
        strip.text.x = element_text(face = "bold", size = 12,
                                    margin = margin(b = 6)),
        plot.title = element_text(face = "bold", size = 16,
                                  margin = margin(b = 10)),
        plot.margin = margin(15, 15, 15, 15),
        plot.background = element_rect(fill = "white", colour = NA)) +
  labs(title = "PortalPalette palettes")
save_fig(p_palettes, "Palette.png", height = 1000)

# 2. Discrete scale --------------------------------------------------------
p_sepal <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.9) +
  scale_color_portal("test_chamber") +
  theme_portal(base_size = 13) +
  labs(title = "Sepal dimensions",
       subtitle = 'scale_color_portal("test_chamber")',
       x = "Sepal length (cm)", y = "Sepal width (cm)")
save_fig(p_sepal, "Sepal.png")

# 3. Sequential continuous scale -------------------------------------------
p_eruptions <- ggplot(faithfuld, aes(eruptions, waiting, fill = density)) +
  geom_raster() +
  scale_fill_portal("blue", discrete = FALSE) +
  coord_cartesian(expand = FALSE) +
  theme_portal(base_size = 13) +
  labs(title = "Old Faithful eruptions",
       subtitle = 'scale_fill_portal("blue", discrete = FALSE)',
       x = "Eruption length (min)", y = "Waiting time (min)")
save_fig(p_eruptions, "Eruptions.png")

# 4. Diverging continuous scale with a midpoint ----------------------------
grid <- expand.grid(x = seq(-3, 3, length.out = 120),
                    y = seq(-3, 3, length.out = 120))
grid$z <- sin(grid$x) * cos(grid$y) + 0.3
p_diverging <- ggplot(grid, aes(x, y, fill = z)) +
  geom_raster() +
  scale_fill_portal(discrete = FALSE, midpoint = 0, name = "value") +
  coord_fixed(expand = FALSE) +
  theme_portal(base_size = 13) +
  labs(title = "Diverging data centered on zero",
       subtitle = "scale_fill_portal(discrete = FALSE, midpoint = 0)")
save_fig(p_diverging, "Diverging.png")

# 5. Categorical palettes side by side ----------------------------------------
groups <- data.frame(
  group = factor(paste("Group", LETTERS[1:6]), levels = paste("Group", LETTERS[1:6])),
  value = c(42, 35, 28, 31, 22, 17)
)
cat_plot <- function(p) {
  ggplot(groups, aes(group, value, fill = group)) +
    geom_col(width = 0.75, show.legend = FALSE) +
    scale_fill_portal(p) +
    theme_portal(base_size = 12) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          panel.grid.major.x = element_blank()) +
    labs(title = p, subtitle = sprintf('scale_fill_portal("%s")', p),
         x = NULL, y = NULL)
}
png(file.path("man", "fig", "Categorical.png"), width = 1380, height = 520, res = 110)
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(1, 3)))
for (i in 1:3) {
  print(cat_plot(c("test_chamber", "overgrown", "ratman")[i]),
        vp = grid::viewport(layout.pos.row = 1, layout.pos.col = i))
}
invisible(dev.off())
