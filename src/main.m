%% Adapted from Christian Pfeiffer & Moritz Truninger
%% 2023 - Isae Supaero
function main()
%% Description 
% Main file for the Microstates extraction process
% input: settings folder 
% Analysed data must have been pre-processed and epoched on the trigger of interest (eyes opened or eyes closed for example)

%% Path
%cd(src folder location);
try
    addpath([matlabroot,'\toolbox\signal']); 
catch
    disp('Warning : Signal Processing Toolbox is missing');
end

try
        addpath([matlabroot,'\toolbox\stats']); 
catch
    disp('Warning : Statistics Toolbox is missing');
end

addpath('settings');
addpath('functions');

%% GUI
%% Required Steps
s.todo.paramgui                         = true;
s.todo.override                         = true; % Override old outputs?
%analysis steps 
s.todo.load_data                        = true;
s.todo.microstates_gfppeaks             = true;
s.todo.microstates_segmentation         = true;
s.todo.microstates_reordering           = true;
s.todo.microstates_backfitting          = true;
s.todo.microstates_stats                = true;


%% Settings
s = p00_settings(s);
disp(s.todo);

%% Anlaysis
p01_load_data(s); % load data, move and rename eeg_data file in the gfp directory for easier use. If required: extract eye closed epochs
p02_gfp_peaks(s);
p03_microstates_segmentation(s);
% 
% % if list of N microstate > 1 : select nMicrostates (backfitting will be
% % done on only one choice of nMicrostates
% 
p04_microstates_reordering(s); % ask reordering to user for the last level and reorder sub levels. OR : reorder based on template

p05_microstates_backfitting(s);

p06_microstates_stats(s);


%% save settings for next time
save('settings/s','s');
end

