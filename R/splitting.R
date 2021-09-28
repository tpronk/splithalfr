#' Split a data frame into two parts
#'
#' Splits \code{data}, Applies a stratified split to a data frame and returns
#' each part. For more information about splitting options, and an extensive
#' list of examples, see \code{\link{get_split_indexes_from_stratum}}.
#'
#' @param data (data frame) Data to split, in long format, with one row per
#'   observation.
#' @param stratification (vector). Vector that identifies which subsets of
#'   \code{data} should be split separately (denoted as strata in splitting
#'   functions) in order to ensure they are evenly distributed between parts. 
#'   If NULL, all \code{data} is considered a single stratum.
#' @inheritDotParams get_split_indexes_from_stratum -stratum
#' @return (list) List with two elements that each contain one of two parts.
#' @examples
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' split_df(ds, method = "random")
#' split_df(ds, method = "odd_even")
#' split_df(ds, method = "first_second")
#' split_df(ds, stratification = ds$condition, method = "random")
#' split_df(ds, stratification = ds$condition, method = "odd_even")
#' split_df(ds, stratification = ds$condition, method = "first_second")
#' ds <- data.frame(condition = rep(c("a", "b"), 4), score = 1 : 8)
#' split_df(ds, method = "random")
#' split_df(ds, method = "odd_even")
#' split_df(ds, method = "first_second")
#' split_df(ds, stratification = ds$condition, method = "random")
#' split_df(ds, stratification = ds$condition, method = "odd_even")
#' split_df(ds, stratification = ds$condition, method = "first_second")
#' @export
#' @family splitting functions
split_df <- function (
  data,
  stratification = NULL,
  ...
) {
  # Construct strata
  strata <- stratify(data, stratification)
  # Construct split indexes
  indexes <- get_split_indexes_from_strata(
    strata, 
    ...
  )
  # Apply split indexes
  result <- apply_split_indexes_to_strata(
    strata, 
    indexes
  )
  return (result)
}



#' Stratify a data frame
#' 
#' Split a dataframe into strata formed by each a unique value of \code{stratification}.
#' 
#' @param ds (data frame) data to split into strata
#' @param stratification (vector). Vector that identifies which subsets of
#'   \code{data} should be split separately (denoted as strata in splitting
#'   functions) in order to ensure they are evenly distributed between patrs. 
#'   If NULL, all \code{data} is considered a single stratum.
#' @return (list) List of strata
#' @examples 
#' # Stratify a data frame, then split it odd-even
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' strata <- stratify(ds, ds$condition)
#' split_strata(strata, method = "odd_even")
#' @export  
#' @family splitting functions
stratify <- function(ds, stratification = NULL) {
  if (is.null(stratification)) {
    return (list(ds))
  } 
  # List of stratifications
  ds_stratified = by(
    ds,
    stratification,
    function (ds_stratum) {
      return (ds_stratum)
    },
    simplify = FALSE
  )
  return (ds_stratified)
}      



#' Split each stratum into two parts
#'
#' Splits each element of \code{strata} into two parts. For more information
#' about splitting options, and an extensive list of examples, see
#' \code{\link{get_split_indexes_from_stratum}}.
#'
#' @param strata (list) list of strata to split
#' @inheritDotParams get_split_indexes_from_stratum -stratum
#' @return (list) A list with two elements, containing the first and second
#'   split of \code{strata}.
#' @examples
#' # Stratify a data frame, then split it odd-even
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' strata <- stratify(ds, ds$condition)
#' split_strata(strata, method = "odd_even")
#' @export
#' @family splitting functions
split_strata <- function (
  strata,
  ...
) {
  indexes <- get_split_indexes_from_strata(strata, ...)
  return (apply_split_indexes_to_strata(strata, indexes))
}



