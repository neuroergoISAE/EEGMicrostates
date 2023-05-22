function p01_load_data(settings)

if settings.todo.eyes_epoching
    epochfolders = dir(settings.path.datatoepoch);
    epochfolders  = epochfolders(~contains({epochfolders.name},'.')); % ignore parent folders
    if settings.multipleSessions
        for i=1:length(epochfolders)
            fp_epoch = dir([epochfolders(i).folder, filesep, epochfolders(i).name]);
            fp_epoch = fp_epoch(~contains({fp_epoch.name},'.'));
            for j = 1:length(fp_epoch)
                disp(['Data Epoching: ', num2str(j), '/ ', num2str(length(fp_epoch)*length(fp_epoch))])
                fn_output = [epochfolders(i).name,filesep,fp_epoch(j).name];
                pl_epoching(fp_epoch(j),fn_output,settings);
            end
            
        end
    else
        for k=1:length(epochfolders)
            disp(['Data Epoching: ', num2str(k), '/ ', num2str(length(epochfolders))])
            pl_epoching(epochfolders(k),epochfolders(k).name,settings);
        end
    end

end

if settings.todo.load_data
    
    % find input data folders
    folders = dir(settings.path.data); % get folder content of (input) data folder
    folders = folders(~contains({folders.name},'.')); % ignore parent folders
    
    if settings.multipleSessions % First Level : Sessions
        for i=1:length(folders) %each participant
            fp_folder = dir([folders(i).folder, filesep, folders(i).name]);
            fp_folder = fp_folder(~contains({fp_folder.name},'.')); % ignore parent folders
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