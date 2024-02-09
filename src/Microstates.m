%% 26.01.2024 Microstates Analysis Script
% main script to run whole analysis
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2024
% Description : this script in the main file for the microstates analysis. from raw xdf file to MS results
% Dependencies : EEGlab, Signal Processin Toolbox, Statistics and Machine Learning Toolbox, customcolormap
% Inputs : Raw xdf Files
% Outputs: statistics for the microstates and files throughout the process, settings are saved as 's.mat' file

function Microstates()
%% Description 
% Main file for the Microstates extraction process
% Analysed data must have been pre-processed 
% Epoching available on the trigger of interest (eyes opened or eyes closed for example)

%% Path
try
    addpath([matlabroot,'\toolbox\signal']); % 'Signal' toolbox must be added to the path
catch
    disp('Warning : Signal Processing Toolbox is missing');
end

try
        addpath([matlabroot,'\toolbox\stats']); % 'Statistics and Machine Learning' toolbox must be added to the path
catch
    disp('Warning : Statistics Toolbox is missing'); 
end

addpath('settings');
addpath('functions');
%% Settings
s.todo.paramgui = true; % Flag indicating whether to display a parameter GUI
s.todo.override = true; % Flag indicating whether to override old outputs
s.todo.eyes_epoching = true;

%analysis steps 
s.todo.load_data = true; % Flag indicating whether to load data
s.todo.microstates_gfppeaks = true; % Flag indicating whether to perform GFP peaks analysis
s.todo.microstates_segmentation = true; % Flag indicating whether to perform microstates segmentation
s.todo.microstates_reordering = true; % Flag indicating whether to perform microstates reordering
s.todo.microstates_backfitting = true; % Flag indicating whether to perform microstates backfitting
s.todo.microstates_stats = true; % Flag indicating whether to perform microstates statistics

s = p00_settings(s);
cd(s.path.src);
%% Resting State Extraction
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

