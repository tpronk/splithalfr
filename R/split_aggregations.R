#'Calculate a bivariate coefficient for each split-half replication
#'
#'Calculates a bivariate coefficient across participants for each split-half
#'replication and returns their values calculated across
#'replications. \code{ds} should be a data frame as returned by
#'\code{\link{by_split}}: For each unique value of the column \code{split} in
#'\code{ds}, it selects the corresponding rows in \code{ds}, and passes the
#'values in the columns \code{score_1} and \code{score_2} as the first and
#'second argument to \code{fn_coef}. Any row in \code{ds} for which
#'\code{score_1} or \code{score_2} is NA is pairwise removed before passing the
#'data to \code{fn_coef}. For averaging internal consistency coefficients,
#'see Feldt and Charter (2006).
#'
#'@param ds (data frame) a data frame with columns \code{split}, \code{score_1},
#'  and \code{score_2}
#'@param fn_coef (function) a function that calculates a bivariate coefficient.
#'@param ... Additional arguments passed to \code{fn_coef}
#'@return Coefficients per split calculated via \code{fn_coef}.
#'@section References:
#'
#'  Feldt, L. S., & Charter, R. A. (2006). Averaging internal consistency
#'  reliability coefficients. \emph{Educational and Psychological Measurement},
#'  66(2), 215-227. \doi{10.1177/0013164404273947}
#'
#' @examples
#' # Generate five splits with scores that are correlated 0.00, 0.25, 0.5, 0.75, and 1.00
#' library(MASS)
#' ds_splits = data.frame(score_1 = numeric(), score_2 = numeric(), replication = numeric())
#' for (r in 0:4) {
#'   vars = mvrnorm(10, mu = c(0, 0), Sigma = matrix(c(10, 3, 3, 2), ncol = 2), empirical = FALSE)
#'   ds_splits = rbind(ds_splits, cbind(vars, r))
#' }
#' names(ds_splits) = c("score_1", "score_2", "replication")
#' # Pearson correlations
#' split_coefs(ds_splits, cor)
#' # Spearman-brown corrected Pearson correlations
#' split_coefs(ds_splits, spearman_brown)
#' # Flanagan-Rulon coefficient
#' split_coefs(ds_splits, flanagan_rulon)
#' # Angoff-Feldt coefficient
#' split_coefs(ds_splits, angoff_feldt)
#' # Spearman-Brown corrected ICCs
#' split_coefs(
#'   ds_splits,
#'   spearman_brown,
#'   short_icc,
#'   type = "ICC1",
#'   lmer = FALSE
#' )
#'@family split aggregation functions
#'@export
split_coefs <- function (ds, fn_coef, ...) {
  ds <- ds[not_missing_casewise(ds[c ("score_1", "score_2")]), ]
  ds_rs <- ds %>%
    group_by(.data$replication) %>%
    summarize(
      coef = fn_coef(.data$score_1, .data$score_2, ...)
    )
  return (ds_rs$coef)
}

# Returns a vector that is true for each row that has no missing values (NA, NaN)
not_missing_casewise <- function (ds) {
  return (apply(
    ds,
    1,
    function (ds_row) {
      return (all(!is.na(ds_row)))
    }
  ))
}

