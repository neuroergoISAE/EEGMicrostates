function p05_microstates_backfitting(settings)
%Backfitting of last level clustering on data (in gfp folder)

if settings.todo.microstates_backfitting==1
    %% Backfitting from each level prototype on input data(session or participant level)
    
    %% !! RISQUE DE BUG SI LAST LEVEL ~= Group !!
    fp_gfp_eeg = dir([settings.path.gfp,'**\*eegdata.mat']); % % eeg 'raw' (preprocessed) data
    % Last Level
    lastLevel = char(settings.levels(end)); % last segmentation (clustering) level
    fp_level = eval(['settings.path.',lastLevel]);

    for h = settings.microstate.Nmicrostates
        fp_lastlevel_prototypes = dir([fp_level,'**\*',num2str(h),'MS_reordered.mat']); % Path containing the reordered prototypes .mat file (if group level backfitting: one file)
        for i=1:length(fp_gfp_eeg) % for each available data (each participant or each session if existing)
            disp(['p05: (nMS = ',num2str(h),') - backfitting from ',lastLevel,'-level prototypes']);
            fn_eeg_data = [fp_gfp_eeg(i).folder,filesep,fp_gfp_eeg(i).name];
            %backfitting of this file
            pl_microstates_backfitting(fn_eeg_data,fp_lastlevel_prototypes,h, settings); %lastlevel_prototypes_path
        end
    end
end

end