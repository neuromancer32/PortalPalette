test_that("portal_colors returns named hex vectors", {
  for (p in names(portal_palettes_list())) {
    cols <- portal_colors(p)
    expect_type(cols, "character")
    expect_false(is.null(names(cols)))
    expect_true(all(grepl("^#[0-9a-fA-F]{6}$", cols)))
  }
})

test_that("unknown palettes give an informative error", {
  expect_error(portal_colors("aperture"), "not found")
  expect_error(portal_palette("aperture"), "Available palettes")
})

test_that("discrete palettes return exact colors up to palette length", {
  cols <- unname(portal_colors())
  expect_equal(portal_palette()(6), cols)
  expect_equal(portal_palette()(2), cols[c(1, 6)])
  expect_true(all(portal_palette()(3) %in% cols))
  expect_equal(portal_palette(reverse = TRUE)(6), rev(cols))
})

test_that("discrete palettes warn when interpolating beyond palette length", {
  expect_warning(out <- portal_palette()(8), "hard to tell apart")
  expect_length(out, 8)
})

test_that("continuous palettes interpolate without warning", {
  expect_no_warning(out <- portal_palette(discrete = FALSE)(100))
  expect_length(out, 100)
})

test_that("portal palette ends are matched in lightness", {
  # Perceived lightness (CIE L*) via sRGB -> XYZ -> Lab
  lstar <- function(hex) {
    rgb <- grDevices::col2rgb(hex) / 255
    lin <- ifelse(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
    y <- colSums(lin * c(0.2126, 0.7152, 0.0722))
    ifelse(y > 216 / 24389, 116 * y^(1 / 3) - 16, y * 24389 / 27)
  }
  l <- lstar(portal_colors("portal"))
  expect_lt(abs(l[[1]] - l[[6]]), 2)
  expect_lt(abs(l[[2]] - l[[5]]), 2)
  expect_lt(abs(l[[3]] - l[[4]]), 5)
})
