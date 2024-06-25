%% p01_load_data.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads the eeg data and select the epochs of interest if requested
% Dependencies : same as main
% Inputs : settings, structure containing all settings for the analysis
% Outputs: eegdata.mat file for each participant/session in the gfp folder



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
            fp_all_eeg = dir([settings.path.gfp,filesep, '**',filesep,'*',settings.dataformat]); % all gfp files of all subjects and all sessions
            concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
            for g = 2:length(fp_all_eeg)
                tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
                concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data
            end
            %             % write concat gfp and eeg in order to read it later (for segmentation)
            %             % concat gfp is written as 'gfppeaks.mat' in the group folder, concat eeg as "eegdata.mat"
            %             % erase all sessions and participant single gfp
            rmdir(settings.path.gfp,'s');
            mkdir(settings.path.gfp);
            mkdir([settings.path.gfp,filesep,'group']);
            save([settings.path.gfp,filesep,'group',filesep,'eegdata.mat'],'-struct','concat_eeg'); % save EEG only
            
        case "participant"
            % if multiple session : create single eeg file for each participantn, else: do nothing
            if settings.multipleSessions
                
                fp_participants = dir(settings.path.gfp);
                fp_participants  = fp_participants(~contains({fp_participants.name},'.')); % ignore parent folders
                for p = 1:length(fp_participants)
                    fp_p  = [fp_participants(p).folder,filesep,fp_participants(p).name];
                    fp_all_eeg = dir([fp_p,filesep, '**',filesep,'*',settings.dataformat]); % all gfp files of all subjects and all sessions
                    concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
                    for g = 2:length(fp_all_eeg)
                        tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
                        concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data
                    end
                    rmdir(fp_p,'s');
                    mkdir(fp_p);
                    save([fp_p,filesep,'eegdata.mat'],'-struct','concat_eeg'); % save EEG only                    
                end
            end
    end
end
end

% function p01_load_data(settings)
% 
% if settings.todo.load_data
%     if settings.todo.RS
%         %epochfolders = dir(settings.path.datatoepoch);
%         RSfolders = dir(settings.path.data);%dir(settings.path.preprocessed_data);
%         RSfolders  = RSfolders(~contains({RSfolders.name},'.')); % ignore parent folders
%         if settings.multipleSessions %First level : Session
%             for i=1:length(RSfolders) %each participant
%                 fp_epoch = dir([RSfolders(i).folder, filesep, RSfolders(i).name]);
%                 fp_epoch = fp_epoch(~contains({fp_epoch.name},'.'));
%                 for j = 1:length(fp_epoch)%each session
%                     disp(['p01 Load Data & Data Epoching: ', num2str(j), '/ ', num2str(length(fp_epoch)*length(fp_epoch))])
%                     fn_output = [RSfolders(i).name,filesep,fp_epoch(j).name];
%                     pl_epoching(fp_epoch(j),fn_output,settings);
%                 end
%             end
%         else
%             for k=1:length(RSfolders) %First level : Participants
%                 disp(['p01 Load Data & Data Epoching:', num2str(k), '/ ', num2str(length(RSfolders))])
%                 %pl_epoching(RSfolders(k),RSfolders(k).name,settings);
%                 pl_addpreproc(RSfolders(k),settings);
%             end
%         end
%         
%     else %else: load the data
%         
%         % find input data folders
%         %folders = dir(settings.path.preprocessed_data); % get folder content of (input) data folder
%         folders = dir(settings.path.data);
%         folders = folders(~contains({folders.name},'.')); % ignore parent folders
%         
%         if settings.multipleSessions % First Level : Sessions
%             for i=1:length(folders) %each participant
%                 fp_folder = dir([folders(i).folder, filesep, folders(i).name]);
%                 fp_folder = fp_folder(~contains({fp_folder.name},'.')); % ignore parent folders
%                 fp_folder = fp_folder(~contains({fp_folder.name},'project_state.mat')); % potentiel automagic files
%                 fp_folder = fp_folder(~contains({fp_folder.name},'desktio.ini')); % drive files
%                 
%                 
%                 for j = 1:length(fp_folder) %each session
%                     fp_file = fp_folder(j);
%                     outputfile = [settings.path.gfp,folders(i).name,filesep];
%                     disp(['p01 Load Data: ', 'participant: ',num2str(i), '/ ', num2str(length(folders)),' session: ',num2str(j),'/ ',num2str(length(fp_folder))]);
%                     pl_load_data(fp_file,outputfile, settings);
%                 end
%             end
%         else % First level : Participants
%             for i=1:length(folders)
%                 disp(['p01 Load Data: ', num2str(i), '/ ', num2str(length(folders))])
%                 pl_load_data(folders(i), settings.path.gfp, settings);
%             end
%         end
%         
%         
%         %% TEST switch
%         if settings.levels(1)=="group"
%             switch settings.levels(1)
%                 case "group"
%                     %             fp_all_gfp = dir(fullfile(settings.path.gfp, '**\gfppeaks.mat')); % all gfp files of all subjects and all sessions
%                     % ATTENTION .mat ou .set!!
%                     fp_all_eeg = dir(fullfile(settings.path.data, '**\*.',settings.dataformat)); % all gfp files of all subjects and all sessions
%                     concat_eeg = load([fp_all_eeg(1).folder,filesep,fp_all_eeg(1).name]);
%                     for g = 2:length(fp_all_eeg)
%                         tmp_eeg = load([fp_all_eeg(g).folder,filesep,fp_all_eeg(g).name]);
%                         concat_eeg.EEG = pop_mergeset(concat_eeg.EEG,tmp_eeg.EEG);  %merge EEG data
%                     end
%                     %             % write concat gfp and eeg in order to read it later (for segmentation)
%                     %             % concat gfp is written as 'gfppeaks.mat' in the group folder, concat eeg as "eegdata.mat"
%                     %             % erase all sessions and participant single gfp
%                     mkdir([settings.path.gfp,filesep,'group']);
%                     save([settings.path.gfp,filesep,'group',filesep,'eegdata.mat'],'-struct','concat_eeg'); % save EEG only
%                     
%                     pl_load_data(fp_file,outputfile, settings);
%                     
%                     %             chanlocs = concat_eeg.EEG.chanlocs;
%                     %             save([settings.path.gfp,'chanlocs.mat'],'chanlocs'); % save chanlocs for further analysis
%             end
%             
%         end
%         
%         %%
%     end
% end
% end

