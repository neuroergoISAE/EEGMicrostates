%% p02_gfp_peaks.m
% Author : C. Hamery
% Date : 06.2024
% Description : This script loads each of the eeg data, extracts the gfp peaks and save them in the gfp folder for each participant/session
% This script takes different processing cases into account depending on the user requirements about clustering levels.
% If the clustering levels are skipping one or more sublevels, the gfp peaks of each participant/session are merged.
% Input : settings, structure containing all settings for the analysis
% Output: gfp peaks for each participant/session or for the whole group

function p02_gfp_peaks(settings)
if settings.todo.microstates_gfppeaks
    folders = dir(fullfile(settings.path.gfp,'**\eegdata.mat')); 
    for i = 1:length(folders)
        inputfolder = folders(i);
        outputfolder = folders(i).folder;
        pl_microstates_gfppeaks(inputfolder, outputfolder, settings); %input & output folder = gfp-folder for each participant
    end
    
    firstlevel = char(settings.levels(1));
    switch firstlevel
        case "group"            
            fp_all_gfp = dir([settings.path.gfp,filesep, '**',filesep,'gfppeaks.mat']); % all gfp files of all subjects and all sessions
            concat_gfp.CEEG = []; % empty concat gfp            
            for g = 1:length(fp_all_gfp)
                tmp_gfp = load([fp_all_gfp(g).folder,filesep,fp_all_gfp(g).name]);
                concat_gfp.CEEG = horzcat(concat_gfp.CEEG, tmp_gfp.CEEG);
            end
            fp_delete = dir(settings.path.gfp);
            fp_delete =  fp_delete(~contains({fp_delete.name},{'.','..','group'})); 
            for d = 1:length(fp_delete)
                rmdir([fp_delete(d).folder,filesep,fp_delete(d).name,filesep],'s');
            end
            save([settings.path.gfp,filesep,'group',filesep,'gfppeaks.mat'],'-struct','concat_gfp'); % save EEG only
            movefile([settings.path.gfp,filesep,'group',filesep,'group_eegdata.mat'],[settings.path.gfp,filesep,'group',filesep,'eegdata.mat']);
        case "participant"
            if settings.multipleSessions
                fp_participants = dir(settings.path.gfp);
                fp_participants  = fp_participants(~contains({fp_participants.name},'.')); % ignore parent folders
                for p = 1:length(fp_participants)
                    fp_p  = [fp_participants(p).folder,filesep,fp_participants(p).name];
                    fp_all_gfp = dir([fp_p,filesep, '**',filesep,'gfppeaks.mat']); % all gfp files of all subjects and all sessions
                    concat_gfp.CEEG = []; % empty concat gfp            
                    for g = 1:length(fp_all_gfp)
                        tmp_gfp = load([fp_all_gfp(g).folder,filesep,fp_all_gfp(g).name]);
                        concat_gfp.CEEG = horzcat(concat_gfp.CEEG, tmp_gfp.CEEG);
                    end
                    fp_delete = dir(fp_p);
                    fp_delete =  fp_delete(~contains({fp_delete.name},{'.','..','.mat'})); 
                    for d = 1:length(fp_delete)
                        rmdir([fp_delete(d).folder,filesep,fp_delete(d).name,filesep],'s');
                    end
                    save([fp_p,filesep,'gfppeaks.mat'],'-struct','concat_gfp'); % save EEG only    
                    movefile([settings.path.gfp,fp_participants(p).name,filesep,'participant_eegdata.mat'],[settings.path.gfp,filesep,fp_participants(p).name,filesep,'eegdata.mat']);
                end
            end
    end
end
end


    
