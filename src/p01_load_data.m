%% p01_load_data.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads the eeg data and select the epochs of interest if requested
% Dependencies : same as main
% Inputs : settings, structure containing all settings for the analysis
% Outputs: eegdata.mat file for each participant/session in the gfp folder

function p01_load_data(settings)

if settings.todo.load_data
    if settings.todo.RS
        %epochfolders = dir(settings.path.datatoepoch);
        RSfolders = dir(settings.path.data);%dir(settings.path.preprocessed_data);
        RSfolders  = RSfolders(~contains({RSfolders.name},'.')); % ignore parent folders
        if settings.multipleSessions %First level : Session
            for i=1:length(RSfolders) %each participant
                fp_epoch = dir([RSfolders(i).folder, filesep, RSfolders(i).name]);
                fp_epoch = fp_epoch(~contains({fp_epoch.name},'.'));
                for j = 1:length(fp_epoch)%each session
                    disp(['p01 Load Data & Data Epoching: ', num2str(j), '/ ', num2str(length(fp_epoch)*length(fp_epoch))])
                    fn_output = [RSfolders(i).name,filesep,fp_epoch(j).name];
                    pl_epoching(fp_epoch(j),fn_output,settings);
                end
            end
        else
            for k=1:length(RSfolders) %First level : Participants
                disp(['p01 Load Data & Data Epoching:', num2str(k), '/ ', num2str(length(RSfolders))])
                %pl_epoching(RSfolders(k),RSfolders(k).name,settings);
                pl_addpreproc(RSfolders(k),settings);
            end
        end
        
    else %else: load the data
        
        % find input data folders
        %folders = dir(settings.path.preprocessed_data); % get folder content of (input) data folder
        folders = dir(settings.path.data);
        folders = folders(~contains({folders.name},'.')); % ignore parent folders
        
        if settings.multipleSessions % First Level : Sessions
            for i=1:length(folders) %each participant
                fp_folder = dir([folders(i).folder, filesep, folders(i).name]);
                fp_folder = fp_folder(~contains({fp_folder.name},'.')); % ignore parent folders
                fp_folder = fp_folder(~contains({fp_folder.name},'project_state.mat')); % potentiel automagic files
                fp_folder = fp_folder(~contains({fp_folder.name},'desktio.ini')); % drive files


                for j = 1:length(fp_folder) %each session
                    fp_file = fp_folder(j);
                    outputfile = [settings.path.gfp,folders(i).name,filesep];
                    disp(['p01 Load Data: ', 'participant: ',num2str(i), '/ ', num2str(length(folders)),' session: ',num2str(j),'/ ',num2str(length(fp_folder))]);
                    pl_load_data(fp_file,outputfile, settings);
                end
            end
        else % First level : Participants
            for i=1:length(folders)
                disp(['p01 Load Data: ', num2str(i), '/ ', num2str(length(folders))])
                pl_load_data(folders(i), settings.path.gfp, settings);
            end
        end
    end
end
end