#' Generate indexes for splitting strata
#'
#' Generates indexes for splitting each element of \code{strata} into two parts.
#' For more information about splitting options, and an extensive list of
#' examples, see \code{\link{get_split_indexes_from_stratum}}.
#'
#' @param strata (list) Strata to split
#' @inheritDotParams get_split_indexes_from_stratum -stratum
#' @return (list) A list with two elements, containing the first and second part
#'   of \code{strata}.
#' @examples
#' # Stratify a data frame, then split it odd-even
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' strata <- stratify(ds, ds$condition)
#' split_indexes <- get_split_indexes_from_strata(strata, method = "odd_even")
#' apply_split_indexes_to_strata(strata, split_indexes)
#' @export
#' @family splitting functions
get_split_indexes_from_strata <- function (
  strata,
  ...
) {
  indexes = lapply(
    strata,
    get_split_indexes_from_stratum,
    ...
  )
  return (indexes)
}



#' Split each element of a list of strata based on a list of indexes
#'
#' Splits each element of \code{strata} into two parts based on a list of
#' indexes. For more information about splitting options, and an extensive list
#' of examples, see \code{\link{get_split_indexes_from_stratum}}.
#'
#' @param strata (list) list of strata to split
#' @param indexes (list) list of indexes, which can be generated via
#'   \code{\link{get_split_indexes_from_strata}}
#' @return (list) A list with two elements, containing the first and second
#'   split of \code{strata}.
#' @examples
#' # Stratify a data frame, then split it odd-even
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' strata <- stratify(ds, ds$condition)
#' split_indexes <- get_split_indexes_from_strata(strata, method = "odd_even")
#' apply_split_indexes_to_strata(strata, split_indexes)
#' @export
#' @family splitting functions
apply_split_indexes_to_strata <- function (
  strata,
  indexes
) {
  # Join strata and indexes into one list
  split_stratated <- lapply(1 : length(strata), function(i) {
    return (apply_split_indexes_to_stratum(
      strata[[i]], indexes[[i]][[1]], indexes[[i]][[2]])
    )
  })
  split_stratated <- unlist(split_stratated, recursive = FALSE)
  # Splitted strata as two list
  result_list <- list()
  result_list[[1]] <- split_stratated[2 * (1 : (length(split_stratated) / 2)) - 1]
  result_list[[2]] <- split_stratated[2 * (1 : (length(split_stratated) / 2)) - 0]
  # Convert both elements of result_list to data frame
  result_df <- list()
  for (i in 1 : 2) {
    interim_result <- result_list[[i]]
    # Construct order of rows in result
    rownames <- as.numeric(unlist(lapply(interim_result, row.names)))
    row_order <- (1 : length(rownames))[order(rank(rownames))]
    # COnvers to data frame and order
    interim_result <- bind_rows(interim_result)[row_order,]
    result_df[[i]] <- interim_result
  }
  return (result_df)
}



#' Check whether two strata have the same structure
#'
#' Checks \code{strata} against \code{strata_left}. Each element of
#' \code{strata_left} should also be present in \code{strata}, be of a similar
#' type (data frame/tibble or list/vector), and be of similar size
#' (\code{\link{nrow}} for data frames/tibbles or \code{\link{length}} for
#' lists/vectors). Stops with an arror if any checks fail.
#' @param strata_left (list) strata to check against
#' @param strata_right (list) strata to check
#' @return None
#' @examples
#' check_strata(list(1 : 4), list(1 : 4))
#' @export
#' @family splitting functions
check_strata <- function(strata_left, strata_right) {
  #library(tibble)
  if (length(strata_left) != length(strata_right)) {
    stop (paste("Expected", length(strata_left), "elements but found", length(strata_right)))
  }  
  result = lapply(
    1 : length(strata_left), 
    function(name) {
      if (is.data.frame(strata_left[[name]]) || is_tibble(strata_left[[name]])) {
        # Check data frame
        if (!is.data.frame(strata_right[[name]]) && !is_tibble(strata_left[[name]])) {
          stop (paste("index", name, "was not a data frame nor tibble"))
        } else {
          if(nrow(strata_left[[name]]) != nrow(strata_right[[name]])) {
            stop (paste(
              "index", name, "was a data frame with", nrow(strata_right[[name]]), "rows, while", 
              nrow(strata_left[[name]]), "rows were expected"
            ))
          }
        }
      } else {
        # Check list or vector
        if(length(strata_left[[name]]) != length(strata_right[[name]])) {
          stop (paste(
            "index", name, "was a list or vector with", length(strata_right[[name]]), "elements, while", 
            length(strata_left[[name]]), "elements were expected"
          ))
        }
      }
    }
  )  
}  



