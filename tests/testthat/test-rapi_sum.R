test_that("rapi_sum", {
  # Test RAPI sum-score
  library(splithalfr)
  
  # Example RAPI data
  data("ds_rapi", package = "splithalfr")

  # ds_aat is data.frame of correct row count?
  expect_is(ds_rapi, "data.frame")
  expect_equal(nrow(ds_rapi), 426)
  
  ds_rapi <- reshape(
    ds_rapi,
    varying = list(paste("V", 1 : 23, sep = "")),
    idvar = "twnr",
    direction = "long",
    timevar = "item",
    v.names = "score"
  )
  
  # Function for getting the sets; only one set as a vector
  rapi_fn_sets <- function (ds) {
    return (list(
      items = unlist(ds[paste("V", 1 : 23, sep = "")])
    ))
  }
  
  fn_score <- function (ds) {
    return (sum(ds$score))
  }
  
  scores <- by(
    ds_rapi,
    ds_rapi$twnr,
    fn_score
  )
  scores <- data.frame(
    twnr = names(scores),
    score = as.vector(scores)
  )
  
  # rapi_scores is data.frame of correct row count?
  expect_is(scores, "data.frame")
  expect_equal(nrow(scores), 426)
  
  # Check with manually calculated score
  expect_true(
    abs(subset(scores, twnr == 396)$score - 16) < .0000001,
    "score of twnr 396 did not match with score calculated manually"
  )    
  
  # Apply odd-even split
  split_scores <- by_split(
    ds_rapi,
    ds_rapi$twnr,
    fn_score,
    method = "odd_even",
    replications = 1,
    ncores = 1
  )
  
  # split_scores is data.frame of correct row count?
  expect_is(split_scores, "data.frame")
  expect_equal(nrow(split_scores), 426)  
  
  # Calculate reliablity coefficients
  expect_is(
    split_coefs(split_scores, spearman_brown),
    "numeric"
  )
  expect_is(
    split_coefs(split_scores, flanagan_rulon),
    "numeric"
  )
  expect_is(
    split_coefs(split_scores, angoff_feldt),
    "numeric"
  )
  expect_is(
    split_coefs(
      split_scores, 
      short_icc, 
      type = "ICC1", 
      lmer = FALSE
    ),
    "numeric"
  )
  expect_is(
    split_coefs(
      split_scores, 
      spearman_brown, 
      short_icc, 
      type = "ICC1", 
      lmer = FALSE
    ),
    "numeric"
  )})
