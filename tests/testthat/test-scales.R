library(ggplot2)

build_colours <- function(p, aes = "colour") {
  ggplot_build(p)$data[[1]][[aes]]
}

test_that("discrete colour scale uses exact palette colors", {
  p <- ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
    geom_point() +
    scale_color_portal()
  expect_true(all(tolower(unique(build_colours(p))) %in% portal_colors()))
})

test_that("British spelling alias is identical", {
  expect_identical(scale_colour_portal, scale_color_portal)
})

test_that("continuous fill scale builds", {
  p <- ggplot(faithfuld, aes(eruptions, waiting, fill = density)) +
    geom_raster() +
    scale_fill_portal("blue", discrete = FALSE)
  expect_length(build_colours(p, "fill"), nrow(faithfuld))
})

test_that("midpoint centers the light color on the midpoint value", {
  df <- data.frame(x = 1:3, y = 1, z = c(-1, 0, 4))
  p <- ggplot(df, aes(x, y, fill = z)) +
    geom_tile() +
    scale_fill_portal(discrete = FALSE, midpoint = 0)
  fills <- build_colours(p, "fill")
  mid <- portal_palette(discrete = FALSE)(256)[c(128, 129)]
  # The z = 0 tile should be (very close to) the palette's center color
  dist_to_mid <- min(colSums(abs(grDevices::col2rgb(mid) -
                                   as.vector(grDevices::col2rgb(fills[2])))))
  expect_lt(dist_to_mid, 10)
})

test_that("invalid midpoint errors, and midpoint is ignored for discrete", {
  expect_error(scale_fill_portal(discrete = FALSE, midpoint = "a"),
               "single number")
  expect_warning(scale_fill_portal(midpoint = 0), "ignored")
})

test_that("one scale can style colour and fill together", {
  s <- scale_color_portal(aesthetics = c("colour", "fill"))
  expect_setequal(s$aesthetics, c("colour", "fill"))
})

test_that("missing values use na.value", {
  df <- data.frame(x = 1:3, y = 1, g = c("a", NA, "b"))
  p <- ggplot(df, aes(x, y, colour = g)) +
    geom_point() +
    scale_color_portal(na.value = "grey60")
  expect_true("grey60" %in% build_colours(p))
})

test_that("theme_portal returns a theme", {
  expect_s3_class(theme_portal(), "theme")
})
