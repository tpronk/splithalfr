#' Example Implicit Association Task (IAT) Data in JASMIN2 Format
#'
#' The JASMIN2 IAT closely followed the original IAT procedure
#' (\doi{10.1037/0022-3514.74.6.1464}{Greenwald, McGhee, & Schwartz, 1998}),
#' except that target and attribute trials did not alternate.  Upon a correct response, the next trial started.
#' Upon an incorrect response, the current trial was repeated. The response to each trial was logged.
#' This particular dataset is from a Ethnicity-Valence IAT, which was administered (and described in detail) in 
#' \doi{10.1016/j.tate.2019.102887}{Abacioglu and colleagues (2019)}. 
#' This dataset was graciously provided by \href{https://www.uva.nl/en/profile/h/a/f.hanna/f.hanna.html}{Fadie Hanna} and \href{https://www.researchgate.net/profile/Marjolein-Zee-2}{Marjolein Zee}.
#' 
#' Overview of columns:
#' \itemize{
#'   \item participation_id Identifies participants
#'   \item t1_left. If TRUE, the first combination block had target 1 on the left (and target 2 on the right)
#'   \item a1_left. If TRUE, the first combination block had attribute 1 on the left (and attribute 2 on the right)
#'   \item block_type. Type of block
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item attempt. Counts attempts (responses) in trials, starting at zero
#'   \item cat. Category that stimulus belonged to
#'   \item stim. Stimulus
#'   \item response. Response; 1 = correct, 2 = incorrect, 3 = timeout (no response in 4000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds. Note that some response times may exceed the timeout window due to clock errors on the computer that the IAT was administered
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
#' The JASMIN1 VPT distinguished between "test" stimuli, which are in some way assumed to be salient to the participant
#' and "control" stimuli, which are not. Test and control stimuli were presented in pairs, with
#' one left and one right, followed by a probe that was an arrow pointing up or down. Participants needed
#' to indicate whether the arrow pointed up or down. Upon a correct response the next trial started and
#' upon an incorrect response the current trial was repeated. Only the first response to a new trial was logged.
#' This particular VPT was part of the pre-measurement
#' of a cognitive bias modification study. The "test" stimuli were alcoholic beverages and the "control" stimuli
#' were non-alcoholic beverages, selected from the Amsterdam Beverage Picture Set
#' \doi{10.1111/acer.12853}{(Pronk, Deursen, Beraha, Larsen, & Wiers, 2015)}.
#' The dataset contains one row per trial.
#' This dataset was graciously provided by \href{https://www.researchgate.net/profile/Marilisa-Boffo}{Marilisa Boffo}.
#' 
#' Overview of columns:
#' \itemize{
#'   \item UserID. Identifies participants
#'   \item patt. Probe-at-test. If "yes", the probe was positioned at the test stimulus. If "no", the probe was positioned at the control stimulus.
#'   \item phor. Probe horizontal position. Values: "left" or "right"
#'   \item thor. Test horizontal position. Values: "left" or "right"
#'   \item keep. If "yes" the probe was superimposed on the stimuli. If "no" the probe replaced the stimuli.
#'   \item pdir. Probe direction. Values: "up" or "down"
#'   \item stim. Stimulus
#'   \item response. Response; 1 = correct, 2 = incorrect, 3 and NA = timeout (no response in 5000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item block_type. Type of block: "assess" for assessment trials with salient stimuli
#' }
"ds_vpt"

#' Example Approach Avoidance Task (AAT) Measurement Data in JASMIN2 Format
#'
#' The JASMIN1 AAT was an irrelevant feature task, in which participants were instructed to
#' approach/avoid left/right rotated stimuli. This particular AAT was administered (and described in detail) in 
#' \doi{10.1111/add.14071}{Boffo et al., 2018}. Participants were presented stimuli from a "test"
#' category, which were gambling-related pictures, and from a "control" category, which were pictures unrelated
#' to gambling. It registered approach responses by participants pressing (and holding) the arrow down key,
#' while avoid responses were given via the arrow up key. Upon a response, the stimulus zoomed in or
#' out, until it disappeared from the screen. The first response to a stimulus was logged. 
#' The dataset contains one row per trial.
#' This dataset was graciously provided by \href{https://www.researchgate.net/profile/Eva-Schmitz}{Eva Schmitz}.
#' 
#' Overview of columns:
#' \itemize{
#'   \item UserID. Identifies participants
#'   \item approach_tilt. If "left", participants were instructed to approach left rotated stimuli. If "right", participants were instructed to approach right rotated stimuli.
#'   \item block_type. Type of block: "practice" for practice trials with neutral stimuli, "assess" for assessment trials with salient stimuli
#'   \item block. Counts blocks, starting at zero
#'   \item trial. Counts trials in blocks, starting at zero
#'   \item appr. If "yes", this trial was an approach trial. If "no", this trial was an avoid trial.
#'   \item tilt. Whether the stimulus was rotated to the "left" or to the "right"
#'   \item cat. Stimulus category: "practice", "test", or "control"
#'   \item stim. Stimulus ID
#'   \item response. Response; 1 = correct, 2 = incorrect, 3 = timeout (no response in 4000 ms), 4 = invalid key
#'   \item rt. Response time in milliseconds
#'   \item sust. Was approach or avoid response sustained until the stimulus was completely zoomed in or out?
#' }
"ds_aat"

#' Example 23-item Rutgers Alcohol Problem Inventory (RAPI) data
#'
#' The RAPI is a questionnaire which asks how often a participant experienced each of 23 alcohol-related
#' problems within the last year (\href{http://www.emcdda.europa.eu/html.cfm/index4200EN.html}{White & Labouvie, 1989}).
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

#' Example Go/No Go data
#'
#' The Go/No Go is a task in which participants respond to one set of stimuli, but withhold a response
#' to another set of stimuli. This particular dataset is from the first session of a study that is 
#' described in detail in \doi{10.1016/j.tate.2019.102887}{Hedge, Powell, and Sumner (2018)}. 
#' It was graciously provided by \href{https://www.researchgate.net/profile/Craig-Hedge}{Craig Hedge} and can
#' be obtained from \href{https://osf.io/cwzds}{https://osf.io/cwzds}.
#' 
#' Overview of columns:
#'
#' \itemize{
#'   \item block. Block number
#'   \item trial. Trial number
#'   \item stim. Stimuli set used in that block
#'   \item condition. 0 = go, 2 = no go
#'   \item response. Correct (1) or incorrect (0)
#'   \item rt. Reaction time (seconds)
#'   \item participant. Participant ID
#' }
"ds_gng"

#' Example Stop Signal Task data
#'
#' The Stop Signal Task is a task in which participants responded whether a stimulus was a square or a circle.
#' On 25% of trials the participant heard a tone that indicated that the participant should withhold their response.
#' This particular dataset is from the first session of a study that is 
#' described in detail in \doi{10.1016/j.tate.2019.102887}{Hedge, Powell, and Sumner (2018)}. 
#' It was graciously provided by \href{https://www.researchgate.net/profile/Craig-Hedge}{Craig Hedge} and can
#' be obtained from \href{https://osf.io/cwzds}{https://osf.io/cwzds}.
#' 
#' Overview of columns:
#'
#' \itemize{
#'   \item block. Block number
#'   \item trial. Trial number
#'   \item ssd. Stop signal delay
#'   \item condition. 0 = go, 1 = stop
#'   \item response. Correct (1) or incorrect (0)
#'   \item rt. Reaction time (milliseconds)
#'   \item participant. Participant ID
#' }
"ds_sst"
