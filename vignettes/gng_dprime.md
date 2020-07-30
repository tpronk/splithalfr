---
title: "Go/No Go - D-prime"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{gng_dprime}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(splithalfr)
```

This vignette describes the d-prime; a scoring method introduced by [Miller (1996)](https://doi.org/https://doi.org/10.3758/BF03205476). 

<br />

# Dataset
Load the included Go/No Go dataset and inspect its documentation.
```
data("ds_gng", package = "splithalfr")
?ds_gng
```

## Relevant variables
The columns used in this example are:

* condition, 0 = go, 2 = no go
* response. Correct (1) or incorrect (0)
* rt. Reaction time (seconds)
* participant. Participant ID

## Counterbalancing
The variables `condition` and `stim` were counterbalanced. Below we illustrate this for the first participant.
```
ds_1 <- subset(ds_gng, participant  == 1)
table(ds_1$condition, ds_1$stim)
```

<br />


# Scoring the Go/No Go

## Scoring function
The scoring function receives the data from a single participant. For the proportion of hits and false alarms, it calculates their quantiles given a standard normal distribution. Extreme values are adjusted for via the log-linear approach ([Hautus, 1995](https://doi.org/10.3758/BF03203619)).
```
fn_score <- function(ds) {
  n_hit <- sum(ds$condition == 0 & ds$response == 1)
  n_miss <- sum(ds$condition == 0 & ds$response == 0)
  n_cr <- sum(ds$condition == 2 & ds$response == 1)
  n_fa <- sum(ds$condition == 2 & ds$response == 0)
  p_hit <- (n_hit + 0.5) / ((n_hit + 0.5) + n_miss + 1)
  p_fa <- (n_fa + 0.5) / ((n_fa + 0.5) + n_cr + 1)  
  return (qnorm(p_hit) - qnorm(p_fa))
}
```

## Scoring a single participant
Let's calculate the d-prime score for the participant with UserID 1. 
```
fn_score(subset(ds_gng, participant == 1))
```

## Scoring all participants
To calculate the d-prime score for each participant, we will use R's native `by` function and convert the result to a data frame.
```
scores <- by(
  ds_gng,
  ds_gng$participant,
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

```
split_scores <- by_split(
  ds_gng,
  ds_gng$participant,
  fn_score,
  replications = 1000,
  stratification = paste(ds_gng$condition, ds_gng$stim)
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
