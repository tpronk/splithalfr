# Difference-of-means, after removing RTs below 200 ms or above 520 ms, on a VPT dataset
# The R-script in this test is also part of the splithalfr vignette: VPT Difference of Means
library(splithalfr)

# Example VPT data (in JASMIN1 format)
data("ds_vpt", package = "splithalfr")

# Preprocessing; only select assessment blocks
ds_vpt <- subset(ds_vpt, block_type == "assess")

# Function for getting the sets used in each comparison
vpt_fn_sets <- function (ds) {
  return (list(
    # Probe-at-test
    patt_yes = subset(ds, patt == "yes"),
    # Probe-at-control
    patt_no  = subset(ds, patt == "no")
  ))
}

# Function for calculating the score: mean RT of patt == no minus mean RT of patt = no,
# for correct responses, after removing RTs below 200 ms and above 520 ms as outliers
vpt_fn_score <- function (sets) {
  rt_yes <- subset(sets$patt_yes, response == 1)$rt
  rt_yes <- rt_yes[rt_yes >= 200 & rt_yes <= 520]
  rt_no <- subset(sets$patt_no, response == 1)$rt
  rt_no <- rt_no[rt_no >= 200 & rt_no <= 520]
  return (mean(rt_no) - mean(rt_yes))
}

# Calculate scores per participant
vpt_scores <- sh_apply(
  ds_vpt,
  "UserID",
  vpt_fn_sets,
  vpt_fn_score
)

# Check with manually calculated score
if (abs(subset(vpt_scores, UserID == 23)$score - 7.098501382) > 0.00001) {
  stop("score of UserID 23 did not match with score calculated manually")
}

# Uncomment the part below to calculate split half scores 100 times
# # Calculate split half scores 10 times
# vpt_splits <- sh_apply(
#   ds_vpt,
#   "UserID",
#   vpt_fn_sets,
#   vpt_fn_score,
#   split_count = 100
# )
# # Calculate mean of spearman-brown reliabilities of each split
# reliability <- mean_sb_by_split(vpt_splits)
# reliability
