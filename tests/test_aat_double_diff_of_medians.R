# # Double-difference-of-medians for correct responses on an AAT dataset
# library(splithalfr)
# 
# # Example AAT dataset
# data("ds_aat", package = "splithalfr")
# ?ds_aat
# 
# # Preprocessing; only select assessment blocks
# ds_aat <- subset(ds_aat, block_type %in% c("assess1", "assess2"))
# # Preprocessing; only select first response each trial
# ds_aat <- subset(ds_aat, attempt == 0)
# 
# # Function for getting the sets used in each comparison
# aat_fn_sets <- function (ds) {
#   return (list(
#     # Avoid Individual Positive
#     avoid_test= subset(ds, trial_type == "avoid" & cat == "test"),
#     # Approach Individual Positive
#     approach_test = subset(ds, trial_type == "approach" & cat == "test"),
#     # Avoid Individual Injury
#     avoid_control = subset(ds, trial_type == "avoid" & cat == "control"),
#     # Approach Individual Injury
#     approach_control = subset(ds, trial_type == "approach" & cat == "control")
#   ))
# }
# 
# # Function for calculating the score
# aat_fn_score <- function (sets) {
#   median_avoid_test <- median(subset(sets$avoid_test, response == 1)$rt)
#   median_approach_test <- median(subset(sets$approach_test, response == 1)$rt)
#   median_avoid_control <- median(subset(sets$avoid_control, response == 1)$rt)
#   median_approach_control <- median(subset(sets$approach_control, response == 1)$rt)
#   return ((median_avoid_test - median_approach_test) - (median_avoid_control - median_approach_control))
# }
# 
# # Calculate scores per participant
# aat_scores <- sh_apply(ds_aat, "UserID", aat_fn_sets, aat_fn_score)
# 
# # Check with manually calculated score
# if (abs(subset(aat_scores, UserID == 190)$score - (-101.85)) > .0000001) {
#   stop("score of UserID 190 did not match with score calculated manually")
# }
# 
# # Calculate two split-half reliabilities
# aat_splits <- sh_apply(
#   ds_aat,
#   "UserID",
#   aat_fn_sets,
#   aat_fn_score,
#   split_count = 2
# )
# 
# # Calculate mean of spearman-brown reliabilities of each split
# reliability <- mean_sb_by_split(aat_splits)
