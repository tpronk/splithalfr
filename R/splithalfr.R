#' splithalfr: Split-Half Reliabilities
#'
#' Estimates split-half reliabilities for scoring algorithms of cognitive tasks and questionnaires. 
#' 
#' @section Getting started:
#' We've got six short vignettes to help you get started. You can open a vignette bij running the corresponding code snippets (\code{vignette(...)}) in the R console.
#' \itemize{
#'   \item \code{vignette("rapi_sum")} Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index (\doi{https://doi.org/10.15288/jsa.1989.50.30}{White & Labouvie, 1989})
#'   \item \code{vignette("vpt_diff_of_means")} Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data (Mogg & Bradley, 1999 <\doi{10.1080/026999399379050}>)
#'   \item \code{vignette("aat_double_diff_of_medians")} Double difference of medians for correct responses on Approach Avoidance Task data (Heuer, Rinck, & Becker, 2007 <\doi{10.1016/j.brat.2007.08.010}>)
#'   \item \code{vignette("iat_dscore_ri")} Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial (\href{https://pubmed.ncbi.nlm.nih.gov/12916565/}{Greenwald, Nosek, & Banaji, 2003})
#'   \item \code{vignette("sst_ssrti")} Stop-Signal Reaction Time integration method for data of a Stop Signal Task (\href{http://www.psy.vanderbilt.edu/faculty/logan/Logan(1981).pdf}{Logan, 1981})
#'   \item \code{vignette("gng_dprime")} D-prime for data of a Go/No Go task (Miller, 1996 <\doi{10.3758/BF03205476}>)
#' }
#' 
#' @section Splitting methods:
#' The splithalfr supports a variety of methods for splitting your data. We review and assess each  method in the compendium paper (Pronk et al., 2021 <\doi{https://doi.org/10.3758/s13423-021-01948-3}>). This vignette illustrates how to apply each splitting method via the splithalfr: \code{vignette("splitting_methods")}
#' \itemize{
#'   \item first-second and odd-even (Green et al., 2016 <\doi{10.3758/s13423-015-0968-3}>; Webb, Shavelson, & Haertel, 1996 <\doi{10.1016/S0169-7161(06)26004-8}>; Williams & Kaufmann, 2012 <\doi{10.1016/j.jesp.2012.03.001}>)
#'   \item stratified (Green et al., 2016 <\doi{10.3758/s13423-015-0968-3}>)
#'   \item permutated/bootstrapped/random sample of split halves (Kopp, Lange, & Steinke, 2021 <\doi{10.1177/1073191119866257}>, Parsons, Kruijt, & Fox, 2019 <\doi{10.1177/2515245919879695}>; Williams & Kaufmann, 2012 <\doi{10.1016/j.jesp.2012.03.001}>)
#'   \item Monte Carlo (Williams & Kaufmann, 2012 <\doi{10.1016/j.jesp.2012.03.001}>)
#' }
#' 
#' @section Validation of split-half estimations:
#' Part of the splithalfr algorithm has been validated via a set of simulations that are not included in this package.
#' The R script for these simulations can be found \href{https://github.com/tpronk/splithalfr_simulation}{here}.
#' 
#' 
#' @section Related packages:
#' These R packages offer bootstrapped split-half reliabilities for specific scoring algorithms and are available via CRAN at 
#' the time of this writing: 
#' \href{https://cran.r-project.org/package=multicon}{multicon}, 
#' \href{https://cran.r-project.org/package=psych}{psych}, and
#' \href{https://cran.r-project.org/package=splithalf}{splithalf}.
#' 
#' @section Acknowledgments:
#' I would like to thank 
#' \href{https://www.researchgate.net/profile/Craig-Hedge}{Craig Hedge},
#' \href{https://www.researchgate.net/profile/Eva-Schmitz}{Eva Schmitz},
#' \href{https://www.uva.nl/en/profile/h/a/f.hanna/f.hanna.html}{Fadie Hanna},
#' \href{https://scholar.google.com/citations?user=ugPnkjEAAAAJ&hl=en}{Helle Larsen},
#' \href{https://www.researchgate.net/profile/Marilisa-Boffo}{Marilisa Boffo}, and
#' \href{https://www.researchgate.net/profile/Marjolein-Zee-2}{Marjolein Zee}
#' for making datasets available for inclusion in the splithalfr.
#' Additionally, I would like to thank 
#' \href{https://www.researchgate.net/profile/Craig-Hedge}{Craig Hedge} and 
#' \href{https://www.swinburne.edu.au/research/our-research/access-our-research/find-a-researcher-or-supervisor/researcher-profile/?id=bwilliams}{Benedict Williams}
#' for sharing R-scripts with scoring algorithms that were adapted for splithalfr vignettes. 
#' Finally, I would like to thank \href{https://www.researchgate.net/profile/Mae-Nuijs}{Mae Nuys} and Maren Sera for spotting bugs in earlier versions of this package.
#' 
#' @importFrom dplyr %>% group_by group_modify summarize bind_rows
#' @importFrom stats cor sd var cov reshape
#' @importFrom psych ICC
#' @importFrom parallel detectCores makeCluster clusterExport clusterSetRNGStream stopCluster parLapply
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom bcaboot bcajack
#' @importFrom tibble is_tibble
#' @importFrom rlang .data
#' @docType package
#' @name splithalfr
NULL