list_XDF=dir([s.path.data,filesep,'**',filesep,'*.xdf']);
for f=1:length(list_XDF)  %f for files
    disp(f);
    CurrFile = [list_XDF(f).folder,filesep,list_XDF(f).name] ;%fullfile(folder,file) ;
    subject=list_XDF(f).name(6:8);
    session=list_XDF(f).name(13:14);
    % open the currentfile
    EEG = pop_loadxdf(CurrFile , 'streamtype', 'EEG', 'exclude_markerstreams', {});
    
    %1. SPLIT Resting State
    idxEnd = find(ismember(EventsType,s.epoching.ECtriggerlabel), 5 ); %first RestingState End
    idxEnd = idxEnd(5); % last RS trigger is the fifth RS_EC
    idxStart = find(ismember(EventsType,s.epoching.EOtriggerlabel), 1 ); %first RestingState End
    
    latencyFirstEO=EEG.event(idxStart).latency/EEG.srate; %time of the first 'EO' event in seconds
    latencyEnd=EEG.event(idxEnd).latency/EEG.srate; %time of the end event in seconds
    EEG = eeg_checkset( EEG );
    %select the data between firt Eyes open and END trigger
    EEG = pop_select( EEG, 'time',[latencyFirstEO-1 latencyEnd+1] );%-1 and +1 to include the event'EO and 'end'
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    
    % 2. Channel selection and location
    EEG = eeg_checkset( EEG );
    EEG = pop_select( EEG,'channel',{'A1' 'A2' 'A3' 'A4' 'A5' 'A6' 'A7' 'A8' 'A9' 'A10' 'A11' 'A12' 'A13' 'A14' 'A15' 'A16' 'A17' 'A18' 'A19' 'A20' 'A21' 'A22' 'A23' 'A24' 'A25' 'A26' 'A27' 'A28' 'A29' 'A30' 'A31' 'A32' 'B1' 'B2' 'B3' 'B4' 'B5' 'B6' 'B7' 'B8' 'B9' 'B10' 'B11' 'B12' 'B13' 'B14' 'B15' 'B16' 'B17' 'B18' 'B19' 'B20' 'B21' 'B22' 'B23' 'B24' 'B25' 'B26' 'B27' 'B28' 'B29' 'B30' 'B31' 'B32'});
    EEG = pop_chanedit(EEG, 'lookup', s.path.chanloc); % Channel location
    EEG = pop_editset(EEG, 'chanlocs', s.path.chanloc);
    
    %3. Resample
    EEG = pop_resample(EEG, 512);

    %4. Rereference 
     % Re-reference the EEG data to channel 48 (Cz)
    %EEG = pop_reref( EEG, 48,'keepref','on');
    EEG = pop_reref( EEG, 'Cz','keepref','on');
    EEG = eeg_checkset( EEG );

    % Interpolate the channel data (Cz)
    %EEG = pop_interp(EEG, 48, 'spherical');
    EEG = pop_interp(EEG, 'Cz', 'spherical');
    EEG = eeg_checkset( EEG );
    % FAIRE REREF SUR CZ AVANT
    %EEG = pop_reref( EEG, []);
    
    EEG = eeg_checkset(EEG);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); %Store dans le dataset

    % Resting State extraction
    EventsType={EEG.event.type};

    %if(s.firstRS)
        %idxEnd = find(ismember(EventsType,s.epoching.ECtriggerlabel), 5 ); %first RestingState End
        %idxEnd = idxEnd(5); % last RS trigger is the fifth RS_EC
        %idxStart = find(ismember(EventsType,s.epoching.EOtriggerlabel), 1 ); %first RestingState End
        %idxEnd = find(ismember(EventsType,'End'), 1 ); %first RestingState End
        %idxStart = find(ismember(EventsType,'Start'), 1 ); %first RestingState End
    %else
    %   idxEnd = find(ismember(EventsType,'EndRestingState'), 1,'last' ); %first RestingState End
    %   idxStart = find(ismember(EventsType,'StartRestingState'), 1,'last'); %first RestingState End
    %end
   
    
    % SAVE FILES
    file_name=['sub-' subject '_ses-' session 'task-rest_desc-resampled_eeg'];
    RS_folder = strcat(fullfile(s.path.RS_data),filesep, 'sub-', subject);
    mkdir(RS_folder);
    
    file_name = [file_name '.mat'];
    save (strcat(RS_folder, filesep, file_name), 'EEG');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',file_name,'filepath',char(RS_folder));
    %Display the plot to check visually the quality of the signal and the correct
    %number/position of the triggers (every 35 s, we should oberve bliks
    %following the EO event, and no blinks following the EC event
    %EEG = pop_reref( EEG, []); % re-referencage et filtre pour la visualisation seulement
    %EEG = pop_eegfiltnew(EEG, 1, 40, 1690, 0, [], 0);
    %pop_eegplot(EEG, 1, 1, 1);
    %eeglab redraw
end

%% Pre-processing (Automagic)
%cd(s.path.src);
error('STOP HERE');

%Autoautomagic(s);

%% BIDS format for MS analysis
automagicFiles =  dir([s.path.automagic_data,filesep,'**',filesep,'*p_sub-*.mat']);
fileNames = {automagicFiles.name};
fileFolders = {automagicFiles.folder};
if ~s.multipleSessions
    for k = 1 : length(automagicFiles)
    sub_n = char(extractBetween(fileNames{k},'p_sub-','_ses'));
    outputFullFileName = [s.path.preprocessed_data,filesep,'sub',sub_n,filesep,'eeg'];%char(strcat(settings.path.data,'sub',sub_n,'\eeg'));%
    mkdir(outputFullFileName);
    copyfile(fullfile(fileFolders{k}, fileNames{k}), fullfile(outputFullFileName,string(fileNames{k})));
    end
else
end
%remove Automagic Data Folder? (is now useless)


%% Microstates analysis
p01_load_data(s); % load data, move and rename eeg_data file in the gfp directory for easier use. If required: extract eye closed epochs
p02_gfp_peaks(s);% Perform GFP Peaks analysis
p03_microstates_segmentation(s); % Perform microstates segmentation
p04_microstates_reordering(s); % ask reordering to user for the last level and reorder sub levels. OR : reorder based on template
p05_microstates_backfitting(s);% Perform microstates backfitting
p06_microstates_stats(s);% Compute microstates statistics

save('settings/s','s'); % Save the 's' structure variable to a file for future use

end
