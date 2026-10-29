# ggplot2 3.5.0 deprecated the `scale_name` argument of discrete_scale(),
# while earlier versions require it. Supply it only where needed.
portal_discrete_scale <- function(aesthetics, palette, pal, na.value, ...) {
  if (utils::packageVersion("ggplot2") >= "3.5.0") {
    ggplot2::discrete_scale(aesthetics, palette = pal, na.value = na.value, ...)
  } else {
    ggplot2::discrete_scale(aesthetics, paste0("portal_", palette),
                            palette = pal, na.value = na.value, ...)
  }
}

portal_continuous_scale <- function(aesthetics, pal, midpoint, na.value, ...) {
  args <- list(colours = pal(256), na.value = na.value,
               aesthetics = aesthetics, ...)
  if (!is.null(midpoint)) {
    if (!is.numeric(midpoint) || length(midpoint) != 1L || is.na(midpoint)) {
      stop("`midpoint` must be a single number or NULL.", call. = FALSE)
    }
    args$rescaler <- function(x, to = c(0, 1), from = range(x, na.rm = TRUE)) {
      scales::rescale_mid(x, to = to, from = from, mid = midpoint)
    }
  }
  do.call(ggplot2::scale_colour_gradientn, args)
}

portal_scale <- function(aesthetics, palette, discrete, reverse, midpoint,
                         na.value, ...) {
  pal <- portal_palette(palette = palette, reverse = reverse,
                        discrete = discrete)

  if (discrete) {
    if (!is.null(midpoint)) {
      warning("`midpoint` is ignored for discrete scales.", call. = FALSE)
    }
    portal_discrete_scale(aesthetics, palette, pal, na.value, ...)
  } else {
    portal_continuous_scale(aesthetics, pal, midpoint, na.value, ...)
  }
}

#' Portal color and fill scales for ggplot2
#'
#' Color (`scale_color_portal()`) and fill (`scale_fill_portal()`) scales that
#' use a Portal palette. Use the color scale for points and lines, and the
#' fill scale for bars, boxplots, areas, tiles and rasters. British spellings
#' (`scale_colour_portal()`) are also provided.
#'
#' @section Choosing a palette:
#' * Use `"portal"` (the default) for **diverging** data with a meaningful
#'   center, such as log fold change, z-scores or correlations, and set
#'   `midpoint` (usually `0`) so the light center color sits on that value.
#' * Use `"orange"` or `"blue"` for **sequential** data that only goes one
#'   way, such as density, counts or expression level.
#' * Use `"test_chamber"`, `"overgrown"` or `"ratman"` for **categorical**
#'   data with no order, such as cell types, conditions or clusters (up to 6
#'   groups).
#' * Use `"classic"` to reproduce figures made with the original, brighter
#'   oranges.
#'
#' @inheritParams portal_palette
#' @param discrete Logical. If `TRUE` (default), returns a discrete scale for
#'   categorical data. If `FALSE`, returns a continuous gradient for numeric
#'   data.
#' @param midpoint For continuous scales, the data value to place at the center
#'   of the palette, e.g. `0` for log fold change. If `NULL` (default), the
#'   palette is stretched across the full data range.
#' @param na.value Color used for missing values.
#' @param aesthetics Character vector of aesthetics this scale applies to.
#'   Use `c("colour", "fill")` to style both with one scale.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()] when
#'   `discrete = TRUE`, or to [ggplot2::scale_colour_gradientn()] when
#'   `discrete = FALSE` (e.g. `name`, `limits`, `breaks`, `labels`).
#'
#' @return A ggplot2 scale object.
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' # Categorical color scale for unordered groups
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_portal("test_chamber")
#'
#' # Categorical fill scale
#' ggplot(mtcars, aes(factor(cyl), fill = factor(gear))) +
#'   geom_bar() +
#'   scale_fill_portal("overgrown")
#'
#' # Sequential fill for one-directional data
#' ggplot(faithfuld, aes(eruptions, waiting, fill = density)) +
#'   geom_raster() +
#'   scale_fill_portal("blue", discrete = FALSE)
#'
#' # Diverging fill centered on zero
#' grid <- expand.grid(x = seq(-3, 3, length.out = 60),
#'                     y = seq(-3, 3, length.out = 60))
#' grid$z <- sin(grid$x) * cos(grid$y) + 0.3
#' ggplot(grid, aes(x, y, fill = z)) +
#'   geom_raster() +
#'   scale_fill_portal(discrete = FALSE, midpoint = 0)
scale_color_portal <- function(palette = "portal", discrete = TRUE,
                               reverse = FALSE, midpoint = NULL,
                               na.value = "grey60", aesthetics = "colour",
                               ...) {
  portal_scale(aesthetics, palette, discrete, reverse, midpoint, na.value, ...)
}

#' @rdname scale_color_portal
#' @export
scale_colour_portal <- scale_color_portal

#' @rdname scale_color_portal
#' @export
scale_fill_portal <- function(palette = "portal", discrete = TRUE,
                              reverse = FALSE, midpoint = NULL,
                              na.value = "grey60", aesthetics = "fill", ...) {
  portal_scale(aesthetics, palette, discrete, reverse, midpoint, na.value, ...)
}
