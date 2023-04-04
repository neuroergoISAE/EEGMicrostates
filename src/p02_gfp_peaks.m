function p02_gfp_peaks(settings)
% vCH
%% GFP PEAKS
if settings.todo.microstates_gfppeaks
    
    outputfolder = [settings.path.gfp];
    if settings.multipleSessions == true
        folders = dir(settings.path.gfp); % if multiple sessions : Gfp Peaks detection on each session
        folders = folders(contains({folders.name},'sub'));
        for i=1:length(folders)
            outputparticipantfolder = [outputfolder,folders(i).name];
            pFolder = dir([folders(i).folder, filesep, folders(i).name]);
            sFolders = pFolder(contains({pFolder.name},'ses'));
            for j = 1:length(sFolders)%settings.nSessions
                outputsessionfolder = [outputparticipantfolder, filesep, sFolders(j).name];
                sFile = sFolders(j);
                disp(['p02 GFP Peaks: ', 'participant: ',num2str(i), '/ ', num2str(length(folders)),' session: ',num2str(j),'/ ',num2str(length(sFolders))]);
                pl_microstates_gfppeaks(sFile, outputsessionfolder, settings); %input & output folder = gfp-folder with subfolder for each session of each participant
            end
        end
    else
        folders = dir(settings.path.gfp); % if single session : Gfp Peaks detection on each participant
        folders = folders(contains({folders.name},'sub'));
        % Signle session
        %loop over folders resp. subjects
        for i=1:length(folders)
            outputparticipantfolder = [outputfolder,filesep,folders(i).name];
            disp(['p02 GFP Peaks: ', num2str(i), '/ ', num2str(length(folders))])
            pl_microstates_gfppeaks(folders(i), outputparticipantfolder, settings); %input & output folder = gfp-folder for each participant
        end
    end
   
end

end