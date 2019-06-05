# splithalfr: Extensible Bootstrapped Split-Half Reliabilities
Calculates scores and and estimates bootstrapped split-half reliabilities for reaction time (RT) tasks and questionnaires. The splithalfr can be extended with custom scoring algorithms for user-provided datasets.

## Included Vignettes
The splithalfr vignettes demonstrate how to write a custom scoring algorithm based on included example scoring algorithms and datasets:
* `vignette("rapi_sum")` Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index ([White & Labouvie, 1989](https://research.alcoholstudies.rutgers.edu/rapi))
* `vignette("vpt_diff_of_means")` Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data ([Mogg & Bradley, 1999](https://doi.org/10.1080/026999399379050))
* `vignette("aat_double_diff_of_medians")` Double difference of medians for correct responses on Approach Avoidance Task data ([Heuer, Rinck, & Becker, 2007](http://doi.org/10.1016/j.brat.2007.08.010))
* `vignette("iat_dscore_ri")` Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial ([Greenwald, Nosek, & Banaji, 2003](http://dx.doi.org/10.1037/0022-3514.85.2.197))

## Tests
The R script included in each vignette is validated by comparing the splithalfr score for a single participant with the same score calculated via Excel. The materials for each test can be found in the tests directory.

## Simulations
The splithalfr splitting algorithm has been validated via a set of simulations which are not included in this package. The R script
for these simulations can be found [here](https://github.com/tpronk/splithalfr_simulation).
