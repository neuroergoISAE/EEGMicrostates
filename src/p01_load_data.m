function p01_load_data(settings)
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
            folders(1)
            pl_load_data(folders(i), settings.path.gfp, settings);
        end
    end   
end
end