function settings = p00_settings(paramgui)
%% All the required settings for the microstates analysis


%% ParamGUI if required
if paramgui
    [param ,~] = paramGUI;
    settings  = param; 
else
    settings.todo.eyes_epoching = false;
    settings.multipleSessions = false;
    settings.name = ['Project_',date()];
    settings.path.global_path = fileparts(pwd);
    settings.path.eeglab = ['D:\eeglab\eeglab2023.0'];%% EEGLAB LOCATION 
end
%% Preparation: set paths etc.
if settings.multipleSessions
    settings.levels = {'session','participant','group'}; % please follow this order
else
    settings.levels = {'participant','group'};
end
% carrefull: don't modify levels spelling

%% Source folder
settings.path.results = [settings.path.global_path,filesep,settings.name,filesep,'Microstates_Results',filesep]; %Microstates Results
settings.path.src = [settings.path.global_path,filesep,'src',filesep]; % main code% Project path containig main code
cd(settings.path.src);
if ~isfolder(settings.path.results)
    mkdir(settings.path.results);
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
if any(strcmp(settings.levels,'session')) %if session level
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
settings.path.microstatesKoenig = [settings.path.eeglab,filesep,'plugins',filesep,'Microstates1.2', filesep]; %toolbox koenig
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
settings.nGoodSamples = 10000; % minimum number of good samples after excluding bad epochs (10'000 time points = 20 seconds)
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
settings.microstate.Nmicrostates = [3:4]; % range of numbers of microstates, clusters intended (~ range of microstate models)
settings.microstate.verbose = 1;
settings.microstate.Nrepetitions_GFP = 1000 ;%1000; %differs from the first level clustering
settings.microstate.Nrepetitions_Cluster = 100 ;%differs from the first level clustering (on GFP)
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