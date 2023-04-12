function settings = p00_settings(settings)
%% All the required settings for the microstates analysis
%% Preparation: set paths etc.
settings.multipleSessions = true;
settings.levels = {'session','participant','group'}; % please follow this order

%%Source folder
settings.path.src = [settings.path.global_path,'\src\']; % main code% Project path containig main code
cd(settings.path.src);
if ~isfolder(settings.path.results)
    mkdir(settings.path.results);
end

%% All results folders
%tables path
settings.path.tables=[settings.path.results,'tables',filesep]; %mat tables with final features
if ~isfolder(settings.path.tables)
    mkdir(settings.path.tables);
end
%csv results path
settings.path.csv=[settings.path.results,'csv',filesep]; %csv files with final features
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
settings.path.microstates=[settings.path.eeglab,'plugins',filesep,'MST1.0', filesep]; %toolbox poulsen
settings.path.microstatesKoenig = [settings.path.eeglab,'plugins',filesep,'Microstates1.2', filesep]; %toolbox koenig
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

%% do average re-referencing
settings.averageref = 0; % DEJA FAIT DANS LE PREPROCESSING

%% data segmentation (used in p01_load_segment_data)
%   settings.segment = {};
%   settings.segment.fun = 'restingsegment';
%   settings.segment.path = {};
%   settings.segment.eyesclosed.events = 'EC'; % eyes-closed events
%   settings.segment.eyesclosed.timelimits = [0 30]; % cut out the first 30 seconds of each epoch (the last 10 seconds = transition period)

% %   settings.segment.eyesopen.events = 'RC_EO'; % eyes-open events
% %   settings.segment.eyesopen.timelimits = [??]; % cut out 1 sec at the onset and 1 sec before the end

%% further data (pre-)processing (used in p01_load_segment_data)
%   settings.spectro = {};
%   settings.spectro.fun = 'restingspectro';
%   settings.spectro.path = {};
%   settings.spectro.sr = 500; % sampling rate
%   % settings for the filtering
%   settings.spectro.notch.lpf = 48;
%   settings.spectro.notch.hpf = 52;
%   settings.spectro.bandpass.lpf = 2;
%   settings.spectro.bandpass.hpf = 20;
%   % settings to exclude data epochs exceeding a certain amplitude threshold
%   settings.spectro.winlength = 1000; % = 2 Seconds
%   settings.spectro.timelimits = [0 1000]; % 0 to 2 Seconds
%   settings.spectro.mvmax = 90; % maximum millivoltage to clean data
%
%   % ?? needed
%   settings.spectro.fbands = {};
%   settings.spectro.doplot= 1;

%% some basic requirements of the data
%   settings.data.checkqualityratings = true; % set to false if automagic was not used to pre-process the data
%   if settings.data.checkqualityratings
%   settings.data.qualityratings = {'g','o'}; % suffcient automagic rating
%   end
settings.data.nGoodSamples = 10000; % minimum number of good samples after excluding bad epochs (10'000 time points = 20 seconds)

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

% microstate clustering settings on the individual-level
settings.microstate.indivSegmentation.algorithm = 'modkmeans';
settings.microstate.indivSegmentation.sorting = 'Global explained variance'; % le microstate 1 est celui qui explique le plus de variance
settings.microstate.indivSegmentation.normalise = 0;
settings.microstate.indivSegmentation.Nmicrostates = [3:4]; % range of numbers of microstates, clusters intended (~ range of microstate models)
settings.microstate.indivSegmentation.verbose = 1;
settings.microstate.indivSegmentation.Nrepetitions = 100; %differs from the sample-level clustering
settings.microstate.indivSegmentation.fitmeas = 'CV';
settings.microstate.indivSegmentation.max_iterations = 1000;
settings.microstate.indivSegmentation.threshold = 1e-06;
settings.microstate.indivSegmentation.optimised = 1;

% microstate clustering settings on the sample-level (used in p03_01_microstates_sampleSegmentation
settings.microstate.sampleSegmentation.algorithm = 'modkmeans';
settings.microstate.sampleSegmentation.sorting = 'Global explained variance';
settings.microstate.sampleSegmentation.normalise = 0;
settings.microstate.sampleSegmentation.Nmicrostates = [3:4];
settings.microstate.sampleSegmentation.verbose = 1;
settings.microstate.sampleSegmentation.Nrepetitions = 1000; %differs from the individual clustering
settings.microstate.sampleSegmentation.fitmeas = 'CV';
settings.microstate.sampleSegmentation.max_iterations = 1000;
settings.microstate.sampleSegmentation.threshold = 1e-06;
settings.microstate.sampleSegmentation.optimised = 1 ;

% how to order the microstate prototypes
settings.microstate.ordering.polarity = 0; %ignore polarity in ordering

% microstate backfitting & temporal smoothing settings
settings.microstate.backfitting.label_type = 'backfit';%a chaque point de mesure (sample) on attribue un des 4 micro-etats, puis smoothing par segment pour sortir les outliers
settings.microstate.backfitting.smooth_type = 'reject segments';
settings.microstate.backfitting.minTime = 30;
settings.microstate.backfitting.polarity = 0;
settings.microstate.backfitting.Nmicrostates = [3:4];

% which stats (features) to extract
settings.microstate.stats = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'}; %GLOBAL Explained Variance (il faut entre 60 et 80%)


end