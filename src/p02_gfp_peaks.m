%% p02_gfp_peaks.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads each of the eeg data, extracts the gfp peaks and save them in the gfp folder for each participant/session
% Dependencies : EEGlab
% Inputs : settings, structure containing all settings for the analysis
% Outputs: gfp peaks for each participant/session
function p02_gfp_peaks(settings)
%% GFP PEAKS
if settings.todo.microstates_gfppeaks
    folders = dir(fullfile(settings.path.gfp,'**\eegdata.mat')); 
    for i = 1:length(folders)
        inputfolder = folders(i);
        outputfolder = folders(i).folder;
        pl_microstates_gfppeaks(inputfolder, outputfolder, settings); %input & output folder = gfp-folder for each participant
    end
end

% if settings.todo.microstates_gfppeaks
%     
%     outputfolder = [settings.path.gfp]; % gfp peaks folder 
%     folders = dir(settings.path.gfp); 
%     folders = folders(~contains({folders.name},'.')); % ignore parent folders
%     if settings.multipleSessions 
%         for i=1:length(folders) % each participant
%             outputparticipantfolder = [outputfolder,folders(i).name];
%             fp_folder = dir([folders(i).folder, filesep, folders(i).name]);
%             fp_folder = fp_folder(~contains({fp_folder.name},'.')); % ignore parent folders
%             for j = 1:length(fp_folder) % each session
%                 outputsessionfolder = [outputparticipantfolder, filesep, fp_folder(j).name];
%                 fp_file = fp_folder(j);
%                 disp(['p02 GFP Peaks: ', 'participant: ',num2str(i), filesep, num2str(length(folders)),' session: ',num2str(j),filesep,num2str(length(fp_folder))]);
%                 pl_microstates_gfppeaks(fp_file, outputsessionfolder, settings); %input & output folder = gfp-folder with subfolder for each session of each participant
%             end
%         end
%         %% IF GROUP ONLY : merge all sessions gfp and erase participant gfp
% %         if settings.levels(1)=="group" %length(settings.backfittingLevels)<3
% %             fp_all_gfp = dir(fullfile(settings.path.gfp, '**\gfppeaks.mat')); % all gfp files of all subjects and all sessions
% %             fp_all_eeg = dir(fullfile(settings.path.gfp, '**\eegdata.mat')); % all gfp files of all subjects and all sessions
% %             concat_gfp.CEEG = []; % empty concat gfp
% %             %concat_eeg.EEG = []; %empty eeg
% %             for g = 1:length(fp_all_gfp)
% %                 tmp_gfp = load([fp_all_gfp(g).folder,filesep,fp_all_gfp(g).name]);
% %                 concat_gfp.CEEG = horzcat(concat_gfp.CEEG, tmp_gfp.CEEG);
% %             end
% %             concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
% %             for g = 2:length(fp_all_eeg)
% %                 tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
% %                 concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data  
% %             end
% %             % write concat gfp and eeg in order to read it later (for segmentation)
% %             % concat gfp is written as 'gfppeaks.mat' in the group folder, concat eeg as "eegdata.mat"
% %             % erase all sessions and participant single gfp
% %             rmdir(settings.path.gfp,'s');
% %             mkdir(settings.path.gfp);
% %             save([settings.path.gfp,'gfppeaks.mat'],'-struct','concat_gfp'); % save CEEG only
% %             save([settings.path.gfp,'eegdata.mat'],'-struct','concat_eeg'); % save EEG only
% %             chanlocs = concat_eeg.EEG.chanlocs;
% %             save([settings.path.gfp,'chanlocs.mat'],'chanlocs'); % save chanlocs for further analysis
% %         end
%         %% IF GROUP AND PARTICIPANT ONYL : merge sessions gfp by participants and erase sessions gfp
%     else
%         for i=1:length(folders)% each participant
%             outputparticipantfolder = [outputfolder,filesep,folders(i).name];
%             disp(['p02 GFP Peaks: ', num2str(i), filesep, num2str(length(folders))])
%             pl_microstates_gfppeaks(folders(i), outputparticipantfolder, settings); %input & output folder = gfp-folder for each participant
%         end
%     end
%    
% end

end


    
