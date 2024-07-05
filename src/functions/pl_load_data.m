%% pl_load_data.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads the eeg data, checks for the Number of sample and copies them in the gfp level folder for the next step of the analysis
% the purpose if this step is to simplify the later backfitting procedure and to ensure the data safety
% Dependencies : none
% Inputs :
% - inputfolder :  location of the eeg data of each participant/session
% - outputfolder : location for the output eegdata.mat file (in gfp>sub or gfp>sub>ses folder)
% - s : structure containing all settings
% Outputs: eegdata.mat file for each participant/session in the gfp folder

function pl_load_data(inputfolder,outputfolder,s)
%% Check existing files and Override
%fp_output = [outputfolder,inputfolder.name,filesep];
fp_output = outputfolder;
fn_eegdata = 'eegdata.mat';
output_files_exist = exist([fp_output,filesep,fn_eegdata],'file') == 2 ; % check if eegdata.mat already exists

if ~output_files_exist || s.todo.override % if eegdata does not exist or can be overriden
    if s.todo.override && (exist(fp_output,'dir') == 7)%if override requested & old first level folder of the subject exists
        try
            rmdir(fp_output, 's') %delete the file
            mkdir(fp_output) %create empty folder again
        catch
            disp("Folder could not be remove");
        end
    end
    %% Check if eegdata file exist
    %eeg_files = dir([inputfolder.folder,filesep, inputfolder.name,filesep, 'eeg', filesep]);
    %eeg_files = eeg_files(contains({eeg_files.name},s.dataformat)& ~contains({eeg_files.name},'reduced'));
    eeg_file = [inputfolder.folder,filesep, inputfolder.name];
    % eeg_files(contains({eeg_files.name},'preprocessed') & contains({eeg_files.name},'.mat') ...
    % string should not contain 'reduced' (automagic process file)
    
    %% Load EEG file
    disp('.. load eeg file');
    if ~isempty(eeg_file) % input file exists
        if ~isfolder(fp_output) %if fp_output is not a directory
            mkdir(fp_output); %make it a directory
        end
        %load([eeg_files.folder,filesep,eeg_files.name],'EEG'); % load EEG data (to determine Nsamples, only save this file if  enough samples)
        if s.dataformat ==".set"
            EEG = pop_loadset('filename',inputfolder.name,'filepath',[inputfolder.folder,filesep]);
        elseif s.dataformat == ".mat"
            load(eeg_file,'EEG'); % load EEG data (to determine Nsamples, only save this file if  enough samples)
        end
        if EEG.pnts <= 20*s.sr % 20 secondes min for MS Analysis %s.nGoodSamples % if not enough samples
            disp(['..skipping this file because not enough (good) samples: ',inputfolder.name]) % skip subject
        end
        %% Save Files in GFP directory
        disp(['..copying file in gfp directory: ',fp_output,filesep, fn_eegdata]);
        save([fp_output,filesep, fn_eegdata],'EEG');
    else
        disp(['..skipping due to inexisting input file: ',inputfolder.folder,filesep,inputfolder.name]) % skip subject
    end
end
end