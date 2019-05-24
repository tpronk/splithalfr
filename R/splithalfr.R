#' splithalfr: Extensible Bootstrapped Split-half Reliabilities
#'
#' Calculates scores and bootstrapped split-half reliabilities for reaction time (RT) tasks and questionnaires.
#' The splithalfr can be extended by custom scoring methods for user-provided datasets.
#'
#' The splithalfr vignettes demonstrate how to write a custom scoring method based on a set of common questionnaire and RT task scoring methods,
#' using included example datasets:
#' \itemize{
#'   \item \code{vignette("rapi_sum")} Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index (\href{https://research.alcoholstudies.rutgers.edu/rapi}{White & Labouvie, 1989})
#'   \item \code{vignette("vpt_diff_of_means")} Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data (\href{https://doi.org/10.1080/026999399379050}{Mogg & Bradley, 1999})
#'   \item \code{vignette("aat_double_diff_of_medians")} Double difference of medians for correct responses on Approach Avoidance Task data (\href{http://doi.org/10.1016/j.brat.2007.08.010}{Heuer, Rinck, & Becker, 2007})
#'   \item \code{vignette("iat_dscore_ri")} Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial (\href{http://dx.doi.org/10.1037/0022-3514.85.2.197}{Greenwald, Nosek, & Banaji, 2003})
#' }
#' The code included in each vignette also serves as a test of correct functioning of the splithalfr, by comparing the splithalfr
#' score for a single participant with the same score calculated via Excel. The materials for each test can be found on
#' \href{https://github.com/tpronk/splithalfr/tree/master/tests}{the splithalfr GitHub repository}
#'
#' @importFrom dplyr %>% group_by group_modify summarize
#' @importFrom stats cor sd
#' @importFrom rlang .data parse_quo caller_env
#' @docType package
#' @name splithalfr
NULL

#' Splits a list, vector, or data frame, into two random halves of similar size
#'
#' @keywords internal
#' @param set (list, vector, or data frame) object to split
#' @return (list) List with two elements that contain each of the two splits of set. Lists and vectors are split by elements, while data frames are split by rows
makesplit <- function (set) {
  if (!is.data.frame(set)) {
    # If list or vector, index elements
    splits <- sample(
      rep(1:2, ceiling(length(set) / 2))
    )[1 : length(set)]
    return (list(
      set[splits == 1],
      set[splits == 2]
    ))
  } else {
    # If data frame, index rows
    splits <- sample(
      rep(1:2, ceiling(nrow(set) / 2))
    )[1 : nrow(set)]
    return (list(
      set[splits == 1, ],
      set[splits == 2, ]
    ))
  }
}

#' Applies an fn_score on split data
#'
#' @keywords internal
#' @param sets (list) list of vectors, data frames, and lists to feed into fn_score. Each element of sets is split in two random halves of similar size
#' @param fn_score (function) called with split sets as argument, should return a single value
#' @return (mixed) Data frame with one row and two columns; score_1 and score_2, which contain the result of the fn_score applied to each split
split_score <- function (
  sets = NULL,
  fn_score = NULL
) {
  sets_split <- lapply(sets, makesplit)
  sets_split <- unlist(sets_split, recursive = FALSE)
  sets_1 <- sets_split[2 * (1 : (length(sets_split) / 2)) - 1]
  sets_2 <- sets_split[2 * (1 : (length(sets_split) / 2)) - 0]
  names(sets_1) <- substr(names(sets_1), 1, nchar(names(sets_1)) - 1);
  names(sets_2) <- substr(names(sets_2), 1, nchar(names(sets_2)) - 1);
  return (data.frame(
    score_1 = fn_score(sets_1),
    score_2 = fn_score(sets_2)
  ))
}

