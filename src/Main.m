%% RESTING STATE : Microstates extraction
%%%%%%%
%% SETTINGS
%add signal to path
addpath('C:\Program Files\MATLAB\R2021a\toolbox\signal'); %à modifier
addpath('C:\Program Files\MATLAB\R2021a\toolbox\stats'); % à modifier
% PARAM RESTING STATE
[param ,~] = paramGUI;
settings.name = param.projectName;
settings.path = param.path;
RS_position = 'FirstRS';

%No modification required, check if your folder are well organized. If not
%you can change directories name (or better: your folder organization)
settings.path.MS_Data = [settings.path.global_path,filesep,settings.name,filesep]; %Global results folder, folder created in the global path with the project name 
settings.path.chanloc_path =[settings.path.global_path,filesep,'external_files\Loc_10-20_64Elec.elp']; %Channel loc file should be located is the "external_files" folder. if not you can still change the path name
settings.path.Automagic_Data = [settings.path.MS_Data,RS_position,filesep,'Automagic_Results',filesep]; %Path where the automagic results will be saved
settings.path.Preprocessing  = [settings.path.MS_Data,RS_position,filesep,'Data_Preprocessing',filesep]; %Preprocessed Data

%moritzette path
settings.path.data = [settings.path.MS_Data,RS_position,filesep,'Data_Microstates',filesep]; % Data for Microstates (automagic BIDS)
settings.path.results = [settings.path.MS_Data,RS_position,filesep,'Microstates_Results',filesep]; %Microstates Results

rmpath(genpath(settings.path.eeglab)); % remove plugins paths to avoid conflict in eeglab toolboxes
addpath(settings.path.eeglab); %add eeglab to path

%% 1. Rename and move xdf files
if ~exist(strcat(settings.path.MS_Data), 'dir')
    mkdir(strcat(settings.path.MS_Data));
end
if ~exist(strcat(settings.path.MS_Data,'Data_Raw_Renamed'), 'dir')
    mkdir(strcat(settings.path.MS_Data,'Data_Raw_Renamed'));
end

% Copy the files over with a new name.
inputFiles =  dir(strcat(settings.path.raw_Data,'\**\*.xdf'));
fileNames = { inputFiles.name };
fileFolders = { inputFiles.folder };
for k = 1 : length(inputFiles)
    outputFileName = erase(fileNames{k},'_task-RS_run-001');
    outputFileName = erase(outputFileName,'P0');
    outputFullFileName = fullfile(strcat(settings.path.MS_Data,'Data_Raw_Renamed'),outputFileName);
    copyfile(fullfile(fileFolders{k}, fileNames{k}), outputFullFileName);
end

%% 2.Run¨Preprocessing (orginally : code from ModePreProcXDF.m)
if ~exist(strcat(settings.path.Preprocessing), 'dir')
    mkdir(settings.path.Preprocessing);
end

cd(fullfile(settings.path.MS_Data,'Data_Raw_Renamed'));
%list of .xdf files
liste_XDF=dir('*.xdf');

