test_that("split_sets", {
  # Joint tests of split_sets and split_set
  library(splithalfr)
  
  # Permutated split. One of the splits gets 4 elements and the other 5
  set.seed(123)    
  expect_equal(
    split_stratum(1 : 9),
    list(c(1, 3, 7, 9), c(2, 4, 5, 6, 8))
  )
  # Permutated split, unbalanced sampling: one of the splits gets 6 elements and the other 2
  set.seed(123)
  expect_equal(
    split_stratum(1 : 8, split_p = 0.75, careful = FALSE),
    list(c(3, 4, 5, 6, 7, 8), c(1, 2))
  )
  # Permutated split, subsampling half of the dataset (4.5 elements, rounded up to 5)
  set.seed(123)
  expect_equal(
    split_stratum(1 : 9, subsample_p = 0.5),
    list(c(6, 9, 2), c(3, 8))
  )
  # Monte Carlo split. The elements of each split are sampled with replacement from sets.
  set.seed(123)
  expect_equal(
    split_stratum(1 : 9, split_p = 1, replace = TRUE),
    list(c(3, 3, 2, 6, 5, 4, 6, 9, 5), c(3, 9, 9, 9, 3, 8, 7, 9, 3))
  )
  # Monte Carlo split, subsampling half of the dataset (4.5 elements, rounded up to 5)
  set.seed(123)
  expect_equal(
    split_stratum(1 : 9, subsample_p = 0.5, split_p = 1, replace = TRUE),
    list(c(
      9, 8, 2, 3, 6
    ), c(
      9, 8, 9, 9, 3
    ))
  )
  
  # Random stratified split
  ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
  set.seed(123)  
  expect_equivalent(
    split_df(ds, stratification = ds$condition, method = "random"),
    list(
      data.frame(condition = c("a", "a", "b", "b"), score = c(3, 4, 6, 8)),
      data.frame(condition = c("a", "a", "b", "b"), score = c(1, 2, 5, 7))
    )
  )  
  # Deterministic splits; firs-second and odd-even, with and without
  # stratification
  expect_equivalent(
    split_df(ds, method = "first_second"),
    list(
      data.frame(condition = c("a", "a", "a", "a"), score = c(1, 2, 3, 4)),
      data.frame(condition = c("b", "b", "b", "b"), score = c(5, 6, 7, 8))
    )
  )  
  expect_equivalent(
    split_df(ds, stratification = ds$condition, method = "first_second"),
    list(
      data.frame(condition = c("a", "a", "b", "b"), score = c(1, 2, 5, 6)),
      data.frame(condition = c("a", "a", "b", "b"), score = c(3, 4, 7, 8))
    )
  )
  expect_equivalent(
    split_df(ds, method = "odd_even"),
    list(
      data.frame(condition = c("a", "a", "b", "b"), score = c(1, 3, 5, 7)),
      data.frame(condition = c("a", "a", "b", "b"), score = c(2, 4, 6, 8))
    )
  )  
  expect_equivalent(
    split_df(ds, stratification = ds$condition, method = "odd_even"),
    list(
      data.frame(condition = c("a", "a", "b", "b"), score = c(1, 3, 5, 7)),
      data.frame(condition = c("a", "a", "b", "b"), score = c(2, 4, 6, 8))
    )
  )
})