#' Generate bootstrap replicates of a coefficient split-half reliability
#' estimate by sampling participants
#'
#' Generates bootstrap replicates via \code{\link[boot]{boot}}. The parameter
#' \code{ds} should be a data frame as returned by \code{\link{by_split}}: Each
#' unique value of the column \code{participant} is considered a independent
#' sample of the target population. For each unique value of the column
#' \code{split} in \code{ds}, it selects the corresponding rows in \code{ds},
#' and passes the values in the columns \code{score_1} and \code{score_2} as the
#' first and second argument to \code{fn_coef}. Any row in \code{ds} for which
#' \code{score_1} or \code{score_2} is NA is pairwise removed before passing the
#' data to \code{fn_coef}. Any coefficient that is NA is removed before passing
#' the data to \code{fn_summary}.
#' 
#' For a practical example, see one of the vignettes for getting started with
#' the splithalfr. Also, note that the boot package supports parallel processing
#' via the parameters `parallel` and `ncpus`.
#'
#' For averaging internal consistency coefficients, see Feldt and Charter
#' (2006). For more information about bias-corrected and accelerated bootstrap
#' confidence intervals, see Efron (1987).
#'
#' @param ds (data frame) a data frame with columns \code{split},
#'   \code{score_1}, and \code{score_2}
#' @param fn_coef (function) a function that calculates a bivariate
#'   (reliability) coefficient
#' @param fn_average (function) a function that calculates an average across
#'   coefficients
#' @param bootstrap_replications (integer) number of bootstrap replications
#' @param parallel (character) Type of parallel processing (if any) used for bootstrapping. See \code{\link[boot]{boot}}
#' @param ncpus (character) Number of cores for parallel processing. See \code{\link[boot]{boot}}
#' @param ... Additional arguments passed to \code{\link[boot]{boot}}
#' @return Confidence interval
#' @examples
#' # Import boot library
#' library(boot)
#' # Generate five splits with scores that are correlated 0.00, 0.25, 0.5, 0.75, and 1.00
#' library(MASS)
#' ds_splits = data.frame(V1 = numeric(), V2 = numeric(), split = numeric())
#' for (r in 0:4) {
#'   vars = mvrnorm(10, mu = c(0, 0), Sigma = matrix(c(10, 3, 3, 2), ncol = 2), empirical = FALSE)
#'   ds_splits = rbind(ds_splits, cbind(vars, r, 1 : 10))
#' }
#' names(ds_splits) = c("score_1", "score_2", "replication", "participant")
#' # Conduct bootstrap
#' bootstrap_result <- split_ci(ds_splits, cor, mean, parallel = "no")
#' # Get boosted and accelerated confidence intervals
#' print(boot.ci(bootstrap_result, type="bca"))
#' @section References:
#'
#'  Efron, B. (1987). Better bootstrap confidence intervals. \emph{Journal of the
#'  American statistical Association}, 82(397), 171-185.
#'   \doi{10.1080/01621459.1987.10478410}
#'
#'   Feldt, L. S., & Charter, R. A. (2006). Averaging internal consistency
#'   reliability coefficients. \emph{Educational and Psychological Measurement},
#'   66(2), 215-227. \doi{10.1177/0013164404273947}
#' @family split aggregation functions
#' @export
split_ci <- function(ds, fn_coef, fn_average, bootstrap_replications = 1000, parallel = "snow", ncpus = detectCores(), ...) {
  # Replicated in split_ci to let it be imported into a snow cluster constructed by boot
  not_missing_casewise <- function (ds) {
    return (apply(
      ds,
      1,
      function (ds_row) {
        return (all(!is.na(ds_row)))
      }
    ))
  }
  
  # Split iterations to average
  split_indexes = unique(ds$replication)
  
  # Prepare data for bootstrap; one row per participant
  ds_wide <- reshape(
    ds,
    timevar = c("replication"),
    v.names = c("score_1", "score_2"),
    idvar   = c("participant"),
    direction = "wide"
  )
  
  # Calculates averaged coefficient per split
  func <- function (original, indexes) {
    ds_resampled <- original[indexes,]
    coefs <- sapply(
      split_indexes,
      function (split_i, ds_wide) {
        ds <- ds_wide[not_missing_casewise(ds_wide[, c(
          paste("score_1", split_i, sep = "."),
          paste("score_2", split_i, sep = ".")          
        )]), ]
        fn_coef(
          ds[, paste("score_1", split_i, sep = ".")],
          ds[, paste("score_2", split_i, sep = ".")]
        )
      },
      ds_wide = ds_resampled
    )  
    return (fn_average(coefs))
  }
  
  # Conduct and return bootstrap
  boot_result = boot(data = ds_wide, statistic = func, R = bootstrap_replications, parallel = parallel, ncpus = ncpus, ...)
  return (boot_result)  
}
