%% Default settings for MicrostatesGUI

function [default] = defaultsettings()
    default = struct();

    default.name = ['Project_' date()];
    default.path.data ='';
    default.dataformat = '.mat';
    default.path.project = '';
    default.path.eeflab ='D:\eeglab\eeglab2023.0';
    %% Additional Pre-processing
    default.preproc.avgref = true; %Additional average re-reference
    default.preproc.notch.low = 48; %Low noch filter
    default.preproc.notch.high = 52; %High notch filter
    default.preproc.bandpass.low = 2; %Low band-pass filter
    default.preproc.bandpass.high = 20; %High band-pass filter
    default.preproc.mvmax = 90; %Maximun mV for data cleaning
    default.preproc.EClabel = 'RS_EC'; %Resting state closed eyes trigger label
    default.preproc.EOlabel = 'RS_EO'; %Resting state opened eyes trigger label
    default.preproc.timelimits = [0 30]; %Resting state duration

    %%
    default.nGoodSamples = 1000; %Minimum number of good sample per epoch
    default.sr = 512; % Sampling Rate

    %% Microstates
    default.microstates.Nmicrostates = '[4 5]';
    % GFP
    %default.microstate.gfp.datatype = 'spontaneaous'; %or : 'ERPavg','ERPconc', 'ERPconc'.
    default.microstate.gfp.avgref = true; %Additional average re-reference
    default.microstate.gfp.normalise = true; %Normalise channels into zscores for amplitude and variance uniformity
    default.microstate.gfp.MinPeakDist = 10; %Minimum distance between two peaks (ms)
    default.microstate.gfp.GFPthresh = 1; %Peaks above this threshold are considered as noise
    default.microstate.gfp.takeallpeaks = true; %Inclue all GFP peaks
    default.microstate.gfp.Npeaks = []; %Included number of peaks, if [] all peaks taken
    default.microstate.gfp.datatype = 'spontaneous';
    %Clustering
    default.microstate.verbose = 1;
    default.microstate.normalise = 0;
    default.microstate.algorithm = 'modkmeans'; %or : 'kmeans','taahc','aahc','varmicro'
    default.microstate.sorting = 'Global explained variance'; %Microstates initial ordering or :'Global explained variance','Chronological appearance','Frequency'
    default.microstate.Nrepfirstlevel = 1000; %Number of algorithm repetitions for the first level (on GFP)
    default.microstate.Nrepotherlevel = 100;  %Number of algorithm repetitions for the other levels
    default.microstate.fitmeas = 'CV'; %Readying measure of fit for selecting best segmentation
    default.microstate.max_iterations = 1000;
    default.microstate.threshold = 1e-06;
    default.microstate.orderingpolarity = true;
    default.microstate.optimised = 1;
    %Backfitting
    default.microstate.backfitting.labeltype = 'backfit'; % or 'segmentation'
    default.microstate.backfitting.smoothtype = 'reject segments'; % or : 'windowed'
    default.microstate.backfitting.mintime = 30;
    default.microstate.backfitting.polarity = false; 
    %Metrics
    default.microstate.metrics = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'}; %Extracted microstates metrics
    % Plot param
    default.customColorMap.colors = 'red-white-blue';% custom color map (for customized topoplots)
    default.customColorMap.range = [-0.25 0.25];
    
    %TODO
    default.todo.RS = false;
    default.todo.addpreproc = false;
    default.todo.override = true; % Flag indicating whether to override old outputs
    default.todo.load_data = true; % Flag indicating whether to load data
    default.todo.microstates_gfppeaks = true; % Flag indicating whether to perform GFP peaks analysis
    default.todo.microstates_segmentation = true; % Flag indicating whether to perform microstates segmentation
    default.todo.microstates_reordering = true; % Flag indicating whether to perform microstates reordering
    default.todo.microstates_backfitting = true; % Flag indicating whether to perform microstates backfitting
    default.todo.microstates_stats = true; % Flag indicating whether to perform microstates statistics

end