---
title: "IAT D-Score Repeat Incorrect Responses"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{iat_dscore_ri}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(splithalfr)
library(dplyr)
```
This vignette describes a scoring method introduced by [Greenwald, Nosek, and Banaji (2003)](http://dx.doi.org/10.1037/0022-3514.85.2.197); the improved d-score for Implicit Association Task (IATs) that require a correct response in order to continue to the next trial. This version of the d-score algorithm adds up all response times of all responses per trial. As this algorithm also specifies which participants to keep and to drop, functions from the [dplyr package](https://dplyr.tidyverse.org/) will be used to produce relevant summary statistics. Note that this vignette is more advanced that the others included in the `splithalfr` package, so it is not recommended as a first introduction on to how to use the splithalfr.

<br />

# Dataset
Load the included IAT dataset and inspect its documentation.
```
data("ds_iat", package = "splithalfr")
?ds_iat
```

## Relevant variables
The columns used in this example are:

* participation_id, which identifies participants
* block_type, which specifies IAT blocks relevant to calculate the d-score
* attempt, in order to add RTs for trials 
* response, in order to select correct responses only
* rt, in order to drop RTs outside of the range [200, 520] and calculate means per level of patt
* cat, which is the category each stimulus belonged to

## Preprocessing
The improved d-score algorithm specifies that participants whose RTs for over 10% of reponses are below 300 ms should be dropped. The R-script below identifies such participants. 
```
ds_summary <- ds_iat %>%
  dplyr::group_by(participation_id) %>%
  dplyr::summarize(
    too_fast = sum(rt < 300) / dplyr::n() > 0.1,
  )
```
One participant (participation_id 29) meets this exclusion criterion. Below, we remove this participant from the dataset.
```
ds_iat <- ds_iat[
  !(ds_iat$participation_id %in% 
  ds_summary[ds_summary$too_fast,]$participation_id), 
]
```

Next, delete any attempts with RTs > 10,000 ms. These do not exist in this IAT because a response window of 1500 ms was used, but the R-script is still added below for demonstration purposes.
```
ds_iat <- ds_iat[ds_iat$rt <= 10000, ]
```
Keep only data from the combination blocks.
```
ds_iat <- ds_iat[
  ds_iat$block_type %in% 
  c("tar1att1_1", "tar1att2_1", "tar1att1_2", "tar1att2_2"),
]
```

Finally, RTs for each participant, block, and trial are summed. The block_type and cat variables are also included, since they are used in further processing steps below.
```
ds_iat <- ds_iat %>%
  dplyr::group_by(participation_id, block, trial) %>%
  summarise(
    block_type = first(block_type),
    cat = first(cat),
    rt = sum(rt)
  )
```

<br />

## Counterbalancing
The variables `block_type` and `cat` were counterbalanced. Below we illustrate this for the first participant.
```
ds_1 <- subset(ds_iat, participation_id == 1)
table(ds_1$block_type, ds_1$cat)
```

<br />


# Scoring the IAT

## Scoring function
The score function receives these four data frames from a single participant. For both the pair of practice and test blocks, the following 'block score' is calculated:

1. Mean RT of target 1 with attribute 1 is calculated
2. Mean RT of target 1 with attribute 2 is calculated
3. The difference in mean RTs of both blocks is divided by the inclusive standard deviation (SD)

The d-score is the mean of the block scores for practice and test blocks. 
 
```
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
```

## Scoring a single participant
Let's calculate the IAT score for the participant with UserID 1. NB - This score has also been calculated manually via Excel in the splithalfr repository.
```
fn_score(subset(ds_iat, participation_id == 1))
```

## Scoring all participants
To calculate the IAT score for each participant, we will use R's native `by` function and convert the result to a data frame.
```
scores <- by(
  ds_iat,
  ds_iat$participation_id,
  fn_score
)
data.frame(
  participation_id = names(scores),
  score = as.vector(scores)
)
```

<br />

# Estimating split-half reliability

## Calculating split scores
To calculate split-half scores for each participant, use the function `by_split`. The first three arguments of this function are the same as for `by`. An additional set of arguments allow you to specify how to split the data and how often. In this vignette we will calculate scores of 1000 bootstrapped splits. The trial properties `block_type` and `cat` were counterbalanced in the IAT design. We will stratify splits by these trial properties. See the vignette on splitting methods for more ways to split the data.

The `by_split` function returns a data frame with the following columns:

* `participant`, which identifies participants
* `replication`, which counts replications
* `score_1` and `score_2`, which are the scores calculated for each of the split datasets

*Calculating the split scores may take a while. By default, `by_split` uses all available CPU cores, but no progress bar is displayed. Setting `ncores = 1` will display a progress bar, but processing will be slower.*

```
split_scores <- by_split(
  ds_iat,
  ds_iat$participation_id,
  fn_score,
  replications = 1000,
  stratification = paste(ds_iat$block_type, ds_iat$cat)
)
```

## Calculating reliability coefficients
Next, the output of `by_split` can be analyzed in order to estimate reliability. By default, functions are provided that calculate Spearman-Brown adjusted Pearson correlations (`spearman_brown`), Flanagan-Rulon (`flanagan_rulon`), Angoff-Feldt (`angoff_feldt`), and Intraclass Correlation (`short_icc`) coefficients. Each of these coefficient functions can be used with `split_coef` to calculate the corresponding coefficients per split, which can then be plotted or averaged via a simple `mean`. A bias-corrected and accelerated bootstrap confidence interval can be calculated via `split_ci`.

```
# Spearman-Brown adjusted Pearson correlations per replication
coefs <- split_coefs(split_scores, spearman_brown)
# Distribution of coefficients
hist(coefs)
# Mean of coefficients
mean(coefs)
# Confidence interval of coefficients
split_ci(split_scores, coefs)
```
