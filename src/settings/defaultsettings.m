%% Default settings for MicrostatesGUI

function [default] = defaultsettings()
    default = struct();

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
    default.ngoodsamples = 1000; %Minimum number of good sample per epoch
    default.sr = 512; % Sampling Rate

    %% Microstates
    % GFP
    %default.microstate.gfp.datatype = 'spontaneaous'; %or : 'ERPavg','ERPconc', 'ERPconc'.
    default.microstate.gfp.avgref = true; %Additional average re-reference
    default.microstate.gfp.normalise = true; %Normalise channels into zscores for amplitude and variance uniformity
    default.microstate.gfp.minpeakdist = 10; %Minimum distance between two peaks (ms)
    default.microstate.gfp.gfpthreshold = 1; %Peaks above this threshold are considered as noise
    default.microstate.gfp.takeallpeaks = true; %Inclue all GFP peaks
    default.microstate.gfp.Npeaks = []; %Included number of peaks, if [] all peaks taken
    %Clustering
    default.microstate.algorithm = 'modkmeans'; %or : 'kmeans','taahc','aahc','varmicro'
    default.microstate.sorting = 'Global explained variance'; %Microstates initial ordering or :'Global explained variance','Chronological appearance','Frequency'
    default.microstate.Nrepfirstlevel = 1000; %Number of algorithm repetitions for the first level (on GFP)
    default.microstate.Nrepotherlevel = 100;  %Number of algorithm repetitions for the other levels
    %default.microstate.fitmeas = 'CV'; %Readying measure of fit for selecting best segmentation
    default.microstate.maxiteration = 1000;
    default.microstate.threshold = 1e-06;
    default.microstate.orderingpolarity = true;
    %Backfitting
    default.microstate.backfitting.labeltype = 'backfit'; % or 'segmentation'
    default.microstate.backfitting.smoothtype = 'reject-segment'; % or : 'windowed'
    default.microstate.backfitting.mintime = 30;
    default.microstate.backfitting.polarity = false; 
    %Metrics
    default.microstate.metrics = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'}; %Extracted microstates metrics
end