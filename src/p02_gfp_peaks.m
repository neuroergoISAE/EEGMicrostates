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
    
    outputfolder = [settings.path.gfp]; % gfp peaks folder 
    folders = dir(settings.path.gfp); 
    folders = folders(~contains({folders.name},'.')); % ignore parent folders
    if settings.multipleSessions 
        for i=1:length(folders) % each participant
            outputparticipantfolder = [outputfolder,folders(i).name];
            fp_folder = dir([folders(i).folder, filesep, folders(i).name]);
            fp_folder = fp_folder(~contains({fp_folder.name},'.')); % ignore parent folders
            for j = 1:length(fp_folder) % each session
                outputsessionfolder = [outputparticipantfolder, filesep, fp_folder(j).name];
                fp_file = fp_folder(j);
                disp(['p02 GFP Peaks: ', 'participant: ',num2str(i), filesep, num2str(length(folders)),' session: ',num2str(j),filesep,num2str(length(fp_folder))]);
                pl_microstates_gfppeaks(fp_file, outputsessionfolder, settings); %input & output folder = gfp-folder with subfolder for each session of each participant
            end
        end
    else
        for i=1:length(folders)% each participant
            outputparticipantfolder = [outputfolder,filesep,folders(i).name];
            disp(['p02 GFP Peaks: ', num2str(i), filesep, num2str(length(folders))])
            pl_microstates_gfppeaks(folders(i), outputparticipantfolder, settings); %input & output folder = gfp-folder for each participant
        end
    end
   
end

end