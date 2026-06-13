# Smoke tests for dependency-free utilities. These run under R CMD check /
# devtools::test() without requiring metafor, rjags, or brms.

test_that("standardize_data maps common column aliases to yi/se", {
  df <- data.frame(
    trial = c("A", "B"),
    TE    = c(-0.5, 0.3),
    seTE  = c(0.10, 0.20)
  )
  out <- standardize_data(df)
  expect_true(all(c("study_id", "yi", "se", "vi") %in% names(out)))
  expect_equal(out$yi, c(-0.5, 0.3))
  expect_equal(out$se, c(0.10, 0.20))
  # vi must equal se^2 (variance), not se itself.
  expect_equal(out$vi, c(0.10, 0.20)^2)
})

test_that("standardize_data synthesizes study_id when none provided", {
  df <- data.frame(yi = c(1, 2, 3), se = c(0.1, 0.2, 0.3))
  out <- standardize_data(df)
  expect_equal(out$study_id, c("Study_1", "Study_2", "Study_3"))
})

test_that("standardize_data fails closed on missing required fields", {
  # No effect-size column.
  expect_error(standardize_data(data.frame(se = c(0.1, 0.2))),
               "effect-size column")
  # No standard-error column.
  expect_error(standardize_data(data.frame(yi = c(0.1, 0.2))),
               "standard-error column")
  # Non-data-frame input.
  expect_error(standardize_data(list(yi = 1, se = 1)),
               "data frame")
})

test_that("check_pkg reports installed and missing packages", {
  expect_true(check_pkg("stats"))
  expect_false(check_pkg("a_package_that_does_not_exist_xyz"))
})
