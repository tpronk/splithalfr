# Test RAPI sum-score
library(splithalfr)

# Example IAT data (in JASMIN2 format)
data("ds_rapi", package = "splithalfr")
?ds_rapi

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

# Check with manually calculated score
if (abs(subset(rapi_scores, twnr == 396)$score - 16) > .0000001) {
  stop("score of UserID 396 did not match with score calculated manually")
}

# Calculate two split-half reliabilities
rapi_splits <- sh_apply(
  ds_rapi,
  "twnr",
  rapi_fn_sets,
  rapi_fn_score,
  split_count = 2
)

# Calculate mean of flanagan-rulon reliabilities of each split
reliability <- mean_fr_by_split(rapi_splits)
