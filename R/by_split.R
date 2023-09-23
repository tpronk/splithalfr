#' Calculate split scores per participant
#'
#' Calculates split scores, by applying \code{fn_score} to subsets of
#' \code{data} as specified via \code{participants}. It provides a range of
#' additional arguments for different splitting methods and to support parallel
#' processing. To learn more about writing scoring algorithms for use with the
#' \code{\link{splithalfr}}, see the included vignettes. \code{\link{by_split}}
#' is modeled after the \code{\link{by}} function, accepting similar values for
#' the first three arguments (\code{data}, \code{INDICES}, \code{FUN}). For more
#' information about different metods for splitting data, see
#' \code{\link{get_split_indexes_from_stratum}}. For more information about 
#' stratification, see \code{\link{split_df}}
#'
#' @param data (data frame) data frame containing data to score. Data should be
#'   in long format, with one row per combination of participant and trial or
#'   item.
#' @param participants (vector) Vector that identifies participants in
#'   \code{data}.
#' @param fn_score (function) receives full or split sets, should return a
#'   single number.
#' @param stratification (vector). Vector that identifies which subsets of
#'   \code{data} should be split separately (denoted as strata in splitting
#'   functions) in order to ensure they are evenly distributed between parts.
#'   By default, the dataset of a participant formes a single stratum.
#' @param replications (numeric) Number of replications that split scores are
#'   calculated.
#' @param method (character) Splitting method. Note that \code{first_second} and
#'   \code{odd_even} splitting method will only deliver a valid split with
#'   default settings for other arguments (\code{split_p = 0.5, replace = FALSE,
#'   subsample_p = 1})
#' @param replace (logical) If TRUE, stratum is sampled with replacement.
#' @param split_p (numeric) Desired length of both parts, expressed as a
#'   proportion of the length of the data per participant. If \code{split_p}
#'   is larger than 1 and \code{careful} is FALSE, then parts are automatically
#'   sampled with replacement
#' @param subsample_n (numeric) Subsample a number of participants before
#'   splitting.
#' @param subsample_p (numeric) Subsample a proportion of \code{stratum} before
#'   splitting.
#' @param careful (boolean) If TRUE, stop with an error when called with
#'   arguments that may yield unexpected splits
#' @param match_participants (logical) Default FALSE. If FALSE, the split-halves
#'   are newly randomized for each iteration and participant. If TRUE, the
#'   split-halves are newly randomized for each replication, but within a
#'   replication the same randomization is applied across participants. If the
#'   order of rows of datasets per participant denotes similar observations
#'   (such as items in a questionnaire), \code{match_participants} can be set to
#'   TRUE to ensure that per iteration, the same items are assigned to each part
#'   of the split-halves across participants. If \code{method} is "odd_even" or
#'   "first_second", splits are based on row number, so
#'   \code{match_participants} generally has little effects. If TRUE, each 
#'   stratum
#'   should have the same number of rows, as checked via 
#'   \code{\link{check_strata}}.
#' @param ncores (integer). By default, all available CPU cores are used. If 1,
#'   split replications are executed serially (via \code{\link{lapply}}). If
#'   greater than 1, split replications are executed in parallel, via (via
#'   \code{\link{parLapply}}).
#' @param seed (integer). When split replications are exectured in parallel,
#'   \code{seed} can be used to specificy a random seet to generate random seeds
#'   from for each worker via \code{\link{clusterSetRNGStream}}.
#' @param verbose (logical) If TRUE, reports progress. Note that progress across
#'   split replications is not displayed when these are executed in parallel.
#' @return (data frame) Returns a data frame with a column for
#'   \code{participant}, a column \code{replication} that counts split
#'   replications, and \code{score_1} and \code{score_2} for the score
#'   calculated of each part via \code{fn_score}.
#' @examples
#' # N.B. This example uses R script from the vignette: "rapi_sum"
#' data("ds_rapi", package = "splithalfr")
#' # Convert to long format
#' ds_long <- reshape(
#'   ds_rapi,
#'   varying = paste("V", 1 : 23, sep = ""),
#'   v.names = "answer",
#'   direction = "long",
#'   idvar = "twnr",
#'   timevar = "item"
#' )
#' # Function for RAPI sum score
#' rapi_fn_score <- function (data) {
#'   return (sum(data$answer))
#' }
#' # Calculate scores on full data
#' by(
#'   ds_long,
#'   ds_long$twnr,
#'   rapi_fn_score
#' )
#' # Permutation split, one iteration, items matched across participants
#' split_scores <- by_split(
#'   ds_long,
#'   ds_long$twnr,
#'   rapi_fn_score,
#'   ncores = 1,
#'   match_participants = TRUE
#' )
#' # Mean flanagan-rulon coefficient across splits
#' fr <- mean(split_coefs(split_scores, flanagan_rulon))
#' @export
by_split <- function (
  data,
  participants,
  fn_score,
  stratification = NULL,  
  replications = 1,
  method = c("random", "odd_even", "first_second"),
  replace = FALSE, 
  split_p = 0.5, 
  subsample_p = 1, 
  subsample_n = NULL,
  careful = TRUE,
  match_participants = FALSE,    
  ncores = detectCores(),
  seed = NULL,
  verbose = TRUE
) {
  # first_second and odd-even splitting with more than 1 replication is suspicious, stop
  if (careful && method[1] %in% c("first_second", "odd_even") && replications > 1) {
    stop (paste("Multiple replications of method", method[1], 
      "each give the same result. This error can be",
      "disabled by setting careful = FALSE"
    ))  
  }
  
  # IDs of each participant
  participant_ids = unique(participants)
  if (!is.null(subsample_n)) {
    participant_ids <- sample(participant_ids, subsample_n)
  }
  
  # Create a list of lists, containing each participant and stratum
  if (verbose) {
    cat("Preparing strata", fill = TRUE)
    pb <- txtProgressBar(min = 0, max = length(participant_ids), style = 3)
  }
  ds_participants = lapply(
    1 : length(participant_ids),
    function (i, participant_ids) {
      if (verbose) {
        setTxtProgressBar(pb, i)
      }
      if (is.null(stratification)) {
        # No stratification -> only one stratum
        return (list(
          data[participants == participant_ids[i], ]
        ))
      } else {
        # Yes stratification 
        return (stratify(
          data[participants == participant_ids[i], ],
          stratification[participants == participant_ids[i]]
        ))
      }      
    },
    participant_ids = participant_ids
  )
  
  if (verbose) {
    close(pb)
  }  
  
  # If matched participants, check if each has the same number of rows in 
  # each stratum
  if (match_participants) {
    if (verbose) {
      cat("Checking strata", fill = TRUE)
      pb <- txtProgressBar(min = 0, max = length(participant_ids), style = 3)
    }  
    ds_base <- ds_participants[[1]]
    lapply(
      1 : length(participant_ids),
      function (i, data, participant_ids) {
        if (verbose) {
          setTxtProgressBar(pb, i)
        }
        participant_id <- participant_ids[i]
        tryCatch({check_strata(ds_base, data[[i]])},
          error = function(e) {
           stop(paste(
             "For participant", participant_id, "the strata specified",
             "via 'stratification' did not match those specified before:",
             e
           ))
          }
        )    
      },
      data = ds_participants,
      participant_ids = participant_ids
    )
    if (verbose) {
      close(pb)
    }  
  } else {
    ds_base <- NA
  }
  
  if (verbose) {
    cat("Calculating split scores", fill = TRUE)
  }  
  
  # Setup serial or parallel lapply
  if (ncores == 1) {
    # Serial lapply
    fn_apply <- lapply
    if (verbose) {
      pb <- txtProgressBar(min = 0, max = replications, style = 3)    
    }
  } else {
    # Parallel lapply
    if (ncores < 1) {
      stop(paste0(
        "The number of CPU cores specified via ncores (", ncores, ") ",
        "should at least be 1." 
      ))
    }
    if (ncores > detectCores()) {
      stop(paste0(
        "The number of CPU cores specified via ncores (", ncores, ") ",
        "was higher than the number available (", detectCores(), "). ",
        "Leave ncores unspecified to have splithalfr::by_split use all available ",
        "CPU cores or set ncores = 1 to run in serial mode."
      ))
    }
    cl <- makeCluster(ncores)
    clusterExport(cl, list(
      "bind_rows", "ncores",
      "subsample_p", "split_p", "replace", "method", "ds_base", "verbose", 
      "match_participants", "ds_participants", "participant_ids", "fn_score"
    ), envir=environment())
    fn_apply <- function (...) {
      parLapply(cl, ...)
    }
    if (!is.null(seed)) {
      clusterSetRNGStream(cl, seed)
    }
  }

  # Calculate split scores
  ds_result = fn_apply(
    1 : replications,
    function (replication_i) {
      if (verbose && ncores == 1) {
        setTxtProgressBar(pb, replication_i)
      }
      if (match_participants) {
        # If matched participants, split once, use same indexes for all
        indexes <- get_split_indexes_from_strata(
          ds_base,
          method = method,
          replace = replace, 
          split_p = split_p, 
          subsample_p = subsample_p, 
          careful = careful
        )
      }
      # Calculate split scores for each participant
      splitted_scores = lapply(
        seq_along(ds_participants),
        function (i, data, participant_ids) {
          if (match_participants) {
            # If matched participants, use indexes calculated earlier
            splitted_sets <- apply_split_indexes_to_strata(data[[i]], indexes)
          } else {
            # Else, a unique split for each participant
            splitted_sets <- split_strata(
              data[[i]],
              method = method,
              replace = replace, 
              split_p = split_p, 
              subsample_p = subsample_p, 
              careful = careful
            )
          }
          # Score per split
          return (data.frame(
            participant = participant_ids[i],
            score_1 = fn_score(bind_rows(splitted_sets[[1]])),
            score_2 = fn_score(bind_rows(splitted_sets[[2]])),
            stringsAsFactors = FALSE
          ))
        },
        data = ds_participants,
        participant_ids = participant_ids
      )
      splitted_scores <- bind_rows(splitted_scores)
      splitted_scores$replication <- replication_i
      return (splitted_scores)
    }
  )
  if (verbose && ncores == 1) {
    close(pb)
  }  
  if (ncores > 1) {
    stopCluster(cl)
  }
  if (verbose) {
    cat("Wrapping up", fill = TRUE)
  }
  ds_result = bind_rows(ds_result)
  return (ds_result)
}