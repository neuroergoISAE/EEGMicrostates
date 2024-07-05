%% p01_load_data.m
% Author : C. Hamery
% Date : 06.2024
% Description : This script loads the eeg data and select the epochs of interest if requested
% Depending on the required clustering levels, will create a concatenate eegdata.mat file in the corresponding folder
% Input : settings, structure containing all settings for the analysis
% Output : eegdata.mat file for each participant/session in the gfp folder

function p01_load_data(settings)
if settings.todo.load_data
    
    if numel(dir(settings.path.gfp)) >2 % if gfp folder not empty : remove files from folder
        try
            rmdir(settings.path.gfp, 's') %delete the file
            mkdir(settings.path.gfp) %create empty folder again
        catch
            disp("Cannot empty GFP folder");
        end
    end
    
    folders = dir([settings.path.data, filesep,'**',filesep,'*',settings.dataformat]); % all eeg files of all subjects and all sessions
    for i = 1:length(folders)
         inputfolder = folders(i);
         outputfolder = [settings.path.gfp,char(extractBetween(folders(i).folder,[settings.path.data,filesep],[filesep,'eeg']))];%folders(i).folder;
         pl_load_data(inputfolder,outputfolder, settings);
    end
    
    firstlevel = char(settings.levels(1));
    switch firstlevel
        case "group"
            fp_all_eeg = dir([settings.path.gfp,filesep, '**',filesep,'*.mat']); % all gfp files of all subjects and all sessions
            concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
            chanlocs = concat_eeg.EEG.chanlocs;
            for g = 2:length(fp_all_eeg)
                tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
                concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data
            end
            mkdir([settings.path.gfp,filesep,'group']);
            save([settings.path.gfp,filesep,'group',filesep,'group_eegdata.mat'],'-struct','concat_eeg'); % save EEG only
            save([settings.path.gfp,filesep,'group',filesep,'chanlocs.mat'],'chanlocs'); % save chanlocs

        case "participant"
            % if multiple session : create single eeg file for each participantn, else: do nothing
            if settings.multipleSessions
                
                fp_participants = dir(settings.path.gfp);
                fp_participants  = fp_participants(~contains({fp_participants.name},'.')); % ignore parent folders
                for p = 1:length(fp_participants)
                    fp_p  = [fp_participants(p).folder,filesep,fp_participants(p).name];
                    fp_all_eeg = dir([fp_p,filesep, '**',filesep,'*',settings.dataformat]); % all gfp files of all subjects and all sessions
                    concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
                    chanlocs = concat_eeg.EEG.chanlocs;
                    for g = 1:length(fp_all_eeg)
                        tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
                        concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data
                    end
                    save([fp_p,filesep,'participant_eegdata.mat'],'-struct','concat_eeg'); % save EEG only   
                    save([settings.path.gfp,filesep,fp_participants(p).name,filesep,'chanlocs.mat'],'chanlocs'); % save chanlocs
                end
            end
    end
end
end