% Open EEGLAB and import the XDF file
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for f=1:length(liste_XDF)  %f for files
    disp(f);

    CurrFile = liste_XDF(f).name ;%fullfile(folder,file) ;
    subject=CurrFile(5:6);
    session=CurrFile(12:13);
    % open the currentfile
    EEG = pop_loadxdf(CurrFile , 'streamtype', 'EEG', 'exclude_markerstreams', {});

    % Channel location
    %
    %EEG=pop_chanedit(EEG, 'load',{settings.path.chanloc_path 'filetype' 'autodetect'});
    %Channel selection
    EEG = eeg_checkset( EEG );
    %EEG = pop_chanedit(EEG, 'lookup', settings.path.chanloc_path); % Channel location
    EEG = pop_select( EEG,'channel',{'A1' 'A2' 'A3' 'A4' 'A5' 'A6' 'A7' 'A8' 'A9' 'A10' 'A11' 'A12' 'A13' 'A14' 'A15' 'A16' 'A17' 'A18' 'A19' 'A20' 'A21' 'A22' 'A23' 'A24' 'A25' 'A26' 'A27' 'A28' 'A29' 'A30' 'A31' 'A32' 'B1' 'B2' 'B3' 'B4' 'B5' 'B6' 'B7' 'B8' 'B9' 'B10' 'B11' 'B12' 'B13' 'B14' 'B15' 'B16' 'B17' 'B18' 'B19' 'B20' 'B21' 'B22' 'B23' 'B24' 'B25' 'B26' 'B27' 'B28' 'B29' 'B30' 'B31' 'B32'});
    EEG = pop_chanedit(EEG, 'lookup', settings.path.chanloc_path); % Channel location
    EEG = pop_editset(EEG, 'chanlocs', settings.path.chanloc_path);

    %Resample
    EEG = pop_resample(EEG, 500);

    %REREFERENCAGE average
    %EEG = pop_reref( EEG, []);
    
    EEG = eeg_checkset(EEG);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); %Store dans le dataset

    % FIRST RESTING STATE: first = True.LAST RESTING STATE: first =False
    
    % Get only the "Rest" part of the recording from the first EO (event for
    %Eyes Open, the recording always starts with EO) to the END event
    %takes the indice of 'end' end 'EO'
    EventsType={EEG.event.type};
    j=0;
    
    %for i=1:length(EventsType)
    %    if strcmp(EventsType{i},'EndRestingState')==1
            %if strcmp(EventsType{i},'End')==1
       %     idxEnd_lastRS=i;
      %  elseif strcmp(EventsType{i},'EO')==1
       %     j=j+1;
        %    IdxEO(j)=i;
        %end
   % end

   if(firstRS)
    idxEnd = find(ismember(EventsType,'EndRestingState'), 1 ); %first RestingState End
    idxStart = find(ismember(EventsType,'StartRestingState'), 1 ); %first RestingState End
   else
       idxEnd = find(ismember(EventsType,'EndRestingState'), 1,'last' ); %first RestingState End
       idxStart = find(ismember(EventsType,'StartRestingState'), 1,'last'); %first RestingState End
   end
   
    latencyFirstEO=EEG.event(idxStart).latency/EEG.srate; %time of the first 'EO' event in seconds
    latencyEnd=EEG.event(idxEnd).latency/EEG.srate; %time of the end event in seconds
    EEG = eeg_checkset( EEG );
    %select the data between firt Eyes open and END trigger
    EEG = pop_select( EEG, 'time',[latencyFirstEO-1 latencyEnd+1] );%-1 and +1 to include the event'EO and 'end'
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');

    % SAVE FILES
    nomfichier=['sub-' subject '_ses-' session 'task-rest_desc-resampled_eeg'];
    ParentFolder = fullfile(settings.path.Preprocessing); 
    AutomagicFolder = strcat(ParentFolder, '\', 'sub-', subject);
    mkdir(AutomagicFolder);
    
    nomfichier = [nomfichier '.mat'];
    save (strcat(AutomagicFolder, '\', nomfichier), 'EEG');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',nomfichier,'filepath',char(AutomagicFolder));

    %Display the plot to check visually the quality of the signal and the correct
    %number/position of the triggers (every 35 s, we should oberve bliks
    %following the EO event, and no blinks following the EC event
    EEG = pop_reref( EEG, []); % re-referencage et filtre pour la visualisation seulement
    EEG = pop_eegfiltnew(EEG, 1, 40, 1690, 0, [], 0);
    pop_eegplot(EEG, 1, 1, 1);
    eeglab redraw
end


%% 3.Automagic

rmpath(genpath(settings.path.eeglab));
addpath(strcat(settings.path.eeglab,'plugins\automagic2.6'));
cd(fullfile(settings.path.global_path,'src'));
%(settings); ??

%% 4.Move automagic files
if ~exist(settings.path.data, 'dir')
    mkdir(settings.path.data);
end
inputFiles =  dir(strcat(settings.path.Automagic_Data,'\**\*p_sub-*.mat'));
fileNames = { inputFiles.name };
fileFolders = { inputFiles.folder };
for k = 1 : length(inputFiles)
    sub_n = string(extractBetween(fileNames{k},'p_sub-','_ses'));
    outputFullFileName = [settings.path.data,'sub',sub_n,filesep,'eeg'];%char(strcat(settings.path.data,'sub',sub_n,'\eeg'));
    mkdir(outputFullFileName);
    copyfile(fullfile(fileFolders{k}, fileNames{k}), fullfile(outputFullFileName,string(fileNames{k})));
end

%CLOSE EEGLAB AND CLEAN PATH (if not, error will occur)

rmpath(genpath(settings.path.eeglab));
addpath(settings.path.eeglab);

%% 4. Microstates Analysis (Moritz)
disp('Run Moritzette: Microstates Topo');
cd(fullfile(settings.path.global_path,'src\Moritzette'));
settings  = moritzette(settings);
rmpath(genpath(settings.path.eeglab));