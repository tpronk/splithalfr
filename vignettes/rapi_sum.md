---
title: "RAPI - Sum Score"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{rapi_sum}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(splithalfr)
```
This vignette describes a sum score of answers on questions from the 23-item Rutgers Alcohol Problem Inventory (RAPI)
([White & Labouvie, 1989](https://research.alcoholstudies.rutgers.edu/rapi));

<br />

# Dataset
Load the included RAPI dataset and inspect its documentation.
```
data("ds_rapi", package = "splithalfr")
?ds_rapi
```

## Data preparation
The RAPI dataset is in wide format (i.e. one row per participant with each observation in a separate column). However, the `splithalfr` requires long format (i.e. one row per observation). Below we reshape the RAPI dataset to long format. 
```
ds_rapi <- reshape(
  ds_rapi,
  varying = list(paste("V", 1 : 23, sep = "")),
  idvar = "twnr",
  direction = "long",
  timevar = "item",
  v.names = "score"
)
```

## Relevant variables
The columns used in this example are:

* `twnr`, which identifies participants
* `item`, which identifies items
* `score`, which contains the score of participant i on item j

<br />

# Scoring the RAPI

## Scoring function
The scoring function calculates the score of a single participant by summing their scores on each item.
```
fn_score <- function (ds) {
  return (sum(ds$score))
}
```

## Scoring a single participant
Let's calculate the RAPI score for the participant with twnr 396. NB - This score has also been calculated manually via Excel in the splithalfr repository.
```
fn_score(subset(ds_rapi, twnr == 396))
```

## Scoring all participants
To calculate the RAPI score for each participant, we will use R's native `by` function and convert the result to a data frame.
```
scores <- by(
  ds_rapi,
  ds_rapi$twnr,
  fn_score
)
data.frame(
  twnr = names(scores),
  score = as.vector(scores)
)
```

<br />

# Estimating split-half reliability

## Calculating split scores
To calculate split-half scores for each participant, use the function `by_split`. The first three arguments of this function are the same as for `by`. An additional set of arguments allow you to specify how to split the data and how often. In this vignette we will calculate scores of 1000 bootstrapped splits. Since each participant received the same unique sequence of items, we enabled `match_participants`. Note that `by_split` offers a large number of additional splitting options, such as first-second half, odd-even, split-full, and stratified splitting.

The `by_split` function returns a data frame with the following columns:

* `participant`, which identifies participants
* `replication`, which counts replications
* `score_1` and `score_2`, which are the scores calculated for each of the split datasets

*Calculating the split scores may take a while. By default, `by_split` uses all available CPU cores, but no progress bar is displayed. Setting `ncores = 1` will display a progress bar, but processing will be slower.*

```
split_scores <- by_split(
  ds_rapi,
  ds_rapi$twnr,
  fn_score,
  replications = 1000,
  match_participants = TRUE
)
```

## Calculating reliability coefficients
Next, the output of `by_split` can be analyzed in order to estimate reliability. By default, functions are provided that calculate Spearman-Brown (`spearman_brown`), Flanagan-Rulon (`flanagan_rulon`), Angoff-Feldt (`angoff_feldt`), and Intraclass Correlation (`short_icc`) coefficients. Each of these coefficient functions can be used with `split_coef` to calculate the corresponding coefficients per split, which can then be plotted or averaged via a simple `mean`. A bias-corrected and accelerated bootstrap confidence interval can be calculated via `split_ci`. Below we illustrate the above with the Flanagan-rulon coefficient.

```
# Flanagan-Rulon coefficients per split
frs <- split_coefs(split_scores, flanagan_rulon)
# Distribution of coefficients
hist(frs)
# Mean of coefficients
mean(frs)
# Confidence interval of coefficients
split_ci(split_scores, flanagan_rulon)
```





