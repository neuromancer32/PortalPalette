# 1. Define base color vector
portal_colors_vec <- c(
  `dark orange` = '#ff5d00',
  `orange`      = '#ff9a00',
  `tan`         = '#fce0b6',
  `light blue`  = '#abe1ff',
  `blue`        = '#00a2ff',
  `dark blue`   = '#0065ff'
)

# 2. Define your list of named palettes
portal_palettes <- list(
  portal = as.character(portal_colors_vec)
)

#' Portal Palette Generator
#' @export
portal_palette <- function(palette = "portal", reverse = FALSE, ...) {
  pal <- portal_palettes[[palette]]

  if (is.null(pal)) {
    stop("Palette '", palette, "' not found.")
  }

  if (reverse) {
    pal <- rev(pal)
  }

  grDevices::colorRampPalette(pal, ...)
}

#' Portal Color Scale for ggplot2 (Lines and Points)
#' @export
scale_color_portal <- function(palette = "portal", discrete = TRUE, reverse = FALSE, ...) {
  pal <- portal_palette(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("colour", paste0("portal_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' Portal Fill Scale for ggplot2 (Bars, Boxplots, and Areas)
#' @export
scale_fill_portal <- function(palette = "portal", discrete = TRUE, reverse = FALSE, ...) {
  # Fixed: Changed ':=' to '<-'
  pal <- portal_palette(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", paste0("portal_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}
