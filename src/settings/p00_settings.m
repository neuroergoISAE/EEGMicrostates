%% p00_settings.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : April 2023
% Description : this script contains the parameters for the microstates analysis. Parameters can be modified
% Dependencies : EEGlab with MST1.0 and MicrostateAnalysis1.2 Toolboxes
% Inputs : s, structure containing the todo parameters
% Outputs: settings, structure containing all settings for the analysis

function settings = p00_settings(s)
settings = s;
%% if already existing settings in settings folder : load and  prefill the gui

if settings.todo.paramgui
    %[param ,~] = paramGUI; %WAS MODIFIED FOR DEMO
    [param ,~] = ConfigGUI;
    settings  = param; 
    settings.todo = s.todo; 
%    settings.todo.eyes_epoching  = param.todo.eyes_epoching;  %WAS MODIFIED FOR DEMO
    settings.todo.eyes_epoching  = false; 
    settings.path.project = 'E:\ACERI\Microstates';
else
    settings.path.project = 'E:\ACERI\Microstates';
    settings.name = ['Project_',date()]; % default name
    settings.multipleSessions = 0; % default: no sessions 
    settings.path.data = 'E:\ACERI\Microstates\RawDataForTest'; 
    settings.path.eeglab = 'D:\eeglab\eeglab2023.0';%% EEGLAB LOCATION  
end
%%
settings.firstRS = true;
%%
settings.path.src =fileparts(matlab.desktop.editor.getActiveFilename); %/src folder
%mkdir([s.path.project,filesep,filesep,s.name]);
%fileparts(settings.path.src); %global project path
settings.path.RS_data = [settings.path.project,filesep,settings.name,filesep,'RS_Data'];
settings.path.automagic_data = [settings.path.project,filesep,settings.name,filesep,'Automagic_Data'];
settings.path.preprocessed_data = [settings.path.project,filesep,settings.name,filesep,'Preprocessed_Data'];
settings.path.MS_results= [settings.path.project,filesep,settings.name,filesep,'Microstates_Results'];

settings.path.chanloc = [settings.path.project,filesep,'external_files',filesep,'Loc_10-20_64Elec.elp'];
%%
if settings.multipleSessions
    settings.backfittingLevels  = {'session','participant','group'}; %default : backfit on all levels
else
    settings.backfittingLevels  = {'participant','group'}; %default : backfit on all levels
end
if  settings.todo.eyes_epoching
    %settings.path.data =  'E:\ACERI\Microstates\Quentin\Data_Epoch';% insert data to epoch location
    settings.epoching.ECtriggerlabel = 'RS_EC';
    settings.epoching.EOtriggerlabel = 'RS_EO';
    settings.epoching.latency= 30;
    settings.epoching.timelimits = [0 30];
else
    %settings.path.data = %RAW DATA FOLDER%'E:\ACERI\Microstates\Quentin\EpochedData'; %[settings.path.global_path,filesep,settings.name,filesep,'Data_Microstates',filesep];  
end
%% Folders
if ~isfolder(settings.path.RS_data)
    mkdir(settings.path.RS_data);
end
if ~isfolder(settings.path.preprocessed_data)
    mkdir(settings.path.preprocessed_data);
end
if ~isfolder(settings.path.automagic_data)
    mkdir(settings.path.automagic_data);
end
if ~isfolder(settings.path.MS_results)
    mkdir(settings.path.MS_results);
end
cd(settings.path.src);
%% Levels
% levels ~= backfittingLevels (can be different: all levels will always be computed for the segmentation while the backfitting can be done on only a few of them if required)
if settings.multipleSessions
    settings.levels = {'session','participant','group'}; % please follow this order
else
    settings.levels = {'participant','group'};
end
% carrefull: don't modify levels spelling

if  settings.todo.eyes_epoching
    % settings for the filtering
    settings.epoching.averageref = true;%false; 
    settings.epoching.notch.lpf = 48; 
    settings.epoching.notch.hpf = 52; 
    settings.epoching.bandpass.lpf = 2;
    settings.epoching.bandpass.hpf = 20; 
    settings.epoching.winlength = 1000; %2 seconds
    settings.epoching.mvmax = 90; % maximum millivoltage to clean data
    settings.epoching.spectro.timelimits = [0 1000];
    %settings.path.data = [settings.path.global_path,filesep,settings.name,filesep,'EpochedData']; %Epoched Data Location
        %if ~isfolder(settings.path.data)
         %   mkdir(settings.path.data);
        %end
end

%% Results folders
%tables path
settings.path.tables=[settings.path.MS_results,filesep,'stats',filesep,'tables',filesep]; %mat tables with final features
if ~isfolder(settings.path.tables)
    mkdir(settings.path.tables);
