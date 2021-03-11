#' splithalfr: Split-Half Reliabilities
#'
#' Estimates split-half reliabilities for scoring algorithms of reaction time (RT) tasks and questionnaires. 
#' 
#' @section Getting started:
#' We've got six short vignettes to help you get started. You can open a vignette bij running the corresponding code snippets (\code{vignette(...)}) in the R console.
#' \itemize{
#'   \item \code{vignette("rapi_sum")} Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index (\href{http://www.emcdda.europa.eu/html.cfm/index4200EN.html}{White & Labouvie, 1989})
#'   \item \code{vignette("vpt_diff_of_means")} Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data (\href{https://doi.org/10.1080/026999399379050}{Mogg & Bradley, 1999})
#'   \item \code{vignette("aat_double_diff_of_medians")} Double difference of medians for correct responses on Approach Avoidance Task data (\href{http://doi.org/10.1016/j.brat.2007.08.010}{Heuer, Rinck, & Becker, 2007})
#'   \item \code{vignette("iat_dscore_ri")} Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial (\href{http://dx.doi.org/10.1037/0022-3514.85.2.197}{Greenwald, Nosek, & Banaji, 2003})
#'   \item \code{vignette("sst_ssrti")} Stop-Signal Reaction Time integration method for data of a Stop Signal Task (\href{http://www.psy.vanderbilt.edu/faculty/logan/Logan(1981).pdf}{Logan, 1981})
#'   \item \code{vignette("gng_dprime")} D-prime for data of a Go/No Go task (\href{https://doi.org/10.3758/BF03205476}{Miller, 1996})
#' }
#' 
#' @section Splitting methods:
#' The splithalfr supports a variety of methods for splitting your data. We review and assess each  method in the compendium paper, currently in pre-print (\href{https://doi.org/10.31234/osf.io/ywste}{Pronk, Molenaar, Wiers, & Murre, 2020}). This vignette illustrates how to apply each splitting method via the splithalfr: \code{vignette("splitting_methods")}
#' \itemize{
#'   \item first-second and odd-even (\href{https://doi.org/10.3758/s13423-015-0968-3}{Green et al., 2016}; \href{https://doi.org/10.1016/S0169-7161(06)26004-8}{Webb, Shavelson, & Haertel, 1996}; \href{https://doi.org/10.1016/j.jesp.2012.03.001}{Williams & Kaufmann, 1996})
#'   \item stratified ((\href{https://doi.org/10.3758/s13423-015-0968-3}{Green et al., 2016})
#'   \item permutated/bootstrapped/random sample of split halves (\href{https://doi.org/10.1177/1073191119866257}{Kopp, Lange, & Steinke, 2021}, \href{https://doi.org/10.1177/2515245919879695}{Parsons, Kruijt, & Fox, 2019}; \href{https://doi.org/10.1016/j.jesp.2012.03.001}{Williams & Kaufmann, 1996})
#'   \item Monte Carlo (\href{https://doi.org/10.1016/j.jesp.2012.03.001}{Williams & Kaufmann, 1996})
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
#' \href{https://www.researchgate.net/profile/Craig_Hedge}{Craig Hedge},
#' \href{https://www.researchgate.net/profile/Eva_Schmitz4}{Eva Schmitz},
#' \href{https://www.uva.nl/en/profile/h/a/f.hanna/f.hanna.html}{Fadie Hanna},
#' \href{https://scholar.google.com/citations?user=ugPnkjEAAAAJ&hl=en}{Helle Larsen},
#' \href{https://www.researchgate.net/profile/Marilisa_Boffo}{Marilisa Boffo}, and
#' \href{https://www.researchgate.net/profile/Marjolein_Zee}{Marjolein Zee}
#' for making datasets available for inclusion in the splithalfr.
#' Additionally, I would like to thank 
#' \href{https://www.researchgate.net/profile/Craig_Hedge}{Craig Hedge} and 
#' \href{http://www.swinburne.edu.au/health-arts-design/staff/profile/index.php?id=bwilliams}{Benedict Williams}
#' for sharing R-scripts with scoring algorithms that were adapted for splithalfr vignettes.
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
