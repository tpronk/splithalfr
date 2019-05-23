# Test Improved IAT d-score for IAT where a correct response is required to
# continue to the next trial
library(splithalfr)
library(dplyr)

# Example IAT data (in JASMIN2 format)
data("ds_iat", package = "splithalfr")

# Preprocess; set timeout respones tot NA
ds_iat[ds_iat$response == 3, ]$rt <- 4000

# Preproces; delete any attempts with RTs > 10,000 ms
ds_iat <- subset(ds_iat, rt <= 10000)

# Preprocess; for each participation, block, and trial, sum RTs. Also keep block_type.
ds_iat <- ds_iat %>%
    dplyr::group_by(UserID, block, trial) %>%
    summarise(
      block_type = first(block_type),
      rt = sum(rt)
    )

# Sets function
iat_fn_sets <- function (ds) {
  return (list(
    tar1att1_1 = subset(ds, block_type == "tar1att1_1"),
    tar1att1_2 = subset(ds, block_type == "tar1att1_2"),
    tar1att2_1 = subset(ds, block_type == "tar1att2_1"),
    tar1att2_2 = subset(ds, block_type == "tar1att2_2")
  ))
}

# Block score and splithalfr score functions
iat_fn_block <- function(ds_tar1att1, ds_tar1att2) {
  m_tar1att1 <- mean(ds_tar1att1$rt)
  m_tar1att2 <- mean(ds_tar1att2$rt)
  inclusive_sd <- sd(c(ds_tar1att1$rt, ds_tar1att2$rt))
  return ((m_tar1att2 - m_tar1att1) / inclusive_sd)
}

iat_fn_score = function(sets) {
  d1 <- iat_fn_block(sets$tar1att1_1, sets$tar1att2_1)
  d2 <- iat_fn_block(sets$tar1att1_2, sets$tar1att2_2)
  return (mean(c(d1, d2)))
}

# Calculate scores
iat_scores <- sh_apply(
  ds_iat,
  "UserID",
  iat_fn_sets,
  iat_fn_score,
  split_count = 0
)

# Check with manually calculated score
if (abs(subset(iat_scores, UserID == 1)$score - 0.407603898) > .000001) {
  stop("score of UserID 1 did not match with score calculated manually")
}

# Calculate split half scores 100 times
# Uncomment the part below to calculate split half scores 100 times
# ds_splits <- sh_apply(
#   ds_trials,
#   "UserID",
#   d_score_ri.sets,
#   d_score_ri.score,
#   split_count = 100
# )
# # Calculate mean of spearman-brown reliabilities of each split
# reliability <- mean_sb_by_split(ds_splits)
