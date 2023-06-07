# EEGMicrostates :brain:
**Multiple levels Microstates Analysis for EEG data** 

Adapted from Christian Pfeiffer ([repository](https://github.com/cp3fr/Resting-State-EEG-Features)) and Moritz Truninger
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
If the data folder is placed in the global project folder and you want all the results to save in the same folder as your data folder, just write your data folder's name in the "Project Name" input field of the GUI.

You can change the required steps and skip unwanted one by changing the corresponding variable ```settings.todo.var``` with ```false```

**Run** ```main.m```, if the GUI parameter is true, please fill it and press ```Save Parameters```.

The Microstates Analysis will launch. Wait until the process ask you to reoder the microstates prototypes. When finished, the message ```Microstates Analysis Finished``` will appear in the Command Window.

## :floppy_disk: Output 

![Documentation Image](external_files/DocMicrostates.JPG)

## :compass: Short glossary

- microstates: Topographical results of n cluster segmentation on the gfp peaks. Commonly, 4 clusters are extracted
- prototypes : microstate clusters defined for a group, a participant or a session. Used as the reference for the backfitting procedure
- levels : each step when an eeg recording was done.
- session level : experimental protocol includes multiple sessions for each participant. Please note: same session for each participant. If participant perform a single session, the session level will not exist.
- participant level : each individual (subject, patient or participant) included in the experiment.
- group level : all the existing participants and sessions, always single group for the global population.
- segmentation : clustering process, in our case : modified k-means cluster. The number of clusters is 4 by default but can be changed. A list of cluster number can also be included (will increase the number of output and time of procedure).
- In case of single sessions but mulitple conditions analysis: conditions can be considered as sessions

## :microscope: Details 
Parameters settings : 

| **Parameter** | **Type**    | **Description**    | **Default** |
| ---- | --- | ------ | --- |
| s.name | string   | global project folder name   | "" | 
| s.multipleSessions	| boolean	| Do the data include multiple sessions per participant |	false |
| s.levels | array of string each segmentation possibility (session, participant, group)	| {’participant’,’group’} if multiple Sessions : {’session’,’participant’,’group’} |
| s.sr |	double |	sample rate (Hz)	| 500 | 
| s.nGoodSamples	| double	| minimum number of good samples after excluding bad epochs |	1000 | 
| **s.path** |    |   | |		
| s.path.datatoepoch | 	string	| data to epoched folder (if required) | ""	 |
| s.path.data | 	string	| preprocessed and epoched data folder	| “” |
| s.path.globalpath	| string	| global project path 	| .\pwd |
| s.path.src	| string	| source folder, including functions and settings	| “” |
| s.path.results	| string	| results folder, will include sub folders for each step of the processing	| “” |
| s.path.tables	| string	| tables folder, microstates statistics of all data results in .mat files	| “” |
| s.path.csv	| string	| csv folder, microstates statistics results of all data in .csv files	| “” |
| s.path.session	| string	| session folder, segmentation results and plots for the session level	| “” |
| s.path.participant	| string	| participant folder, segmentation results and plots for the participant level	| “” |
| s.path.group	| string	| group folder, segmentation results and plots for the group level	| “” |
| s.path.gfp	| string	| gfp folder, gfp results and plots for each data	| “” |
| s.path.backfitting	| string	| backfitting folder, backfitting results for each level	| “” |
| s.path.functions	| string	| functions folder, all function required for the analysis	| “” |
| s.path.microstates	| string	| microstates toolbox : MST1.0 location	| “” |
| s.path.microstatesKoenig	| string	| T. Koenig’s microstates toolbox : Microstates1.2 location	| “” |
| s.path.eeglab	| string	| eeglab location	|  “” | 
| s.path.colormap	| string	| customcolormap | location	| “” | 
| **s.customColorMap**	| 	| | | 	
| s.customColorMap.colors	| char	| colors used for the microstates plots	| 'red-white-blue’ | 
| s.customColorMap.range	| double	| range used for the microstates plots	| [-0.25 0.25] | 
| **s.microstate**	| | | |  		
| s.microstate.algorithm	| char	| algorithm used for the microstates segmentation process | ‘modkmeans’ |  
| s.microstate.sorting	| char	| Order based on GEV (first MS is the one explaining the most variance)	| 'Global explained variance’ |
| s.microstate.normalise	| double	| | 0 |
| s.microstate.Nmicrostates	| double	| Range of numbers of clusters	| 4 (for multiple ms clusters analysis : [n:m] |
| s.microstate.verbose	| double	| Print status messages to command window	| 1 |
| s.microstate.Nrepetitions_FistLevel | double	| Number of random initialization of algorithm when applied on already clustered data	| 100 |
| s.microstate.Nrepetitions_OtherLevels	| double	| Number of random initialization of algorithm when applied on gfp data (first level segmentation)	| 1000 |
| s.microstate.fitmeans	| char	| Reading measure of fit for selecting best segmentation	‘CV’ |
| s.microstate.max_iterations	| double	| Maximal number of iteration for the segmentation process	| 1000 |
| s.microstate.threshold	| double	| Threshold of convergence based on relative change in noise variance	| 0.000001 |
| s.microstate.optimised	| double	| Use the new and optimized segmentation introduced	| 1 |
| s.microstate.orderingPolarity	| double	| in ArrangMapsBasedOnMean: respect polarity or not	| 0 |
| s.microstate.stats	| array of char	| parameters to include in the final microstates statistical analysis | |

**Default Stats output** : 
- GEVtotal : Global explained variance of the n Microstates  
- Gfp : Global field potential
- Occurence : number of time each microstate appears over the epoch
- Duration : mean duration of each microstate at each occurence
- Coverage : total duration of each microstate over the epoch
- GEV : Global Explained Variance of each microstate
- MspatCorr : Microstate Spatial Correlation 

**Segmentation methods** :
- ‘modkmeans’ Mofidied K-means 
- ‘kmeans‘ Ordinary K-means - ‘varmicro’ Variational microstates 
- ‘taahc’ Topograhpical Atomize and Agglormerate Hierarchical Clustering 
- ‘aahc’ Atomize and Agglomerate Hierarchical Clustering 

![Microstates pipeline](external_files/MSPipeline.png)
![Processes Pipelines](external_files/Pipelines.png)

##  :crystal_ball: Help
For help, you can contact us at : :envelope: caroline.hamery@isae-supaero.fr or post a new issue.
