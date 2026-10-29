# Palettes ------------------------------------------------------------------
#
# "portal" is a diverging orange-to-blue palette whose two ends are matched in
# perceived lightness (CIE L*: 48 / 64 / ~89 on each side), so a gradient
# through it is visually balanced around its midpoint.
#
# "classic" keeps the original, brighter orange values (lightness not matched).
# "orange" and "blue" are sequential palettes that run from light to dark.

portal_palettes <- list(
  portal = c(
    `dark orange` = "#c84703",
    `orange`      = "#df8602",
    `tan`         = "#fce0b6",
    `light blue`  = "#abe1ff",
    `blue`        = "#00a2ff",
    `dark blue`   = "#0065ff"
  ),
  classic = c(
    `dark orange` = "#ff5d00",
    `orange`      = "#ff9a00",
    `tan`         = "#fce0b6",
    `light blue`  = "#abe1ff",
    `blue`        = "#00a2ff",
    `dark blue`   = "#0065ff"
  ),
  orange = c(
    `tan`          = "#fce0b6",
    `light orange` = "#ff9a00",
    `orange`       = "#ff5d00",
    `dark orange`  = "#c84703"
  ),
  blue = c(
    `light blue` = "#abe1ff",
    `blue`       = "#00a2ff",
    `dark blue`  = "#0065ff"
  )
)

get_portal_palette <- function(palette) {
  if (!is.character(palette) || length(palette) != 1L ||
      !palette %in% names(portal_palettes)) {
    stop("Palette '", paste(palette, collapse = ", "), "' not found. ",
         "Available palettes: ",
         paste(names(portal_palettes), collapse = ", "), ".", call. = FALSE)
  }
  portal_palettes[[palette]]
}

#' Portal colors
#'
#' Returns the named hex colors of a Portal palette. Useful outside ggplot2,
#' for example with base graphics, `pheatmap` or `ComplexHeatmap`.
#'
#' @param palette Character name of the palette: `"portal"` (diverging,
#'   lightness-balanced; the default), `"classic"` (diverging, original bright
#'   oranges), `"orange"` or `"blue"` (sequential, light to dark).
#'
#' @return A named character vector of hex colors.
#' @seealso [portal_palette()] to generate any number of colors.
#' @export
#'
#' @examples
#' portal_colors()
#' portal_colors("blue")
#' portal_colors()[["dark blue"]]
#'
#' # List all palette names
#' names(portal_palettes_list())
portal_colors <- function(palette = "portal") {
  get_portal_palette(palette)
}

#' List all Portal palettes
#'
#' @return A named list of all palettes, each a named character vector of hex
#'   colors.
#' @export
#'
#' @examples
#' portal_palettes_list()
portal_palettes_list <- function() {
  portal_palettes
}

#' Portal color palette generator
#'
#' Returns a function that generates `n` colors from a Portal palette.
#'
#' When `discrete = TRUE` and `n` is no larger than the number of colors in the
#' palette, the function returns exact palette colors spread evenly across the
#' palette instead of interpolated blends. For larger `n` the colors are
#' interpolated with a warning, since neighboring colors become hard to tell
#' apart. When `discrete = FALSE`, colors are always interpolated with
#' [grDevices::colorRampPalette()].
#'
#' @inheritParams portal_colors
#' @param reverse Logical. If `TRUE`, reverses the color order.
#' @param discrete Logical. If `TRUE`, return exact palette colors when
#'   possible. If `FALSE`, always interpolate.
#' @param ... Additional arguments passed to [grDevices::colorRampPalette()].
#'
#' @return A function that takes an integer `n` and returns a character vector
#'   of `n` hex colors.
#' @export
#'
#' @examples
#' # Six exact colors from the Portal palette
#' portal_palette()(6)
#'
#' # Three exact colors, reversed
#' portal_palette(reverse = TRUE)(3)
#'
#' # A smooth 100-step gradient, e.g. for a heatmap
#' portal_palette(discrete = FALSE)(100)
#'
#' # A sequential blue gradient
#' portal_palette("blue", discrete = FALSE)(10)
portal_palette <- function(palette = "portal", reverse = FALSE,
                           discrete = TRUE, ...) {
  pal <- unname(get_portal_palette(palette))

  if (reverse) {
    pal <- rev(pal)
  }

  ramp <- grDevices::colorRampPalette(pal, ...)

  if (!discrete) {
    return(ramp)
  }

  function(n) {
    if (n <= length(pal)) {
      pal[unique(round(seq(1, length(pal), length.out = n)))]
    } else {
      warning("Palette '", palette, "' has ", length(pal), " colors; ",
              "interpolating ", n, " colors, which may be hard to tell apart.",
              call. = FALSE)
      ramp(n)
    }
  }
}
