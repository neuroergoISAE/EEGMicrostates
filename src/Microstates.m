%Launch MS Analysis
% April 2024 - CH

function s = Microstates()
% 
% try
%     addpath([matlabroot,'\toolbox\signal']); % 'Signal' toolbox must be added to the path
% catch
%     disp('Warning : Signal Processing Toolbox is missing');
% end
% 
% try
%         addpath([matlabroot,'\toolbox\stats']); % 'Statistics and Machine Learning' toolbox must be added to the path
% catch
%     disp('Warning : Statistics Toolbox is missing'); 
% end

addpath('settings');
addpath('functions');

s = MicrostatesGUI();
%% create path 
s = createpath(s);

%% Analysis
% %% Anlaysis
p01_load_data(s); % load data, move and rename eeg_data file in the gfp directory for easier use. If required: extract eye closed epochs
p02_gfp_peaks(s);% Perform GFP Peaks analysis
p03_microstates_segmentation(s); % Perform microstates segmentation
p04_microstates_reordering(s); % ask reordering to user for the last level and reorder sub levels. OR : reorder based on template
p05_microstates_backfitting(s);% Perform microstates backfitting
p06_microstates_stats(s);% Compute microstates statistics
% 
save('settings/s','s'); % Save the 's' structure variable to a file for future use
end
