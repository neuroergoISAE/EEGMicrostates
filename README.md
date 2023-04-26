# EEGMicrostates :brain:
**Multiple levels Microstates Analysis for EEG data** 

## :toolbox: Requirements

- [ ] **Matlab** (>= 2019a)
    - [ ] Signal Processing Toolbox (signal)
    - [ ] Statistics and Machine Learning Toolbox (stats)
    - [ ] custom colormap (should be located in the external files folder, or change path in p00_settings.m)
- [ ] **eeglab** (2023 is better) 
    - [ ] Microstates Analysis Toolbox : Microstates1.2 (Thomas Koenig) [download](https://www.thomaskoenig.ch/Download/EEGLAB_Microstates/Microstates1.2.zip)
    - [ ] Microstates EEGlab Toolbox : MST1.0 (Poulsen et al., 2018) [github](https://github.com/atpoulsen/Microstate-EEGlab-toolbox)
## :jigsaw: Description

The multiple levels microstates analysis will extract microstates on available levels (session if existing, participant and group) and then backfit the original data on the microstates prototypes of the requested levels. The backfitting is by default done on the group level. Other levels backfitting can be added by selecting them in the backfit section of the GUI or by changing the parameters in the ```p00_setting.m``` file.

### :hourglass_flowing_sand: Process
- ```p00_settings.m``` : parameters selection with or without GUI, a previous setting file can be loaded.
- ```p01_load_data.m``` : loads the data to analyis. If required, can epoch the data to analyse (closed or opened eyes for example).
- ```p002_gfp_peaks.m``` : extracts gfp peaks of each file of the first level (session or participant) and save them in the ```gfp``` folder
- ```p003_microstates_segmentation.m``` : performs the segmentation (in our case, the **modified k-means clustering**) on each existing level and save the prototypes in the corresponding folders (```session``` if existing, ```participant``` and ```group```).
- ```p004_microstates_reordering.m``` : asks the user to input the right order of the last level (group) prototypes. Reording of all the other levels prototypes according to the group prototypes order.
- ```p005_microstates_backfitting.m``` : performs the backfitting on the requested levels. The default backfitting level is on the group prototypes. Other can be added as an option. Results are saved in the ```backfitting``` folder. 
- ```p006_microstates_stats.m``` : extracts the statistics of the backfitted microstates for each level and save them in .csv and .mat files in the ```stats``` folder.

## :airplane: Launch
Open ```main.m``` file.

The ```paramGUI``` variable (default : *true*) permits the opening of a small GUI asking for required path and parameters. If you wish, you can put this variable to *false* and change the parameters by hand in the ```p00_settings.m``` file.

You can change the required steps and skip unwanted one by changing the corresponding variable ```settings.todo.var``` with ```false```

**Run** ```main.m```, if the GUI parameter is true, please fill it and press ```Save Parameters```.

The Microstates Analysis will launch. Wait until the process ask you to reoder the microstates prototypes. When finished, the message ```Microstates Analysis Finished``` will appear in the Command Window.

## :floppy_disk: Output 

## :compass: Short glossary

- microstates: Topographical results of n cluster segmentation on the gfp peaks. Commonly, 4 clusters are extracted
- prototypes : microstate clusters defined for a group, a participant or a session. Used as the reference for the backfitting procedure
- levels : each step when an eeg recording was done.
- session level : experimental protocol includes multiple sessions for each participant. Please note: same session for each participant. If participant perform a single session, the session level will not exist.
- participant level : each individual (subject, patient or participant) included in the experiment.
- group level : all the existing participants and sessions, always single group for the global population.
- segmentation : clustering process, in our case : modified k-means cluster. The number of clusters is 4 by default but can be changed. A list of cluster number can also be included (will increase the number of output and time of procedure).

## :microscope: Details 

| **Parameter** | **Type**    | **Description**    | **Default** |
| :-----: | :---: | :---: | :---:|
| s.name | string   | global project folder name   | "" | 
|s.multipleSessions	|boolean	|Do the data include multiple sessions per participant|	false|


##  :crystal_ball: Help
For help, you can contact us at : :envelope: caroline.hamery@isae-supaero.fr or post a new issue.
