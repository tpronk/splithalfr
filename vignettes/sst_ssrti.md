---
title: "Stop Signal Task - Stop-Signal Reaction Time integration method"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{sst_ssrti}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(splithalfr)
```

This vignette describes the Stop-Signal Reaction Time integration method (SSRTi); a scoring method introduced by [Logan (1981)](http://www.psy.vanderbilt.edu/faculty/logan/Logan(1981).pdf). The scoring function was adapted from an R-script that was graciously made available by [Craig Hedge](https://www.researchgate.net/profile/Craig_Hedge) and used in [Hedge, Powell, and Sumner (2018)](https://doi.org/10.1016/j.tate.2019.102887).

<br />

# Dataset
Load the included SST dataset and inspect its documentation.
```
data("ds_sst", package = "splithalfr")
?ds_sst
```

## Relevant variables
The columns used in this example are:

* trial. Trial number
* ssd. Stop signal delay
* condition. 0 = go, 1 = stop
* response. Correct (1) or incorrect (0)
* rt. Reaction time (milliseconds)
* participant. Participant ID

## Preprocessing
Drop the first trial of each block.
```
ds_sst <- ds_sst[ds_sst$trial > 1, ]
```


## Counterbalancing
The variable `condition` was counterbalanced. Below we illustrate this for the first participant.
```
ds_1 <- subset(ds_sst, participant  == 1)
table(ds_1$condition)
```

<br />


# Scoring the SST

## Scoring function
The scoring function receives the data from a single participant. The mean SSD is subtracted from the nth fastest RT, where n corresponds to the percentage of stop trials on which participants failed to inhibit their responses.
```
fn_score <- function(ds) {
  # Mean SSD
  mean_ssd <- mean(ds[ds$condition == 1, ]$ssd)
  # Proportion of failed nogos
  p_failed_nogo <- 1 - mean(ds[ds$condition == 1, ]$response)
  # Go RTs
  go_rts <- ds[
    ds$condition == 0 &
      ds$rt > 0,
    ]$rt
  # n-th percentile of Go RTs
  rt_quantile <- quantile(go_rts, p_failed_nogo, names = FALSE)
  # SSRTi
  return(rt_quantile - mean_ssd)
}
```

## Scoring a single participant
Let's calculate the SSRTi score for the participant with UserID 1. 
```
fn_score(subset(ds_sst, participant == 1))
```

## Scoring all participants
To calculate the SSRTi score for each participant, we will use R's native `by` function and convert the result to a data frame.
```
scores <- by(
  ds_sst,
  ds_sst$participant,
  fn_score
)
data.frame(
  participant = names(scores),
  score = as.vector(scores)
)
```

<br />

# Estimating split-half reliability

## Calculating split scores
To calculate split-half scores for each participant, use the function `by_split`. The first three arguments of this function are the same as for `by`. An additional set of arguments allow you to specify how to split the data and how often. In this vignette we will calculate scores of 1000 bootstrapped splits. The trial properties `condition` and `stim` were counterbalanced in the Go/No Go design. We will stratify splits by these trial properties. Note that `by_split` offers a large number of additional splitting options, such as first-second half, odd-even, split-full, and stratified splitting.

The `by_split` function returns a data frame with the following columns:

* `participant`, which identifies participants
* `replication`, which counts replications
* `score_1` and `score_2`, which are the scores calculated for each of the split datasets

*Calculating the split scores may take a while. By default, `by_split` uses all available CPU cores, but no progress bar is displayed. Setting `ncores = 1` will display a progress bar, but processing will be slower.*

```
split_scores <- by_split(
  ds_sst,
  ds_sst$participant,
  fn_score,
  replications = 1000,
  stratification = ds_sst$condition,
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