#' Split a stratum into two parts
#'
#' Splits \code{stratum} into two parts. For more information
#' about splitting options, and an extensive list of examples, see
#' \code{\link{get_split_indexes_from_stratum}}.
#'
#' @param stratum (data frame, tibble, list, or vector) Stratum to split;
#'   dataframes and tibbles are counted and split by row. All other data types
#'   are counted and split by element
#' @inheritDotParams get_split_indexes_from_stratum
#' @return (list) List with two elements that contain each of the two parts of
#'   stratum split in two. 
#' @examples
#' # Split stratum odd-even
#' ds <- data.frame(condition = rep(c("a", "b"), each = 4), score = 1 : 8)
#' split_stratum(ds, method = "odd_even")
#' @export
#' @family splitting functions
split_stratum <- function (stratum, ...) {
  indexes = get_split_indexes_from_stratum(stratum, ...)
  return (apply_split_indexes_to_stratum(stratum, indexes[[1]], indexes[[2]]))
}



#' Generate indexes that can be used to split a stratum into two parts
#'
#' \code{get_split_indexes_from_stratum} returns a list with indexes for
#' splitting its \code{stratum} argument in two parts. The splits differ at most
#' by one in size. With default arguments, a random split-half is returned,
#' which samples elements for each part from \code{stratum} without replacement.
#' Via additional arguments to \code{get_split_indexes_from_stratum} a range of
#' other splitting methods can be applied.
#'
#' The following rounding rules apply to subsample size and split size:
#' \itemize{ \item If the size of the subsample, calculated as
#' \code{subsample_p} times size of \code{stratum}, is a fraction, then
#' subsample size is rounded up. \item If the joint size of the two parts,
#' calculated as 2 * \code{split_p} times size of the subsampled \code{stratum},
#' is a fraction, the part size is rounded up. \item If the joint size of the
#' two parts is odd and \code{replace} is FALSE, then one of the parts randomly
#' gets one more element than the other part. \item If the joint size of the two
#' parts is odd and \code{replace} is TRUE, part size is rounded up to the next
#' whole number, so each of the splits has the same size. }
#'
#' @param stratum (data frame, tibble, list, or vector) Object to split;
#'   dataframes and tibbles are counted and split by row. All other data types
#'   are counted and split by element
#' @param method (character) Splitting method. Note that \code{first_second} and
#'   \code{odd_even} splitting method will only deliver a valid split with
#'   default settings for other arguments (\code{subsample_p = 1, split_p = 1,
#'   replace = TRUE})
#' @param replace (logical) If FALSE, splits are constructed by sampling from
#'   stratum without replacement. If TRUE, stratum is sampled with replacement.
#' @param split_p (numeric) Desired joint size of both parts, expressed as a
#'   proportion of the size of the subsampled \code{stratum}. If \code{split_p}
#'   is larger than 1, and \code{careful} is FALSE, then parts are automatically
#'   sampled with replacement
#' @param subsample_p (numeric) Subsample a proportion of \code{stratum} to be
#'   used in the split.
#' @param careful (boolean) If TRUE, stop with an error when called with
#'   arguments that may yield unexpected splits
#' @return (list) List with two elements that contain indexes that can be used
#'   to split the stratum in two parts two splits of stratum.
#' @examples
#' # Split-half. One of the splits gets 4 elements and the other 5
#' stratum = letters[1:9]
#' indexes = get_split_indexes_from_stratum(stratum)
#' apply_split_indexes_to_stratum(stratum, indexes[[1]], indexes[[2]])
# # First-second split, The middle element is randomly assigned to part 1 or 2
# split_stratum(1 : 9, method = "first_second")
# # Odd-even split
# split_stratum(1 : 9, method = "odd_even")
# # Random split. One of the splits gets randomly gets 4 elements; the other 5
# split_stratum(1 : 9)
# # Random split, using half of the stratum (4.5 elements, rounded up to 5)
# split_stratum(1 : 9, subsample_p = 0.5)
# # Random splits with same size as stratum by sampling with replacement
# split_stratum(1 : 9, split_p = 1, replace = TRUE)
# # Random splits, same size as stratum, using half of stratum
# split_stratum(1 : 9, subsample_p = 0.5, split_p = 1, replace = TRUE)
# # Random split with replacement; each part gets 5 elements (4.5 rounded up)
# split_stratum(1 : 9, replace = TRUE)
# # Random split on a data frame
# split_stratum(data.frame(x = 1 : 4, y = 5 : 8))
# # Random split on a list
# split_stratum(list(p = 1, q = 2, r = 3, s = 4))
# # Random split where 1 gets 0.75 of the elements and 2 gets 0.25
# split_stratum(1 : 8, replace = FALSE, split_p = 0.75)
# split_stratum(1 : 9, replace = FALSE, split_p = 0.75)
#' @export
#' @family splitting functions
get_split_indexes_from_stratum <- function (
  stratum, 
  method = c("random", "odd_even", "first_second"),
  replace = FALSE, 
  split_p = 0.5, 
  subsample_p = 1, 
  careful = TRUE
) {
  # If careful, check arguments
  if (careful) {
    if (method[1] %in% c("first_second", "odd_even")) {
      if (subsample_p != 1) {
        stop (paste("method =", method[1], "in combination with subsample_p != 1",
          "may give unexpected results.",
          "This error can be disabled by setting careful = FALSE"
        ))
      }
      if (split_p != 0.5) {
        stop (paste("method =", method[1], "in combination with split_p != 0.5",
          "may give unexpected results.",
          "This error can be disabled by setting careful = FALSE"
        ))
      }
      if (replace) {
        stop (paste("method =", method[1], "in combination with replace =",
          replace, "may give unexpected results.",
          "This error can be disabled by setting careful = FALSE"
        ))
      }
    }

    if (split_p != 0.5 && split_p <= 1 && !replace) {
      warning (paste("split_p =", split_p, "in combination with replace =",
        replace, "may give unexpected results; any split_p != 0.5 and <= 1",
        "will sample with split_p for score1, and (1 - split_p) for score2.",
        "This error can be disabled by setting careful = FALSE"
      ))
    }
    
    if (split_p > 1 && !replace) {
      stop (paste("split_p =", split_p, "in combination with replace =",
        replace, "may give unexpected results; any split_p > 1 will automatically",
        "be sampled with replacement.",
        "This error can be disabled by setting careful = FALSE"
      ))
    }
  }    
  
  # If data frame, stratum_size is #rows. Else, remaining #elements
  if (is.data.frame(stratum)) {
    stratum_size = nrow(stratum)
  } else {
    stratum_size = length(stratum)
  }
  # Subsample indexes of stratum
  if (subsample_p > 1 || subsample_p < 0) {
    stop ("subsample_p should be in range [0, 1]")
  }
  if (subsample_p < 1) {
    # subsample_n is here the number of trials to sample
    subsample_n = ceiling(subsample_p * stratum_size)
    stratum_indexes = sample(1 : stratum_size, subsample_n)
    stratum_size = subsample_n
  } else {
    stratum_indexes = 1 : stratum_size
  }
  
  # If careful and only one element in stratum, stop with error
  if (careful && stratum_size < 2) {
    stop (paste(
      "A stratum had less than two elements, so splitting it",
      "may give unexpected results, this error can be",
      "disabled by setting careful = FALSE"      
    ))
  }
  
  # Simple cases; odd-even and first-second methods
  if (method[1] == "odd_even") {
    splits <- rep(1:2, ceiling(stratum_size / 2))[1 : stratum_size]
    indexes_1 = which(splits == 1)
    indexes_2 = which(splits == 2)
  } else if (method[1] == "first_second") {
    splits <- c(rep(1, ceiling(stratum_size / 2)), rep(2, ceiling(stratum_size / 2)))
    # If stratum_size is uneven, randomly remove one element from split at beginning or end
    if (stratum_size < length(splits)) {
      if (sample(1:2, 1) == 1) {
        splits = splits[-1]
      } else {
        splits = splits[-length(splits)]
      }
    }
    indexes_1 = which(splits == 1)
    indexes_2 = which(splits == 2)
  } else {
    # Random case
    # Size of current sample
    select_size = 2 * split_p * stratum_size
    # DEBUG
    # END DEBUG
    # Below we generate indexes_1 and indexes_2, which contain indexes of elements of stratum
    # that go to each split
    if (split_p <= 1 && !replace) {
      # in split_p <= 1, score1 will based on a part with size split_p and score on a part
      # with size (1 - split_p)
      select_size1 = split_p * stratum_size
      select_size2 = (1 - split_p) * stratum_size
      # Sample without replacement
      # splits contains a 1 for split 1, 2 for split 2, and 0 for elements that don't go to either
      # If select_size is uneven, stratum 1 or stratum 2 randomly gets an additional element
      splits <- sample(c(
        rep(1, ceiling(select_size1)),
        rep(2, ceiling(select_size2))
      ))[1 : ceiling(stratum_size)]
      # If there are remaining elements in stratum, add zeros for them and shuffle again
      split_length = length(splits) 
      if (split_length < stratum_size) {
        splits = c(splits, rep(0, stratum_size - split_length))
        splits = sample(splits)
      }
      indexes_1 = which(splits == 1)
      indexes_2 = which(splits == 2)
    } else {
      # Sample with replacement
      indexes_1 = sample(1 : stratum_size, ceiling(split_p * stratum_size), replace = TRUE)
      indexes_2 = sample(1 : stratum_size, ceiling(split_p * stratum_size), replace = TRUE)
    }
  }
  return (list(stratum_indexes[indexes_1], stratum_indexes[indexes_2]))
}

