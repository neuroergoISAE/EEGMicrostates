function p_01_load_data(settings)
% vCH


if s.todo.load_data
    
    % find input data folders
    folders = dir(s.path.data); % get folder content of (input) data folder
    folders = folders(contains({folders.name},'sub')); % get only the content containing 'NDAR'
    
    %% Reading Files
    if s.multipleSessions == true
        %Case : Multiple Sessions, loop over each participant and each sessions
        for i=1:length(folders) %each participant
            pFolder = dir([folders(i).folder, filesep, folders(i).name]);
            sFolders = pFolder(contains({pFolder.name},'ses'));
            for j = 1:length(sFolders)%s.nSessions %each session
                sFile = sFolders(j);
                outputfile = [s.path.gfp,folders(i).name,filesep];
                disp(['p01: ', 'participant: ',num2str(i), '/ ', num2str(length(folders)),' session: ',num2str(j),'/ ',num2str(length(sFolders))]);
                pl_load_data(sFile,outputfile, s); % perform the MSA-specific pre-processing on each session of each participant
            end
        end
    else
        %1 Session:
        %loop over folders resp. all subjects
        for i=1:length(folders)
            disp(['p01: ', num2str(i), '/ ', num2str(length(folders))])
            pl_load_data(folders(i), s.path.gfp, s); % perform the MSA-specific pre-processing
        end
    end
    
end
end