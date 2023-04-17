function settings = p00_settings(settings)
%% All the required settings for the microstates analysis
%% Preparation: set paths etc.
settings.multipleSessions = false;
if settings.multipleSessions
    settings.levels = {'session','participant','group'}; % please follow this order
else
    settings.levels = {'participant','group'};
end
% carrefull: don't modify levels spelling

%%Source folder
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
%session path (if required)
if any(strcmp(settings.levels,'session')) %if session level
    settings.path.session=[settings.path.results,'session',filesep]; %intermediate session output (session-level prototypes)
    if ~isfolder(settings.path.session)
        mkdir(settings.path.session);
    end
end

%participant path
settings.path.participant=[settings.path.results,'participant',filesep]; %intermediate participant output (participant-level prototypes)
if ~isfolder(settings.path.participant)
    mkdir(settings.path.participant);
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


% paths to scripts, code
%settings.path.src=[settings.path.project,filesep]; % main code
settings.path.functions=[settings.path.src,'functions',filesep]; % subfunctions
settings.path.ext=[settings.path.global_path,filesep,'external_files',filesep]; % external code (toolboxes, plugins)
settings.path.microstates=[settings.path.eeglab,filesep,'plugins',filesep,'MST1.0', filesep]; %toolbox poulsen
settings.path.microstatesKoenig = [settings.path.eeglab,filesep,'plugins',filesep,'Microstates1.2', filesep]; %toolbox koenig
settings.path.colormap = [settings.path.global_path,filesep,'external_files',filesep,'customcolormap',filesep]; % for plotting the microstates

% add paths
addpath(settings.path.src);
addpath(settings.path.functions);
addpath(settings.path.eeglab);
eeglab; close;
addpath(settings.path.microstates);
addpath(settings.path.microstatesKoenig);
addpath(settings.path.colormap)

%% Plotting settings
settings.figure.visible = 'on';

% custom color map (for customized topoplots)
settings.figure.customColorMap = {};
settings.figure.customColorMap.colors = 'red-white-blue';
settings.figure.customColorMap.range = [-0.25 0.25];

settings.data.nGoodSamples = 10000; % minimum number of good samples after excluding bad epochs (10'000 time points = 20 seconds)
settings.sr = 500; % sampling rate

%% Microstates Analysis

settings.microstate = [];
% gfp peak selection settings (within subjects, individual-level)
settings.microstate.gfppeaks.datatype = 'spontaneous';
settings.microstate.gfppeaks.avgref = 1; %re-reference sur la moyenne
settings.microstate.gfppeaks.normalise = 1; %normalise les channel en z-score pour homogÃ©nÃ©itÃ© d'emplitide/variance entre channels
settings.microstate.gfppeaks.MinPeakDist = 10; %dist min entre 2 pics
settings.microstate.gfppeaks.GFPthresh = 1; %ne prend pas comme pic si au-dessus de 1 car considÃ¨re comme bruit
settings.microstate.gfppeaks.takeAllPeaks = true; %prend tous les pics
settings.microstate.gfppeaks.Npeaks = []; % number of peaks taken (not needed if all peaks taken)

% microstate clustering settings
settings.microstate.algorithm = 'modkmeans';
settings.microstate.sorting = 'Global explained variance'; % le microstate 1 est celui qui explique le plus de variance
settings.microstate.normalise = 0;
settings.microstate.Nmicrostates = [3:4]; % range of numbers of microstates, clusters intended (~ range of microstate models)
settings.microstate.verbose = 1;
settings.microstate.Nrepetitions = 100; %differs from the sample-level clustering
settings.microstate.fitmeas = 'CV';
settings.microstate.max_iterations = 1000;
settings.microstate.threshold = 1e-06;
settings.microstate.optimised = 1;

% how to order the microstate prototypes
settings.microstate.ordering.polarity = 0; %ignore polarity in ordering

% microstate backfitting & temporal smoothing settings
settings.microstate.backfitting.label_type = 'backfit';%a chaque point de mesure (sample) on attribue un des 4 micro-etats, puis smoothing par segment pour sortir les outliers
settings.microstate.backfitting.smooth_type = 'reject segments';
settings.microstate.backfitting.minTime = 30;
settings.microstate.backfitting.polarity = 0;

% which stats (features) to extract
settings.microstate.stats = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'}; %GLOBAL Explained Variance (il faut entre 60 et 80%)


end