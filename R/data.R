#' Example Implicit Association Task (IAT) Data in JASMIN2 Format
#'
#' The JASMIN2 IAT closely follows the original IAT procedure
#' (\href{https://dx.doi.org/10.1037/0022-3514.74.6.1464}{Greenwald, McGhee, & Schwartz, 1998}),
#' except that target and attribute trials do not alternate.  Upon a correct response, the next trial starts.
#' Upon an incorrect response, the current trial is repeated. The response to each trial is logged.
#' This particular dataset is from a Drinker Identity IAT
#' (\href{https://dx.doi.org/10.1037/a0027640}{Lindgren et al., 2013})
#' that was used in a cross-cultural study. Drinker was target 1, non-drinker was target 2, me was attribute 1, and not-me was attribute 2.
#' The dataset contains one row per trial.
#' This dataset was graciously provided by \href{https://scholar.google.com/citations?user=ugPnkjEAAAAJ&hl=en}{Helle Larsen}.
#'
#' Overview of columns:
#'
#' \itemize{
#'   \item UserID. Identifies participants
#'   \item t1_left. If TRUE, the first combination block had target 1 on the left (and target 2 on the right)
#'   \item a1_left. If TRUE, the first combination block had attribute 1 on the left (and attribute 2 on the right)
#'   \item cat. Category that stimulus belonged to
#'   \item stim. Stimulus
#'   \item response. Response; 1 = correct, 2 = incorrect, 3 = timeout (no response in 4000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds. Note that some response times may exceed the timeout window due to clock errors on the computer that the IAT was administered
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item attempt. Counts attempts (responses) in trials, starting at zero
#'   \item block_type. Type of block
#' }
#' The variable block_type can have these values:
#' \itemize{
#'   \item tar_discr: target discrimination
#'   \item att_discr: attribute discrimination
#'   \item tar1att1_1: target 1 with attitude 1, practice block
#'   \item tar1att1_2: target 1 with attitude 1, test block
#'   \item tar_rev: reverse target discrimination
#'   \item tar1att2_1: target 1 with attitude 2, practice block
#'   \item tar1att2_2: target 1 with attitude 2, test block
#' }
"ds_iat"

#' Example Visual Probe Task (VPT) Measurement Data in JASMIN1 Format
#'
#' The JASMIN1 VPT distinguishes between "test" stimuli, which are in some way assumed to be salient to the participant
#' and "control" stimuli, which are not. Test and control stimuli are  presented in pairs, with
#' one left and one right, followed by a probe that is an arrow pointing up or down. Participants need
#' to indicate whether the arrow points up or down. Upon a correct response the next trial starts and
#' upon an incorrect response the current trial is repeated. Only the first response of each trial is logged.
#' This particular VPT was part of the pre-measurement
#' of a cognitive bias modification study. The "test" stimuli were alcoholic beverages and the "control" stimuli
#' were non-alcoholic beverages, selected from the Amsterdam Beverage Picture Set
#' \href{https://doi.org/10.1111/acer.12853}{(Pronk, Deursen, Beraha, Larsen, & Wiers, 2015)}.
#' The dataset contains one row per trial.
#' This dataset was graciously provided by \href{https://www.researchgate.net/profile/Marilisa_Boffo}{Marilisa Boffo}.
#'
#' \itemize{
#'   \item UserID. Identifies participants
#'   \item patt. Probe-at-test. If "yes", the probe was positioned at the test stimulus. If "no", the probe was positioned at the control stimulus.
#'   \item phor. Probe horizontal position. Values: "left" or "right"
#'   \item thor. Test horizontal position. Values: "left" or "right"
#'   \item keep. If "yes" the probe was superimposed on the stimuli. If "no" the probe replaced the stimuli.
#'   \item pdir. Probe direction. Values: "up" or "down"
#'   \item stim. Stimulus
#'   \item response. Response; 1 = correct, 2 = incorrect, 3 = timeout (no response in 5000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item block_type. Type of block: "assess" for assessment trials with salient stimuli
#' }
"ds_vpt"

#' Example Approach Avoidance Task (AAT) Measurement Data in JASMIN2 Format
#'
#' The JASMIN2 AAT is an irrelevant feature task, in which participants were instructed to
#' approach/avoid left/right rotated stimuli. This particular AAT presented stimuli from a "test"
#' category, which were math-related pictures, and from a "control" category, which were pictures unrelated
#' to math. It registered approach responses by participants pressing (and holding) the arrow down key,
#' while avoid responses were given via the arrow up key. Upon a response, the stimulus zoomed in or
#' out, until it disappeared from the screen. The first response to a stimulus is logged, as well as the final
#' response, as defined by the stimulus completely zooming in or out. Upon a correct final response
#' the next trial starts and upon an incorrect final response the current trial is repeated. The first and final
#' response to each trial is logged. The dataset contains one row per trial.
#' This dataset was graciously provided by \href{https://www.researchgate.net/profile/Eva_Schmitz4}{Eva Schmitz}.
#'
#' \itemize{
#'   \item UserID. Identifies participants
#'   \item approach_left. If TRUE, participants were instructed to approach left rotated stimuli. If FALSE, participants were instructed to approach right rotated stimuli.
#'   \item trial_type. Values: "approach" or "avoid"
#'   \item cat. Stimulus category: practice, test, or control
#'   \item stim. Stimulus
#'   \item response. Initial response; 1 = correct, 2 = incorrect, 3 = timeout (no response in 4000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds
#'   \item sust. Was approach or avoid response sustained until the stimulus was completely zoomed in or out?
#'   \item final_response. Final response; the response that ended the current trial. Possible values are the same as for response
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item attempt. Counts attempts (responses) in trials, starting at zero
#'   \item block_type. Type of block: "assess1" and "assess2" for assessment trials with salient stimuli
#' }
"ds_aat"

#' Example 23-item Rutgers Alcohol Problem Inventory (RAPI) data
#'
#' The RAPI is a questionnaire which asks how often a participant experienced each of 23 alcohol-related
#' problems within the last year (\href{https://research.alcoholstudies.rutgers.edu/rapi}{White & Labouvie, 1989}).
#' The dataset contains one row per participant.
#' 
#' The dataset contains the following columns:
#' \itemize{
#'   \item twnr. Identifies participants
#'   \item V1 to V23. Answers on each of the 23 RAPI items
#' }
#'
#' Each item is answered on a four-point scale with the following answer options:
#' \itemize{
#'   \item 0 = None
#'   \item 1 = 1-2 times
#'   \item 2 = 3-5
#'   \item 3 = More than 5 times
#' }
"ds_rapi"



