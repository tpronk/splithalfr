#' Calculate Flanagon-Rulon coefficient
#'
#' Flanagon-Rulon reliability coefficient. Formula obtained from
#' Warrens (2015) <\doi{10.1007/s11634-015-0198-6}>
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) Flanagon-Rulon coefficient
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate coefficient
#' flanagan_rulon(vars[,1], vars[,2])
#' @family splithalfr coefficients
#' @export
flanagan_rulon <- function (x, y) {
  return ((4 * cov(x, y)) / (var(x) + var(y) + 2 * cov(x, y)))
}

#' Calculate Spearman-brown coefficient
#'
#' Spearman-Brown reliability coefficient for doubling test length. Formula
#' obtained from Warrens (2015) <\doi{10.1007/s11634-015-0198-6}>
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @param fn_cor (function) a function returning a correlation coefficient
#' @param ... Arguments passed to \code{fn_cor}
#' @return (numeric) Spearman-Brown coefficient
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate coefficient based on Pearson correlation
#' spearman_brown(vars[,1], vars[,2])
#' # Calculate coefficient based on ICC, two-way, random effects, absolute agreement, single rater
#' spearman_brown(vars[,1], vars[,2], short_icc, type = "ICC1", lmer = FALSE)
#' @family splithalfr coefficients
#' @export
spearman_brown <- function (x, y, fn_cor = cor, ...) {
  correlation = fn_cor(x, y, ...)
  return (2 * correlation / (1 + correlation))
}

#' Calculate Angoff-Feldt coefficient
#'
#' Angoff-Feldt reliability coefficient.
#' Formula obtained from Warrens (2015) <\doi{10.1007/s11634-015-0198-6}>
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) Angoff-Feldt cefficient
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate coefficient
#' angoff_feldt(vars[,1], vars[,2])
#' @family splithalfr coefficients
#' @export
angoff_feldt <- function (x, y) {
  var_all = var(x) + var(y) + 2 * cov(x, y)
  return ((4 * cor(x, y) * sd(x) * sd(y)) / (var_all - ((var(x) - var(y)) / var_all) ^ 2))
}

#' Calculate Intraclass Correlation Coefficient (ICC)
#'
#' Wrapper for ICCs calculated via \code{\link[psych]{ICC}}. If x or y have 
#' less than two elements, NA is returned.
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @param type (character) type of ICC to calculate, see \code{\link[psych]{ICC}}
#' @param ... Arguments passed to \code{\link[psych]{ICC}}
#' @return (numeric) Value of ICC coefficient
#' @family splithalfr coefficients
#' @export
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate ICC1
#' short_icc(vars[,1], vars[,2], type = "ICC1", lmer = FALSE)
short_icc <- function (x, y, type = c("ICC1", "ICC2", "ICC3", "ICC1k", "ICC2k", "ICC3k"), ...) {
  if (length(x) < 2 || length(y) < 2) {
    return (NA)
  }
  icc_result <- ICC(cbind(x, y), ...)$results
  return (icc_result[icc_result$type == type[1],]$ICC)
}


#' SD ratio of equalities or greater inequalities
#' 
#' Returns the ratio of the SDs of \code{x} and \code{y}, using the largest
#' SD of the two as denominator. Hence, the result is always 1 (ratio of
#' equalities) or greater than 1 (ratio of greater inequalities).
#' If x or y have less than two elements, NA is returned.
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) SD ratio
#' @family splithalfr coefficients
#' @export
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate SD ratio of left and right variables
#' sdregi(vars[,1], vars[,2])
#' # Calculate SD ratio of right and left variables; should give same result
#' sdregi(vars[,1], vars[,2])
sdregi <- function (x, y) {
  if (length(x) < 2 || length(y) < 2) {
    return (NA)
  }  
  ratio <- sd(x) / sd(y)
  if (ratio < 1) {
    ratio <- 1 / ratio
  }
  return (ratio)
}

#' Calculate Absolute Strictly Standardized Mean Difference (ASSMD)
#' 
#' Returns the absolute difference of the mean of \code{x} and \code{y} 
#' divided by their shared standard deviation. Since the resulting difference 
#' is absolute, the larger of the two means is always used as minuend and the
#' smallest as subtrahend. Based on 
#' Zhang (2012) <\doi{10.1016/j.ygeno.2006.12.014}>
#'
#' @param x (vector) a numeric vector
#' @param y (vector) a numeric vector with compatible dimensions to x
#' @return (numeric) Absolute SSMD
#' @family splithalfr coefficients
#' @export
#' @examples
#' # Generate two variables with different means, variances and a correlation of about 0.5
#' library(MASS)
#' vars = mvrnorm(30, mu = c(0, 2), Sigma = matrix(c(5, 2, 2, 3), ncol = 2), empirical = TRUE)
#' # Calculate Absolute SSMD
#' assmd(vars[,1], vars[,2])
assmd <- function (x, y) {
  shared_sd <- (var(x) + var(y) + 2 * cov(x, y)) ^ 0.5
  b <- abs((mean(x) - mean(y)) / shared_sd)
  return (b)
}
