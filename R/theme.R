#' A clean ggplot2 theme to pair with the Portal palettes
#'
#' A minimal white theme in the spirit of Aperture Science test chambers:
#' light grey gridlines, no minor grid, grey axis text, a bold left-aligned
#' title and bold facet labels.
#'
#' @param base_size Base font size, in points.
#' @param base_family Base font family.
#'
#' @return A ggplot2 theme object.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_portal() +
#'   theme_portal() +
#'   labs(title = "Sepal dimensions", subtitle = "by species")
theme_portal <- function(base_size = 11, base_family = "") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background   = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid.major  = ggplot2::element_line(colour = "grey90",
                                                linewidth = 0.4),
      panel.grid.minor  = ggplot2::element_blank(),
      axis.text         = ggplot2::element_text(colour = "grey35"),
      axis.title        = ggplot2::element_text(colour = "grey20"),
      axis.ticks        = ggplot2::element_line(colour = "grey80"),
      plot.title        = ggplot2::element_text(face = "bold",
                                                size = ggplot2::rel(1.25),
                                                colour = "grey10"),
      plot.subtitle     = ggplot2::element_text(colour = "grey40"),
      plot.caption      = ggplot2::element_text(colour = "grey50"),
      plot.title.position = "plot",
      legend.title      = ggplot2::element_text(colour = "grey20"),
      strip.text        = ggplot2::element_text(face = "bold",
                                                colour = "grey20",
                                                hjust = 0)
    )
}
