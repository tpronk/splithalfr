# splithalfr: Split-Half Reliabilities
Estimates split-half reliabilities for scoring algorithms of reaction time (RT) tasks and questionnaires. 

## Getting started
We've got six short vignettes to help you get started. You can open a vignette bij running the corresponding code snippets `vignette(...)` in the R console.

* `vignette("rapi_sum")` Sum-score for data of the 23-item version of the Rutgers Alcohol Problem Index ([White & Labouvie, 1989](http://www.emcdda.europa.eu/html.cfm/index4200EN.html))
* `vignette("vpt_diff_of_means")` Difference of mean RTs for correct responses, after removing RTs below 200 ms and above 520 ms, on Visual Probe Task data ([Mogg & Bradley, 1999](https://doi.org/10.1080/026999399379050))
* `vignette("aat_double_diff_of_medians")` Double difference of medians for correct responses on Approach Avoidance Task data ([Heuer, Rinck, & Becker, 2007](https://doi.org/10.1016/j.brat.2007.08.010))
* `vignette("iat_dscore_ri")` Improved d-score algorithm for data of an Implicit Association Task that requires a correct response in order to continue to the next trial ([Greenwald, Nosek, & Banaji, 2003](https://doi.org/10.1037/0022-3514.85.2.197))
* `vignette("sst_ssrti")` Stop-Signal Reaction Time integration method for data of a Stop Signal Task ([Logan, 1981](http://www.psy.vanderbilt.edu/faculty/logan/Logan(1981).pdf))
* `vignette("gng_dprime")` D-prime for data of a Go/No Go task ([Miller, 1996](https://doi.org/10.3758/BF03205476))

## Splitting Methods
The splithalfr supports a variety of methods for splitting your data. We review and assess each  method in the compendium paper, currently in pre-print ([Pronk, Molenaar, Wiers, & Murre, 2020](https://doi.org/10.31234/osf.io/ywste)). This vignette illustrates how to apply each splitting method via the splithalfr: `vignette("splitting_methods")` 
* first-second and odd-even ([Green et al., 2016](https://doi.org/10.3758/s13423-015-0968-3); [Webb, Shavelson, & Haertel, 1996](https://doi.org/10.1016/S0169-7161(06)26004-8); [Williams & Kaufmann, 1996](https://doi.org/10.1016/j.jesp.2012.03.001))
* stratified ([Green et al., 2016](https://doi.org/10.3758/s13423-015-0968-3))
* permutated/bootstrapped/random sample of split halves ([Kopp, Lange, & Steinke, 2021](https://doi.org/10.1177/1073191119866257), [Parsons, Kruijt, & Fox, 2019](https://doi.org/10.1177/2515245919879695); [Williams & Kaufmann, 1996](https://doi.org/10.1016/j.jesp.2012.03.001))
* Monte Carlo ([Williams & Kaufmann, 1996](https://doi.org/10.1016/j.jesp.2012.03.001))

## Validation of split-half estimations
Part of the splithalfr algorithm has been validated via a set of simulations that are not included in this package. The R script for these simulations can be found [here](https://github.com/tpronk/splithalfr_simulation).

## Related packages
These R packages offer bootstrapped split-half reliabilities for specific scoring algorithms and are available via CRAN at the time of this writing:  [multicon](https://cran.r-project.org/package=multicon), [psych](https://cran.r-project.org/package=psych), and [splithalf](https://cran.r-project.org/package=splithalf).

## Acknowledgments:
I would like to thank [Craig Hedge](https://www.researchgate.net/profile/Craig-Hedge), [Eva Schmitz](https://www.researchgate.net/profile/Eva-Schmitz), [Fadie Hanna](https://www.uva.nl/en/profile/h/a/f.hanna/f.hanna.html), [Helle Larsen](https://scholar.google.com/citations?user=ugPnkjEAAAAJ&hl=en), [Marilisa Boffo](https://www.researchgate.net/profile/Marilisa-Boffo), and [Marjolein Zee](https://www.researchgate.net/profile/Marjolein-Zee-2), for making datasets available for inclusion in the splithalfr. Additionally, I would like to thank [Craig Hedge](https://www.researchgate.net/profile/Craig-Hedge) and [Benedict Williams](https://www.swinburne.edu.au/research/our-research/access-our-research/find-a-researcher-or-supervisor/researcher-profile/?id=bwilliams}{Benedict Williams) for sharing R-scripts with scoring algorithms that were adapted for splithalfr vignettes.

## Version History
* **v2.1** Added option to subsample participants before splitting via `subsample_n` argument to `by_split`
* **v2.0** Remodeled to look like R's native `split`
* **v1.0** First stable release