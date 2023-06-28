%% p05_microstates_backfitting.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script backfits the eeg data on each required level for requested each number of cluster (microstates) 
% Dependencies : EEGlab
% Inputs : settings, structure containing all settings for the analysis
% Outputs: backfitting results for each participant/session for each level and each number of cluster (microstates)

function p05_microstates_backfitting(settings)
if settings.todo.microstates_backfitting
    %% Backfitting from each level prototype on input data (session or participant level)
    fp_gfp_eeg = dir([settings.path.gfp,'**\*eegdata.mat']); % eeg (preprocessed) data
    
    lastLevel = char(settings.levels(end)); % last segmentation (clustering) level, must correspond to the group level
    fp_level = eval(['settings.path.',lastLevel]);

    for h = settings.microstate.Nmicrostates % for each number of cluster
        fp_lastlevel_prototypes = dir([fp_level,'**\*',num2str(h),'MS_reordered.mat']); % directory containing the reordered prototypes .mat file (if group level backfitting: one file)
        for i=1:length(fp_gfp_eeg) % for each available data (each participant or each session if existing)
            disp(['p05: (nMS = ',num2str(h),') - backfitting from ',lastLevel,'-level prototypes']);
            fn_eeg_data = [fp_gfp_eeg(i).folder,filesep,fp_gfp_eeg(i).name];
            pl_microstates_backfitting(fn_eeg_data,fp_lastlevel_prototypes,h, settings); %backfitting of this file
        end
    end
end
end