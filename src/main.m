function main(s)
%vCH
%% Description
% Main file for the Microstates extraction process
% input: settings folder 


%Analysed data must have been pre-processed and epoched on the trigger of
%interest (eyes opened or eyes closed for example)

%% Settings
addpath('settings');
addpath('functions');
load('s.mat','s');
s = p00_settings(s);

%% Required Steps
% Override old outputs?
s.todo.override = true;
%analysis steps 
s.todo.eyes_epoching = false;
s.todo.load_data                        = true; % Two options : already epoched on closed eyes or epoching needs to be done
s.todo.microstates_gfppeaks             = true; 
s.todo.microstates_segmentation         = true; 
s.todo.microstates_reorderProto         = true;
s.todo.microstates_backfitting          = true;
s.todo.features_to_csv                  = true;

%% Anlaysis

p01_load_data(s); % load data, move and rename eeg_data file in the gfp directory for easier use. If required: extract eye closed epochs
p02_gfp_peaks(s);
p03_microstates_segmentation(s);


end

