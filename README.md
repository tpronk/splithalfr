# splithalfr: Split-Half Reliabilities
[![CRANVersion](https://www.r-pkg.org/badges/version/splithalfr)](https://cran.r-project.org/package=splithalfr)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Downloads](https://cranlogs.r-pkg.org/badges/splithalfr)](https://cran.r-project.org/package=splithalfr)
[![License: LGPL v3](https://img.shields.io/badge/license-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7777894.svg)](https://doi.org/10.5281/zenodo.7777894)

Estimates split-half reliabilities for scoring algorithms of cognitive tasks and questionnaires. The 'splithalfr' supports researcher-provided scoring algorithms, with six vignettes illustrating how on included datasets. The package provides four splitting methods (first-second, odd-even, permutated, Monte Carlo), the option to stratify splits by task design, a number of reliability coefficients, the option to sub-sample data, and bootstrapped confidence intervals.

# Installation
* The latest release is on CRAN at https://cran.r-project.org/package=splithalfr. Install it by running `install.packages("splithalfr")`
* Releases are also archived at Zenodo under the DOI [10.5281/zenodo.7777894](https://doi.org/10.5281/zenodo.7777894)
* The latest development version is available via this repo at [https://github.com/tpronk/splithalfr](https://github.com/tpronk/splithalfr). Beware: this version may contain errors and can change at any time.

# Getting started
We've got six short vignettes to help you get started. You can open a vignette bij running the corresponding code snippet `vignette(...)` in the R console or see them online at [rdrr.io](https://rdrr.io/cran/splithalfr/#vignettes)

* `vignette("rapi_sum")` Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index ([White & Labouvie, 1989](https://doi.org/10.15288/jsa.1989.50.30))
* `vignette("vpt_diff_of_means")` Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data ([Mogg & Bradley, 1999](https://doi.org/10.1080/026999399379050))
* `vignette("aat_double_diff_of_medians")` Double difference of medians for correct responses on Approach Avoidance Task data ([Heuer, Rinck, & Becker, 2007](https://doi.org/10.1016/j.brat.2007.08.010))
* `vignette("iat_dscore_ri")` Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial ([Greenwald, Nosek, & Banaji, 2003](https://pubmed.ncbi.nlm.nih.gov/12916565/))
* `vignette("sst_ssrti")` Stop-Signal Reaction Time integration method for data of a Stop Signal Task ([Logan, 1981](http://www.psy.vanderbilt.edu/faculty/logan/Logan(1981).pdf))
* `vignette("gng_dprime")` D-prime for data of a Go/No Go task ([Miller, 1996](https://doi.org/10.3758/BF03205476))

# Splitting Methods
The splithalfr supports a variety of methods for splitting your data. We review and assess each  method in the compendium paper ([Pronk et al., 2021](https://doi.org/10.3758/s13423-021-01948-3)), but based on more recent concerning findings with Monte Carlo splitting ([Kahveci et al., 2025](https://doi.org/10.3758/s13423-024-02597-y); [Pronk et al., 2023](https://doi.org/10.3758/s13428-022-01885-6)), I now only recommend permutated splitting and not Monte Carlo splitting. This vignette illustrates how to apply each splitting method via the splithalfr: `vignette("splitting_methods")` 
* first-second and odd-even ([Green et al., 2016](https://doi.org/10.3758/s13423-015-0968-3); [Webb, Shavelson, & Haertel, 1996](https://doi.org/10.1016/S0169-7161(06)26004-8); [Williams & Kaufmann, 1996](https://doi.org/10.1016/j.jesp.2012.03.001))
* stratified ([Green et al., 2016](https://doi.org/10.3758/s13423-015-0968-3))
* permutated/bootstrapped/random sample of split halves ([Kopp, Lange, & Steinke, 2021](https://doi.org/10.1177/1073191119866257), [Parsons, Kruijt, & Fox, 2019](https://doi.org/10.1177/2515245919879695); [Williams & Kaufmann, 2012](https://doi.org/10.1016/j.jesp.2012.03.001))
* Monte Carlo ([Williams & Kaufmann, 2012](https://doi.org/10.1016/j.jesp.2012.03.001))

# Citing the splithalfr
Please cite the compendium paper ([Pronk et al., 2022](https://doi.org/10.3758/s13423-021-01948-3)) and the software. To cite the software, see the [CITATION.cff](https://github.com/tpronk/splithalfr/blob/main/CITATION.cff) file, type `citation("splithalfr")` in R, or use the reference below.

Pronk, T. (2025). *splithalfr: Estimates split-half reliabilities for scoring algorithms of cognitive tasks and questionnaires* (Version 3.0.0) [Computer software]. https://doi.org/10.5281/zenodo.7777894

# Validation of split-half estimations
Part of the splithalfr algorithm has been validated via a set of simulations that are not included in this package. The R script for these simulations can be found [here](https://github.com/tpronk/splithalfr_simulation).

# Related packages
These R packages offer resampling-based split-half reliabilities for specific scoring algorithms and are available via CRAN at the time of this writing: [multicon](https://cran.r-project.org/package=multicon), [psych](https://cran.r-project.org/package=psych), [splithalf](https://cran.r-project.org/package=splithalf), and [rapidsplithalf](https://cran.r-project.org/package=rapidsplithalf). If I missed one, please reach out!

# Acknowledgments
I would like to thank Craig Hedge, Eva Schmitz, Fadie Hanna, Helle Larsen, Marilisa Boffo, and Marjolein Zee, for making datasets available for inclusion in the splithalfr. Additionally, I would like to thank Craig Hedge and Benedict Williams for sharing R-scripts with scoring algorithms that were adapted for splithalfr vignettes. Finally, I would like to thank Mae Nuijs and Sera-Maren Wiechert for spotting bugs in earlier versions of this package.

# Developer guide
Be welcome to modify the source code! If you do, keep the following in mind:
* Please follow the [Google R Style Guide](https://google.github.io/styleguide/Rguide.html).
* Please add some automated unit tests of your code using [testthat](https://testthat.r-lib.org/). Add them to `tests/testthat`
* If you've got manual tests of your code, add them to `tests/`
