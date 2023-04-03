%% Main
function main(settings)
%% Description
% Main file for the Microstates extraction process
% input: settings folder 


%Analysed data must have been pre-processed and epoched on the trigger of
%interest (eyes opened or eyes closed for example)

%% Settings
addpath('settings');
addpath('function');
s = p00_settings();

%% Required Steps
% Override old outputs?
s.todo.override = true;
%analysis steps 
s.todo.load_data                        = true;
s.todo.microstates_gfppeaks             = true; 
s.todo.microstates_segmentation         = true; 
s.todo.microstates_reorderProto         = true;
s.todo.microstates_backfitting          = true;
s.todo.features_to_csv                  = true;

%% Anlaysis

p01_load_data(s);


end

