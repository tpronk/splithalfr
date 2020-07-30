test_that("iat_dscore_ri", {
  # Test Improved IAT d-score for IAT where a correct response is required to
  # continue to the next trial
  library(splithalfr)
  library(dplyr)

  # Load data
  data("ds_iat", package = "splithalfr")
  
  # ds_iat is data.frame of correct row count?
  expect_is(ds_iat, "data.frame")
  expect_equal(nrow(ds_iat), 9696)  
  
  # Drop participants whose RTs for over 10% of reponses are below 300 ms
  ds_summary <- ds_iat %>%
    dplyr::group_by(participation_id) %>%
    dplyr::summarize(
      too_fast = sum(rt < 300) / dplyr::n() > 0.1,
    )
  ds_iat <- ds_iat[!(
    ds_iat$participation_id %in% ds_summary[ds_summary$too_fast, ]$participation_id
  ), ]
  
  # Delete any attempts with RT > 10,000 ms
  ds_iat <- ds_iat[ds_iat$rt <= 10000, ]
  
  # 31 participants left?
  expect_equal(length(unique(ds_iat$participation_id)), 31)
  
  
  # Only combination blocks
  ds_iat <- ds_iat[
    ds_iat$block_type %in% 
      c("tar1att1_1", "tar1att2_1", "tar1att1_2", "tar1att2_2"),
    ]    
  
  # Sum RTs of attempts per trial
  ds_iat <- ds_iat %>%
    dplyr::group_by(participation_id, block, trial) %>%
    summarise(
      block_type = first(block_type),
      cat = first(cat),
      rt = sum(rt)
    )    
  
  # score function
  fn_score <- function(ds) {
    fn_block <- function(ds_tar1att1, ds_tar1att2) {
      m_tar1att1 <- mean(ds_tar1att1$rt)
      m_tar1att2 <- mean(ds_tar1att2$rt)
      inclusive_sd <- sd(c(ds_tar1att1$rt, ds_tar1att2$rt))
      return ((m_tar1att2 - m_tar1att1) / inclusive_sd)
    }      
    d1 <- fn_block(
      ds[ds$block_type == "tar1att1_1", ],
      ds[ds$block_type == "tar1att2_1", ]
    )
    d2 <- fn_block(
      ds[ds$block_type == "tar1att1_2", ],
      ds[ds$block_type == "tar1att2_2", ]
    )
    return (mean(c(d1, d2)))
  }
  
  scores <- by(
    ds_iat,
    ds_iat$participation_id,
    fn_score
  )
  scores <- data.frame(
    UserID = names(scores),
    score = as.vector(scores)
  )  
  
  # scores is data.frame of correct row count?
  expect_is(scores, "data.frame")
  expect_equal(nrow(scores), 31)
  
  # Check with manually calculated score
  expect_true(
    abs(subset(scores, UserID == 5)$score - 0.93944688) < .000001,
    "score of UserID 1 did not match with score calculated manually"
  )  
  
  # Apply odd-even split
  split_scores <- by_split(
    ds_iat,
    ds_iat$participation_id,
    fn_score,
    method = "odd_even",
    replications = 1,
    ncores = 1
  )
  
  # split_scores is data.frame of correct row count?
  expect_is(split_scores, "data.frame")
  expect_equal(nrow(split_scores), 31)
  
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
