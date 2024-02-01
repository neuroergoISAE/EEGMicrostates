%% main.m 
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script in the main file for the microstates analysis
% Dependencies : EEGlab, Signal Processin Toolbox, Statistics and Machine Learning Toolbox, customcolormap
% Inputs : raw data folder must contain subjects eeg data in BIDS format
% Outputs: statistics for the microstates and files throughout the process, settings are saved as 's.mat' file

function main()
%% Description 
% Main file for the Microstates extraction process
% Analysed data must have been pre-processed 
% Epoching available on the trigger of interest (eyes opened or eyes closed for example)

%% Path
try
    addpath([matlabroot,'\toolbox\signal']); % 'Signal' toolbox must be added to the path
catch
    disp('Warning : Signal Processing Toolbox is missing');
end

try
        addpath([matlabroot,'\toolbox\stats']); % 'Statistics and Machine Learning' toolbox must be added to the path
catch
    disp('Warning : Statistics Toolbox is missing'); 
end

addpath('settings');
addpath('functions');

%% GUI
s.todo.paramgui = true; % Flag indicating whether to display a parameter GUI
s.todo.override = true; % Flag indicating whether to override old outputs

%analysis steps 
s.todo.load_data = true; % Flag indicating whether to load data
s.todo.microstates_gfppeaks = true; % Flag indicating whether to perform GFP peaks analysis
s.todo.microstates_segmentation = true; % Flag indicating whether to perform microstates segmentation
s.todo.microstates_reordering = true; % Flag indicating whether to perform microstates reordering
s.todo.microstates_backfitting = true; % Flag indicating whether to perform microstates backfitting
s.todo.microstates_stats = true; % Flag indicating whether to perform microstates statistics

%% Settings
s = p00_settings(s);

%% Anlaysis
p01_load_data(s); % load data, move and rename eeg_data file in the gfp directory for easier use. If required: extract eye closed epochs
p02_gfp_peaks(s);% Perform GFP Peaks analysis
p03_microstates_segmentation(s); % Perform microstates segmentation
p04_microstates_reordering(s); % ask reordering to user for the last level and reorder sub levels. OR : reorder based on template
p05_microstates_backfitting(s);% Perform microstates backfitting
p06_microstates_stats(s);% Compute microstates statistics

save('settings/s','s'); % Save the 's' structure variable to a file for future use
end

