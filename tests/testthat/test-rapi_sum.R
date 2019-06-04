test_that("rapi_sum", {
  # Test RAPI sum-score
  library(splithalfr)
  
  # Example RAPI data
  data("ds_rapi", package = "splithalfr")

  # ds_aat is data.frame of correct row count?
  expect_is(ds_rapi, "data.frame")
  expect_equal(nrow(ds_rapi), 426)
  
  # Function for getting the sets; only one set as a vector
  rapi_fn_sets <- function (ds) {
    return (list(
      items = unlist(ds[paste("V", 1 : 23, sep = "")])
    ))
  }
  
  # Function for calculating the score
  rapi_fn_score <- function (sets) {
    return (sum(sets$items))
  }
  
  # Calculate scores
  rapi_scores <- sh_apply(ds_rapi, "twnr", rapi_fn_sets, rapi_fn_score)
  
  # rapi_scores is data.frame of correct row count?
  expect_is(rapi_scores, "data.frame")
  expect_equal(nrow(rapi_scores), 426)
  
  # Check with manually calculated score
  expect_true(
    abs(subset(rapi_scores, twnr == 396)$score - 16) < .0000001,
    "score of twnr 396 did not match with score calculated manually"
  )    
  
  # Calculate two split-half scores
  rapi_splits <- sh_apply(
    ds_rapi,
    "twnr",
    rapi_fn_sets,
    rapi_fn_score,
    split_count = 2
  )
  
  # rapi_splits is data.frame of correct row count?
  expect_is(rapi_splits, "data.frame")
  expect_equal(nrow(rapi_splits), 852)  
  
  # Calculate mean of flanagan-rulon reliabilities of each split
  reliability <- mean_fr_by_split(rapi_splits)
  
  # reliability is a number?
  expect_is(reliability, "numeric")  
})
