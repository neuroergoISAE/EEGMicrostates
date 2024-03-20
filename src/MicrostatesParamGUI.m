%% Param Window for MicrostatesGUI
% March 2024 - CH

%%
function [param, cancel] = MicrostatesParamGUI()

backgroundColor = '#344372';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
param_fig = uifigure('Position', [745 200 800 700], 'Color', backgroundColor, 'Icon', 'cerveau.png','WindowStyle','modal','Resize','off');
if isfile(['settings',filesep,'param.mat'])
    load(['settings',filesep,'param.mat']);
    disp(param.path)
    if strcmp(param.name,'')
        param.name = ['Project_',date()];
    end
else
    param = struct();
    param.path.project = '';
    param.dataFormat = '.set';
    param.path.eeglab = 'D:\eeglab\eeglab2023.0';
    param.path.data = '';
    param.name = ['Project_',date()];
end
guidata(param_fig,param);
%% panels
restingState_panel = uipanel(param_fig, 'Position', [20 530 360 150], 'BackgroundColor', backgroundColor,'Title','Resting State Extraction ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
additionalpreproc_panel = uipanel(param_fig, 'Position', [20  280 360 230], 'BackgroundColor', backgroundColor,'Title','Additional Prepocessing ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
gfp_panel= uipanel(param_fig, 'Position', [20 35 360 225], 'BackgroundColor', backgroundColor,'Title','GFP ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
clustering_panel  = uipanel(param_fig, 'Position', [420 380 360 300], 'BackgroundColor', backgroundColor,'Title','Clustering ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfitting_panel = uipanel(param_fig, 'Position', [420  210 360 150], 'BackgroundColor', backgroundColor,'Title','Backfitting ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
metrics_panel = uipanel(param_fig, 'Position', [420 90 360 100], 'BackgroundColor', backgroundColor,'Title','Metrics ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%subpanels
filter_panel = uipanel(additionalpreproc_panel, 'Position', [10 80 340 50], 'BackgroundColor', backgroundColor,'Title','','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%% Resting State Extraction
l_RS = uilabel(restingState_panel,'Position', [10 85 200 20],'HorizontalAlignment','right', 'Text','Extract Restings State : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_RS=  uicheckbox(restingState_panel,'Position',[210 85 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_RSEC = uilabel(restingState_panel,'Position', [10 60 200 20],'HorizontalAlignment','right', 'Text','Eyes Closed Trigger : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSEC = uieditfield(restingState_panel,'Value','RS_EC','Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_RSEC = uilabel(restingState_panel,'Position', [10 35 200 20],'HorizontalAlignment','right', 'Text','Eyes Opened Trigger : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSEC = uieditfield(restingState_panel,'Value','RS_EO','Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_RSEC = uilabel(restingState_panel,'Position', [10 10 200 20],'HorizontalAlignment','right', 'Text','Eyes Opened Trigger : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSEC = uieditfield(restingState_panel,'Value','RS_EO','Position',[210 10 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%% Additional Preprocessing
l_addPreproc = uilabel(additionalpreproc_panel,'Position', [10 160 200 20],'HorizontalAlignment','right', 'Text','Additional Preprocessing : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_addPreproc =  uicheckbox(additionalpreproc_panel,'Position',[210 160 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_averageRef = uilabel(additionalpreproc_panel,'Position', [10 135 200 20],'HorizontalAlignment','right', 'Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_averageRef =  uicheckbox(additionalpreproc_panel,'Position',[210 135 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_lowNotch = uilabel(additionalpreproc_panel,'Position', [10 110 130 20],'HorizontalAlignment','right', 'Text','Low Notch : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_lowNotch = uieditfield(additionalpreproc_panel,'numeric','Value',48,'Position',[140 110 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_highNotch = uilabel(additionalpreproc_panel,'Position', [180 110 130 20],'HorizontalAlignment','right', 'Text','High Notch : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_highNotch = uieditfield(additionalpreproc_panel,'numeric','Value',52,'Position',[310 110 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_lowPb = uilabel(additionalpreproc_panel,'Position', [10 85 130 20],'HorizontalAlignment','right', 'Text','Low Pass Band : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_lowPb = uieditfield(additionalpreproc_panel,'numeric','Value',2,'Position',[140 85 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_highPb = uilabel(additionalpreproc_panel,'Position',[180 85 130 20],'HorizontalAlignment','right', 'Text','High Pass Band : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_highPb = uieditfield(additionalpreproc_panel,'numeric','Value',20,'Position',[310 85 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
ef_highPb = uieditfield(filter_panel,'numeric','Value',20,'Position',[10 10 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);


l_mvMax = uilabel(additionalpreproc_panel,'Position', [10 60 200 20],'HorizontalAlignment','right', 'Text','Maximum mV : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_mvMax = uieditfield(additionalpreproc_panel,'numeric','Value',90,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_nGoodSample = uilabel(additionalpreproc_panel,'Position', [10 35 200 20],'HorizontalAlignment','right', 'Text','Number of Good Sample : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nGoodSample = uieditfield(additionalpreproc_panel,'numeric','Value',1000,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_SampleRate = uilabel(additionalpreproc_panel,'Position', [10 10 200 20],'HorizontalAlignment','right', 'Text','Sampling Rate : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_sampleRate = uieditfield(additionalpreproc_panel,'numeric','Value',512,'Position',[210 10 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);


%% GFP
l_gfpType = uilabel(gfp_panel,'Position', [10 160 200 20],'HorizontalAlignment','right','Text','GFP Data Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_gfpType = uidropdown(gfp_panel,'Items', {'spontaneous', 'others'},'Value','spontaneous','Position',[210 160 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_averageRef = uilabel(gfp_panel,'Position', [10 135 200 20],'HorizontalAlignment','right','Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_averageRef = uicheckbox(gfp_panel,'Position',[210 135 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_GFPnormalise = uilabel(gfp_panel,'Position', [10 110 200 20],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFPnormalise = uicheckbox(gfp_panel,'Position',[210 110 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_minPeakDist = uilabel(gfp_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','Mean Peak Distance : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minPeakDist = uieditfield(gfp_panel,'numeric','Value',10,'Position',[210 85 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_GFPthreshold = uilabel(gfp_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Threshold : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_GFPthreshold = uieditfield(gfp_panel,'numeric','Value',1,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_allPeaks = uilabel(gfp_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Take all Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_allPeaks = uicheckbox(gfp_panel,'Position',[210 35 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_nbPeaks= uilabel(gfp_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Number of Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_nbPeaks = uicheckbox(gfp_panel,'Position',[210 10 40 20],'Value',1,'Text','all','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbPeaks = uieditfield(gfp_panel,'numeric','Value',0,'Position',[255 10 70 20],'Enable','off','HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%% Clustering
l_algorithm = uilabel(clustering_panel,'Position', [10 235 200 20],'HorizontalAlignment','right','Text','Clustering Algorithm : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_algorithm = uidropdown(clustering_panel,'Items', {'k-means', 'others'},'Value','k-means','Position',[210 235 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_sorting = uilabel(clustering_panel,'Position', [10 210 200 20],'HorizontalAlignment','right','Text','Sorting : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_sorting = uidropdown(clustering_panel,'Items', {'GEV', 'others'},'Value','GEV','Position',[210 210 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_normalise = uilabel(clustering_panel,'Position', [10 210 200 20],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_normalise = uicheckbox(clustering_panel,'Position',[210 210 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_nbMS = uilabel(clustering_panel,'Position', [10 185 200 20],'HorizontalAlignment','right','Text','Number of Microstates : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbMS = uieditfield(clustering_panel,'Value','4','Position',[210 185 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_verbose = uilabel(clustering_panel,'Position', [10 160 200 20],'HorizontalAlignment','right','Text','Verbose : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_verbose = uicheckbox(clustering_panel,'Position',[210 160 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_nbRep = uilabel(clustering_panel,'Position', [10 160 200 20],'HorizontalAlignment','right','Text','Number of repetion  ','FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepFirst = uilabel(clustering_panel,'Position', [10 135 110 20],'HorizontalAlignment','right','Text','First Level : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepFirst = uieditfield(clustering_panel,'numeric','Value',1000,'Position',[120 135 50 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepOther = uilabel(clustering_panel,'Position', [170 135 120 20],'HorizontalAlignment','right','Text','Other Level(s) : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepOther = uieditfield(clustering_panel,'numeric','Value',100,'Position',[290 135 50 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_fitMeans = uilabel(clustering_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','FitMeans : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_fitMeans = uidropdown(clustering_panel,'Items', {'CV', 'others'},'Value','CV','Position',[210 85 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_maxIterations = uilabel(clustering_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Max iterations: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_maxIteration = uieditfield(clustering_panel,'numeric','Value',1000,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_threshold = uilabel(clustering_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Threshold: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_threshold = uieditfield(clustering_panel,'numeric','Value',0.000001,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_optimize = uilabel(clustering_panel,'Position', [10 120 200 20],'HorizontalAlignment','right','Text','Optimize : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_optimize = uicheckbox(clustering_panel,'Position',[210 120 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_polarity = uilabel(clustering_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_polarity = uicheckbox(clustering_panel,'Position',[210 10 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);


%% Backfitting
l_labelType = uilabel(backfitting_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','Backfitting Label : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_labelType = uidropdown(backfitting_panel,'Items', {'backfit', 'others'},'Value','backfit','Position',[210 85 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_smoothType = uilabel(backfitting_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_smoothType = uidropdown(backfitting_panel,'Items', {'reject-segment', 'others'},'Value','reject-segment','Position',[210 60 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_minTime = uilabel(backfitting_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minTime = uieditfield(backfitting_panel,'numeric','Value',30,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_BackfitPolarity= uilabel(backfitting_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_BackfitPolarity = uicheckbox(backfitting_panel,'Position',[210 10 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

%% Metrics
l_labelGEVTot =  uilabel(metrics_panel,'Position', [10 35 90 20],'HorizontalAlignment','right','Text','Total GEV : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEVTot = uicheckbox(metrics_panel,'Position',[110 35 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelGEV =  uilabel(metrics_panel,'Position', [120 35 90 20],'HorizontalAlignment','right','Text','GEV : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEV = uicheckbox(metrics_panel,'Position',[150 35 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelGFP =  uilabel(metrics_panel,'Position', [160 35 90 20],'HorizontalAlignment','right','Text','GFP : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFP = uicheckbox(metrics_panel,'Position',[190 35 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelMSParCorr =  uilabel(metrics_panel,'Position', [230 35 90 20],'HorizontalAlignment','right','Text','Correlation : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_MSParCorr = uicheckbox(metrics_panel,'Position',[330 35 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelOccurence =  uilabel(metrics_panel,'Position', [10 10 100 20],'HorizontalAlignment','right','Text','Occurence : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_Occurence = uicheckbox(metrics_panel,'Position',[110 10 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelDuration =  uilabel(metrics_panel,'Position', [120 10 100 20],'HorizontalAlignment','right','Text','Duration : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_Duration = uicheckbox(metrics_panel,'Position',[220 10 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_labelCoverage =  uilabel(metrics_panel,'Position', [230 10 100 20],'HorizontalAlignment','right','Text','Coverage : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_Coverage = uicheckbox(metrics_panel,'Position',[330 10 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

end