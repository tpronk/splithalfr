test_that("vpt_diff_of_means", {
  # Difference-of-means, after removing RTs below 200 ms or above 520 ms, on a VPT dataset
  library(splithalfr)
  
  # Example VPT data (in JASMIN1 format)
  data("ds_vpt", package = "splithalfr")
  
  # ds_aat is data.frame of correct row count?
  expect_is(ds_vpt, "data.frame")
  expect_equal(nrow(ds_vpt), 19520)
  
  # Preprocessing; only select assessment blocks
  ds_vpt <- subset(ds_vpt, block_type == "assess")
  
  fn_score <- function (ds) {
    ds_keep <- ds[ds$response == 1 & ds$rt >= 200 & ds$rt <= 520, ]
    rt_yes <- mean(ds_keep[ds_keep$patt == "yes", ]$rt)
    rt_no <- mean(ds_keep[ds_keep$patt == "no", ]$rt)
    return (rt_no - rt_yes)
  }
  
  scores <- by(
    ds_vpt,
    ds_vpt$UserID,
    fn_score
  )
  scores <- data.frame(
    UserID = names(scores),
    score = as.vector(scores)
  )
  
  # scores is data.frame of correct row count?
  expect_is(scores, "data.frame")
  expect_equal(nrow(scores), 61)

  # Check with manually calculated score
  expect_true(
    abs(scores[scores$UserID == 23, ]$score - 7.098501382) < 0.00001,
    "score of UserID 23 did not match with score calculated manually"
  )  
  
  # Apply odd-even split
  split_scores <- by_split(
    ds_vpt,
    ds_vpt$UserID,
    fn_score,
    method = "odd_even",
    replications = 1,
    ncores = 1
  )
  
  # split_scores is data.frame of correct row count?
  expect_is(split_scores, "data.frame")
  expect_equal(nrow(split_scores), 61)
  
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
  )
})
