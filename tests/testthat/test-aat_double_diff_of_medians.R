test_that("aat_double_diff_of_medians", {
  # Double-difference-of-medians for correct responses on an AAT dataset
  library(splithalfr)
  
  data("ds_aat", package = "splithalfr")
  
  # Preprocessing; only select assessment blocks
  ds_aat <- subset(ds_aat, block_type == "assess")
  
  # ds_aat is data.frame of correct row count?
  expect_is(ds_aat, "data.frame")
  expect_equal(nrow(ds_aat), 6144)  
  
  # Function for calculating the score
  fn_score <- function (ds) {
    median_avoid_test <- median(
      ds[ds$appr == "no" & ds$cat == "test" & ds$response == 1, ]$rt
    )
    median_approach_test <- median(
      ds[ds$appr == "yes" & ds$cat == "test" & ds$response == 1, ]$rt
    )
    median_avoid_control <- median(
      ds[ds$appr == "no" & ds$cat == "control" & ds$response == 1, ]$rt
    )
    median_approach_control <- median(
      ds[ds$appr == "yes" & ds$cat == "control" & ds$response == 1, ]$rt
    )
    return (
      (median_avoid_test - median_approach_test) - 
      (median_avoid_control - median_approach_control)
    )
  }
  
  # Calculate scores per participant
  scores <- by(
    ds_aat,
    ds_aat$UserID,
    fn_score
  )
  scores <- data.frame(
    UserID = names(scores),
    score = as.vector(scores)
  )  
  
  # scores is data.frame of correct row count?
  expect_is(scores, "data.frame")
  expect_equal(nrow(scores), 48)
  
  # Check with manually calculated score
  expect_true(
    abs(scores[scores$UserID == 18, ]$score - (-14.5)) < .0000001,
    "score of UserID 18 did not match with score calculated manually"
  )  
  
  # Apply odd-even split
  split_scores <- by_split(
    ds_aat,
    ds_aat$UserID,
    fn_score,
    method = "odd_even",
    replications = 1,
    ncores = 1
  )

  # split_scores is data.frame of correct row count?
  expect_is(split_scores, "data.frame")
  expect_equal(nrow(split_scores), 48)
  
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
