function p01_load_data(settings)
% vCH

if settings.todo.load_data
    
    % find input data folders
    folders = dir(settings.path.data); % get folder content of (input) data folder
    folders = folders(contains({folders.name},'sub')); % get only the content containing 'NDAR'
    
    dir([settings.path.data,**]
    folders = folders(contains({folders.name},'*eeg.mat'))
    %% Reading Files
    if settings.levels == 3 %settings.multipleSessions == true% First Level : Sessions
        %Case : Multiple Sessions, loop over each participant and each sessions
        for i=1:length(folders) %each participant
            pFolder = dir([folders(i).folder, filesep, folders(i).name]);
            sFolders = pFolder(contains({pFolder.name},'ses'));
            for j = 1:length(sFolders)%settings.nSessions %each session
                sFile = sFolders(j);
                outputfile = [settings.path.gfp,folders(i).name,filesep];
                disp(['p01 Load Data: ', 'participant: ',num2str(i), '/ ', num2str(length(folders)),' session: ',num2str(j),'/ ',num2str(length(sFolders))]);
                pl_load_data(sFile,outputfile, settings); % perform the MSA-specific pre-processing on each session of each participant
            end
        end
    else % First level : Participants
        for i=1:length(folders)
            disp(['p01 Load Data: ', num2str(i), '/ ', num2str(length(folders))])
            pl_load_data(folders(i), settings.path.gfp, settings); % perform the MSA-specific pre-processing
        end
    end
    
end
end