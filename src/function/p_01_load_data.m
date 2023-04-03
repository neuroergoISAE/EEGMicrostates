function p_01_load_data(settings)



if s.todo.load_data
    
    % find input data folders
    folders = dir(s.path.data); % get folder content of (input) data folder
    folders = folders(contains({folders.name},'sub')); % get only the content containing 'NDAR'
    
    %% Inf odata Quality file
    %create an info file to have an overview on the overall data quality
    %this always must be created again to be accurate
    info_dataQuality = {};
    info_dataQuality.nofile = 0;
    info_dataQuality.nofile_IDs = {};
    if s.data.checkqualityratings
        info_dataQuality.badautomagic = 0;
        info_dataQuality.badautomagic_IDs = {};
    end
    info_dataQuality.zerodata = 0;
    info_dataQuality.zerodata_IDs = {};
    info_dataQuality.badtrigger = 0;
    info_dataQuality.badtrigger_IDs = {};
    info_dataQuality.insufficient = 0;
    info_dataQuality.insufficient_IDs = {};
    
    
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
                info_dataQuality = pl_load_data(sFile,outputfile, s, info_dataQuality); % perform the MSA-specific pre-processing on each session of each participant
            end
        end
    else
        %1 Session:
        %loop over folders resp. all subjects
        for i=1:length(folders)
            disp(['p01: ', num2str(i), '/ ', num2str(length(folders))])
            info_dataQuality = pl_load_data(folders(i), s.path.gfp, s, info_dataQuality); % perform the MSA-specific pre-processing
        end
    end
    
    %% Save the info file of the overall data quality in the GFP folder
    save([s.path.gfp, 'info_dataQuality.mat'], 'info_dataQuality')
end
end