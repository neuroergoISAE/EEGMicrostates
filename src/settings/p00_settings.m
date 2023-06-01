 function settings = p00_settings(s)
%% All the required settings for the microstates analysis
settings = s;
%% if already existing settings in settings folder : load and  prefill the gui
%% ParamGUI if required
if settings.todo.paramgui
    [param ,~] = paramGUI;
    settings  = param; 
    settings.todo = s.todo; 
    settings.todo.eyes_epoching  = param.todo.eyes_epoching;
    settings.path.src = pwd;

%     if param settings not complete !
%     disp('Reopen Parameters GUI?') %yes :open param, no : stop anaylsis
%     here
else
    settings.path.src = pwd;
    settings.todo.eyes_epoching = true; % default : eyes epoching already done
    settings.multipleSessions = 0; % default: no sessions 
    settings.name =['Project_',date()]; % default name
    settings.path.src = pwd;  % source code folder, default : pwd
    settings.path.global_path = fileparts(settings.path.src);

    if settings.multipleSessions
        settings.backfittingLevels  = {'session','participant','group'}; %default : backfit on all levels
    else
        settings.backfittingLevels  = {'participant','group'}; %default : backfit on all levels
    end
    settings.path.eeglab = 'D:\eeglab\eeglab2023.0'; %% EEGLAB LOCATION         
    if  settings.todo.eyes_epoching
        settings.path.datatoepoch =  'E:\ACERI\Microstates\Quentin\Data_Epoch';% insert data to epoch location
        settings.epoching.triggerlabel = 'RS_EC';
        settings.epoching.timelimits = [0 30];
    else
        settings.path.data = 'E:\ACERI\Microstates\Quentin\EpochedData'; %[settings.path.global_path,filesep,settings.name,filesep,'Data_Microstates',filesep];  
    end

end

%% Preparation: set paths etc.
% levels ~= backfittingLevels (can be different: all levels will always be computed for the segmentation while the backfitting can be done on only a few of them if required)
if settings.multipleSessions
    settings.levels = {'session','participant','group'}; % please follow this order
else
    settings.levels = {'participant','group'};
end
% carrefull: don't modify levels spelling

%% Source folder
settings.path.global_path = fileparts(settings.path.src);
settings.path.results = [settings.path.global_path,filesep,settings.name,filesep,'Microstates_Results',filesep]; %Microstates Results
cd(settings.path.src);
if ~isfolder(settings.path.results)
    mkdir(settings.path.results);
end

if  settings.todo.eyes_epoching
    % settings for the filtering
    settings.epoching.averageref = false; 
    settings.epoching.notch.lpf = 48; 
    settings.epoching.notch.hpf = 52; 
    settings.epoching.bandpass.lpf = 2;
    settings.epoching.bandpass.hpf = 20; 
    settings.epoching.winlength = 1000; %2 seconds
    settings.epoching.mvmax = 90; % maximum millivoltage to clean data
    settings.epoching.spectro.timelimits = [0 1000];
    settings.path.data = [settings.path.global_path,filesep,settings.name,filesep,'EpochedData']; %Epoched Data Location
        if ~isfolder(settings.path.data)
            mkdir(settings.path.data);
        end
end

%% All results folders
%tables path
settings.path.tables=[settings.path.results,'stats',filesep,'tables',filesep]; %mat tables with final features
if ~isfolder(settings.path.tables)
    mkdir(settings.path.tables);
end
%csv results path
settings.path.csv=[settings.path.results,'stats',filesep,'csv',filesep]; %csv files with final features
if ~isfolder(settings.path.csv)
    mkdir(settings.path.csv);
end
%group path
settings.path.group=[settings.path.results,'group',filesep]; %intermediate group output (sample-level prototypes)
if ~isfolder(settings.path.group)
    mkdir(settings.path.group);
end
%participant path
settings.path.participant=[settings.path.results,'participant',filesep]; %intermediate participant output (participant-level prototypes)
if ~isfolder(settings.path.participant)
    mkdir(settings.path.participant);
end
%session path (if required)
if any(strcmp(settings.backfittingLevels,'session')) %if session level
    settings.path.session=[settings.path.results,'session',filesep]; %intermediate session output (session-level prototypes)
    if ~isfolder(settings.path.session)
        mkdir(settings.path.session);
    end
end

%gfp path
settings.path.gfp=[settings.path.results,'gfp',filesep]; %intermediate gfp output (participant or session)
if ~isfolder(settings.path.gfp)
    mkdir(settings.path.gfp);
end
%backfitting results path
settings.path.backfitting=[settings.path.results,'backfitting',filesep]; %backfitting output (participant or session levels)
if ~isfolder(settings.path.backfitting)
    mkdir(settings.path.backfitting);
end
%%  Toolbox
settings.path.microstates=[settings.path.eeglab,filesep,'plugins',filesep,'MST1.0', filesep]; %toolbox poulsen
settings.path.microstatesKoenig = [settings.path.eeglab,filesep,'plugins',filesep,'MicrostateAnalysis1.2',filesep,'Microstates1.2', filesep]; %toolbox koenig
settings.path.colormap = [settings.path.global_path,filesep,'external_files',filesep,'customcolormap',filesep]; % for plotting the microstates

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

%% Microstates Settings

settings.microstate = [];
% gfp peak selection settings
settings.microstate.gfppeaks.datatype = 'spontaneous';
settings.microstate.gfppeaks.avgref = 1; %re-reference sur la moyenne
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
settings.microstate.Nrepetitions_FirstLevel = 1000 ;%1000; %differs from the first level clustering
settings.microstate.Nrepetitions_OtherLevels = 100 ;%differs from the first level clustering (on GFP)
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