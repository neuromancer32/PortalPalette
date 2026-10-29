# PortalPalette

<!-- badges: start -->
[![R-CMD-check](https://github.com/neuromancer32/PortalPalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/neuromancer32/PortalPalette/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Orange-and-blue color palettes for R and ggplot2, inspired by the game Portal.

The default `portal` palette is a diverging orange → tan → blue palette, tuned so that each orange is as light as its matching blue. That keeps gradients visually balanced around their midpoint, which makes it a good fit for heatmaps of signed data such as log fold change, z-scores or correlations. Sequential `orange` and `blue` palettes cover data that only goes one way.

![PortalPalette palettes](man/fig/Palette.png)

## Installation

```r
# install.packages("remotes")
remotes::install_github("neuromancer32/PortalPalette")
```

## Usage

### Discrete scales

For up to as many groups as the palette has colors, discrete scales use exact palette colors rather than blends.

```r
library(ggplot2)
library(PortalPalette)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_portal() +
  theme_portal()
```

![Discrete scale](man/fig/Sepal.png)

### Sequential data

Use `"orange"` or `"blue"` for data that only increases in one direction, such as density, counts or expression.

```r
ggplot(faithfuld, aes(eruptions, waiting, fill = density)) +
  geom_raster() +
  scale_fill_portal("blue", discrete = FALSE) +
  theme_portal()
```

![Sequential scale](man/fig/Eruptions.png)

### Diverging data

Set `midpoint` so the light center color sits on a meaningful value. Values below it are orange and values above it are blue, even when the data isn't symmetric around it.

```r
ggplot(df, aes(x, y, fill = log2_fold_change)) +
  geom_tile() +
  scale_fill_portal(discrete = FALSE, midpoint = 0) +
  theme_portal()
```

![Diverging scale](man/fig/Diverging.png)

### Outside ggplot2

```r
portal_colors()                       # named hex codes
portal_colors("blue")
portal_palette(discrete = FALSE)(100) # 100-step gradient, e.g. for pheatmap
```

## Functions

| Function | Purpose |
|---|---|
| `scale_color_portal()`, `scale_colour_portal()` | Color scale for points and lines |
| `scale_fill_portal()` | Fill scale for bars, tiles, rasters and areas |
| `portal_palette()` | Function that generates `n` colors |
| `portal_colors()` | Named hex codes for one palette |
| `portal_palettes_list()` | All palettes |
| `theme_portal()` | Minimal theme to pair with the scales |

Useful scale arguments: `palette`, `discrete`, `reverse`, `midpoint`, `na.value`, and `aesthetics = c("colour", "fill")` to style both with one scale.

## Palettes

| Palette | Type | Use for |
|---|---|---|
| `portal` (default) | Diverging, lightness-balanced | Signed data with a meaningful center |
| `classic` | Diverging, original bright oranges | Matching figures made with version 0.1.0 |
| `orange` | Sequential, light → dark | One-directional data |
| `blue` | Sequential, light → dark | One-directional data |

## Accessibility

- **Color vision deficiency:** orange vs. blue lies along the blue–yellow axis, which stays distinguishable for the common red–green deficiencies (deuteranopia and protanopia). The closest pair is tan vs. light blue.
- **Greyscale:** the sequential palettes keep their order in greyscale. The diverging palettes don't: because each orange matches its blue in lightness, greyscale shows *how far* a value is from the midpoint but not *which side* it's on (see the greyscale column above). For printed greyscale figures, use a sequential palette or label the direction explicitly.