end
%csv MS_results path
settings.path.csv=[settings.path.MS_results,filesep,'stats',filesep,'csv',filesep]; %csv files with final features
if ~isfolder(settings.path.csv)
    mkdir(settings.path.csv);
end

%group path
settings.path.group=[settings.path.MS_results,filesep,'group',filesep]; %intermediate group output (sample-level prototypes)
if ~isfolder(settings.path.group)
    mkdir(settings.path.group);
end
%participant path
settings.path.participant=[settings.path.MS_results,filesep,'participant',filesep]; %intermediate participant output (participant-level prototypes)
if ~isfolder(settings.path.participant)
    mkdir(settings.path.participant);
end
%session path (if required)
if any(strcmp(settings.backfittingLevels,'session')) %if session level required
    settings.path.session=[settings.path.MS_results,filesep,'session',filesep]; %intermediate session output (session-level prototypes)
    if ~isfolder(settings.path.session)
        mkdir(settings.path.session);
    end
end

%gfp path
settings.path.gfp=[settings.path.MS_results,filesep,'gfp',filesep]; %intermediate gfp output (participant or session)
if ~isfolder(settings.path.gfp)
    mkdir(settings.path.gfp);
end
%backfitting MS_results path
settings.path.backfitting=[settings.path.MS_results,filesep,'backfitting',filesep]; %backfitting output (participant or session levels)
if ~isfolder(settings.path.backfitting)
    mkdir(settings.path.backfitting);
end

%%  Toolbox
settings.path.microstates=[settings.path.eeglab,filesep,'plugins',filesep,'MST1.0', filesep]; %toolbox poulsen
settings.path.microstatesKoenig = [settings.path.eeglab,filesep,'plugins',filesep,'MicrostateAnalysis1.2',filesep,'Microstates1.2', filesep]; %toolbox koenig
settings.path.colormap = [settings.path.project,filesep,'external_files',filesep,'customcolormap',filesep]; %for the microstates plots

%% add paths
addpath(settings.path.src);
addpath(settings.path.eeglab);
addpath(settings.path.microstates);
addpath(settings.path.microstatesKoenig);
addpath(settings.path.colormap);
eeglab;close;

%% Plotting settings
% custom color map (for customized topoplots)
settings.customColorMap.colors = 'red-white-blue';
settings.customColorMap.range = [-0.25 0.25];

%% Data Settings
settings.nGoodSamples = 1000; % minimum number of good samples after excluding bad epochs (10'000 time points = 20 seconds)
settings.sr = 500; % sampling rate

%% Microstates Analysis Settings
settings.microstate = [];
% gfp peak selection settings
settings.microstate.gfppeaks.datatype = 'spontaneous';
settings.microstate.gfppeaks.avgref = 1; %re-reference average
settings.microstate.gfppeaks.normalise = 1; %normalise the channels into z-scores for amplitude and variance uniformity
settings.microstate.gfppeaks.MinPeakDist = 10; %minimum distance between 2 peaks
settings.microstate.gfppeaks.GFPthresh = 1; %peaks above this threshold are considered as noise
settings.microstate.gfppeaks.takeAllPeaks = true; %takes all peaks
settings.microstate.gfppeaks.Npeaks = []; % number of peaks taken (not needed if all peaks taken)

% microstate clustering settings (same settings for all levels)
settings.microstate.algorithm = 'modkmeans';
settings.microstate.sorting = 'Global explained variance'; % first MS is the one explaining the most variance
settings.microstate.normalise = 0;
settings.microstate.Nmicrostates = 4; % range of numbers of microstates, clusters intended (~ range of microstate models)
settings.microstate.verbose = 1;
%% MODIFICATION POUR DEMO ATTENTION
%settings.microstate.Nrepetitions_FirstLevel = 1000 ; %differs from the first level clustering
%settings.microstate.Nrepetitions_OtherLevels = 100 ; %differs from the first level clustering (on GFP)
settings.microstate.Nrepetitions_FirstLevel = 100 ; %differs from the first level clustering
settings.microstate.Nrepetitions_OtherLevels = 10 ; %differs from the first level clustering (on GFP)
%%
settings.microstate.fitmeas = 'CV';
settings.microstate.max_iterations = 1000; 
settings.microstate.threshold = 1e-06;
settings.microstate.optimised = 1;

% how to order the microstate prototypes
settings.microstate.orderingPolarity = 0; %ignore polarity in ordering

% microstate backfitting & temporal smoothing settings
settings.microstate.backfitting.label_type = 'backfit';
% for each sample: one of the 4 microstate prototypes is attributed, then a smoothing per segment is done for the outliers extraction
settings.microstate.backfitting.smooth_type = 'reject segments';
settings.microstate.backfitting.minTime = 30;
settings.microstate.backfitting.polarity = 0;

% which stats to extract
settings.microstate.stats = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'}; %GLOBAL Explained Variance (btw 60 &nd 80 % is good)

end