#' Apply a scoring method to each participation using full or split data sets
#'
#' @export
#' @param ds (data frame) data frame containing data to score
#' @param participation_id (character) name of column that identifies participations in ds
#' @param fn_sets (function) receives data from a single participation, should return a list of sets that may be split
#' @param fn_score (function) receives full or split sets, should return a single number
#' @param split_count (numeric) Default: 0. If 0, applies fn_score on full set. If > 0, applies fn_score to split sets, split_count times
#' @return (data frame) If split_count == 0, applies fn_score result on full data and returns a data frame with a column for participation_id and a column named "score" for fn_score applied to the full data of a participation. If split_count > 0, applies fn_score on full data and returns data frame with a column for participation_id, a column "split" that counts splits, and "score_1" and "score_2" for fn_score applied to each split.
sh_apply <- function (
  ds,
  participation_id,
  fn_sets,
  fn_score,
  split_count = 0
) {
  participation_var = parse_quo(participation_id, env = caller_env())
  if (split_count == 0) {
    ds_result <- ds %>%
      # For each participation...
      group_by(!!participation_var) %>%
      # Apply this function to the data
      group_modify(function (ds_group, grouping_vars) {
        sets <- fn_sets(ds_group)
        score <- fn_score(sets)
        return (data.frame(
          score = score
        ))
      })
    return(ds_result)
  } else {
    ds_result <- NULL
    for (split_i in 1 : split_count) {
      print(paste("Split", split_i, "of", split_count))
      ds_scores <- ds %>%
        # For each participation...
        group_by(!!participation_var) %>%
        # Apply this function to the data
        group_modify(function (ds_group, grouping_vars) {
          return(split_score(
            # Step 1, sets we use in calculation
            sets = fn_sets(ds_group),
            fn_score = fn_score
          ))
        })
      ds_scores$split <- split_i
      if (is.null(ds_result)) {
        ds_result <- ds_scores
      } else {
        ds_result <- rbind(ds_result, ds_scores)
      }
    }
    return (ds_result)
  }
}

# *************
# *** splithalver Reliability Functions

#' Flanagon-Rulon reliability
#'
#' @keywords internal
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) Flanagon-Rulon reliability
flanagan_rulon <- function (x, y) {
  return ((4 * cor(x, y) * sd(x) * sd(y)) / (sd(x) ^ 2 + sd(y) ^ 2 + 2 * cor(x, y) * sd(x) * sd(y)))
}

#' Spearman-Brown reliability
#'
#' @keywords internal
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) Spearman-Brown reliability
spearman_brown <- function (x, y) {
  return (2 * cor(x,y) / (1 + cor(x,y)))
}

#' Reliability coefficient averaged over each split. Can be applied to output of sh_apply
#'
#' @keywords internal
#' @param ds (data frame) a data frame with columns "split", "score_1", and "score_2"
#' @param fn_rel (function) a function that serves as reliability measure
#' @return (numeric) mean of reliabilities
mean_rel_by_split <- function (ds, fn_rel) {
  # Check on missing values
  if (any(is.na(ds[c("score_1", "score_2")]))) {
    warning ("input data contained missing values; these were pairwise removed before calculating reliability")
    # Remove missing values pairwise
    rows_missing = is.na(ds$score_1) | is.na(ds$score_2)
    ds = ds[!rows_missing,]
  }
  ds_rs <- ds %>%
    group_by(split) %>%
    summarize(
      r = fn_rel(.data$score_1, .data$score_2)
    )
  return (mean(ds_rs$r))
}

#' Flanagon-Rulon reliability averaged over each split. Can be applied to output of sh_apply
#'
#' @export
#' @param ds (data frame) a data frame with columns "split", "score_1", and "score_2"
#' @return (numeric) mean Flanagon-Rulon reliability
mean_fr_by_split <- function (ds) {
  return (mean_rel_by_split(ds, flanagan_rulon))
}

#' Spearman-Brown reliability averaged over each split. Can be applied to output of sh_apply
#'
#' @export
#' @param ds (data frame) a data frame with columns "split", "score_1", and "score_2"
#' @return (numeric) mean Spearman-Brown reliability
mean_sb_by_split <- function (ds) {
  return (mean_rel_by_split(ds, spearman_brown))
}

