# EEGMicrostates :brain:
**Multiple levels Microstates Analysis for EEG data** 


## Requirements

- [ ] **eeglab** (2023 is better) 
    - [ ] Microstates Analysis Toolbox : Microstates1.2 (Thomas Koenig) [download](https://www.thomaskoenig.ch/Download/EEGLAB_Microstates/Microstates1.2.zip)
    - [ ] Microstates EEGlab Toolbox : MST1.0 (Poulsen et al., 2018) [github](https://github.com/atpoulsen/Microstate-EEGlab-toolbox)
- [ ] **Matlab** (>= 2019a)
    - [ ] Signal Processing Toolbox (signal)
    - [ ] Statistics and Machine Learning Toolbox (stats)
    - [ ] custom colormap (should be located in the external files folder, or change path in p00_settings.m)

## Process
Open ```main.m``` file.

The ```paramGUI``` variable (default : *true*) permits the opening of a small GUI asking for required path and parameters. If you wish, you can put this variable to *false* and change the parameters by hand in the ```p00_settings.m``` file.

You can change the required steps and skip unwanted one by changing the corresponding variable ```settings.todo.var``` with ```false```

**Run** ```main.m```, if the GUI parameter is true, please fill it and press ```Save Parameters```.

The Microstates Analysis will launch. Wait until the process ask you to reoder the microstates prototypes. When finished, the message ```Microstates Analysis Finished``` will appear in the Command Window.

## :U+1F4AC: Help
For help, you can contact us at : caroline.hamery@isae-supaero.fr or post a new issue.