#' Split a stratum based on a list of indexes
#' 
#' Splits \code{stratum} into two parts based on a list of indexes.  For more information
#' about splitting options, and an extensive list of examples, see
#' \code{\link{get_split_indexes_from_stratum}}.
#' 
#' @param stratum (data frame, tibble, list, or vector) stratum to split 
#' @param indexes_1 (vector) indexes for first split, which can be generated via \code{\link{get_split_indexes_from_stratum}}
#' @param indexes_2 (vector) indexes for second split, which can be generated via \code{\link{get_split_indexes_from_stratum}}
#' @return (list) List with two elements that contain stratum split in two parts.
#' @examples 
#' # Random split-half. One of the splits gets 4 elements and the other 5
#' stratum =  letters[1:9]
#' indexes = get_split_indexes_from_stratum(stratum)
#' apply_split_indexes_to_stratum(stratum, indexes[[1]], indexes[[2]])
#' @export  
#' @family splitting functions
apply_split_indexes_to_stratum <- function (stratum, indexes_1, indexes_2) {
  # If data frame, index by rows. Else, index by elements
  if (is.data.frame(stratum)) {
    if (any(indexes_1 > nrow(stratum)) || any(indexes_2 > nrow(stratum))) {
      stop ("An index exceeded the number of rows in stratum")
    }
    return (list(
      stratum[indexes_1, ],
      stratum[indexes_2, ]
    ))
  } else {
    if (any(indexes_1 > length(stratum)) || any(indexes_2 > length(stratum))) {
      stop ("An index exceeded the length of stratum")
    }
    return (list(
      stratum[indexes_1],
      stratum[indexes_2]
    ))
  }      
}
