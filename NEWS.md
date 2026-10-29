# PortalPalette 0.3.0

## New features

* New categorical palettes `"test_chamber"`, `"overgrown"` and `"ratman"` for
  unordered groups (up to 6 each). Colors were sampled from reference
  screenshots and adjusted so every pair stays distinguishable under
  deuteranopia, protanopia and tritanopia. The first colors are the most
  distinct.
* Categorical palettes refuse continuous use or more groups than they have
  colors, with an informative error.

# PortalPalette 0.2.0

## Breaking changes

* The default `"portal"` palette now uses darker oranges (`#c84703`,
  `#df8602`) whose lightness matches their blue counterparts, so gradients are
  balanced around the midpoint. The original colors are available as
  `palette = "classic"`.
* Discrete scales now return exact palette colors (spread evenly across the
  palette) for up to as many groups as the palette has colors, instead of
  interpolated blends.

## New features

* New sequential palettes `"orange"` and `"blue"` for one-directional data.
* New `midpoint` argument for continuous scales, to center the palette on a
  meaningful value such as 0.
* New `aesthetics` argument, so one scale can style both colour and fill.
* New `portal_colors()` and `portal_palettes_list()` for using the colors
  outside ggplot2.
* New `scale_colour_portal()` British-spelling alias.
* New `theme_portal()` minimal theme.
* Discrete palettes warn when asked for more colors than the palette has.
* Missing values now default to `"grey60"` (`na.value`).

## Fixes

* Declared ggplot2 as a dependency and fixed documentation so
  `R CMD check` passes cleanly.
* Works with ggplot2 both before and after 3.5.0.

# PortalPalette 0.1.0

* Initial version.
