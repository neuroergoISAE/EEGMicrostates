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
epoching_panel = uipanel(param_fig, 'Position', [20 580 360 100], 'BackgroundColor', backgroundColor,'Title','Epoching ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
clustering_panel  = uipanel(param_fig, 'Position', [20 100 360 460], 'BackgroundColor', backgroundColor,'Title','Clustering ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
gfp_panel= uipanel(param_fig, 'Position', [420 440 360 240], 'BackgroundColor', backgroundColor,'Title','GFP ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfitting_panel = uipanel(param_fig, 'Position', [420  220 360 200], 'BackgroundColor', backgroundColor,'Title','Backfitting ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
metrics_panel = uipanel(param_fig, 'Position', [420 100 360 100], 'BackgroundColor', backgroundColor,'Title','Metrics ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%% Epoching
l_nGoodSample = uilabel(epoching_panel,'Position', [10 35 200 20],'HorizontalAlignment','right', 'Text','Number of Good Sample : ','FontSize',fontsize,'FontColor',foregroundColor);
nGoodSample = uieditfield(epoching_panel,'numeric','Value',1000,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_SampleRate = uilabel(epoching_panel,'Position', [10 10 200 20],'HorizontalAlignment','right', 'Text','Sampling Rate : ','FontSize',fontsize,'FontColor',foregroundColor);
sampleRate = uieditfield(epoching_panel,'numeric','Value',512,'Position',[210 10 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%% Clustering
l_algorithm = uilabel(clustering_panel,'Position', [10 395 200 20],'HorizontalAlignment','right','Text','Clustering Algorithm : ','FontSize',fontsize,'FontColor',foregroundColor);
algorithm = uidropdown(clustering_panel,'Items', {'k-means', 'others'},'Value','k-means','Position',[210 395 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);


%% GFP
l_gfpType = uilabel(gfp_panel,'Position', [10 175 200 20],'HorizontalAlignment','right','Text','GFP Data Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_gfpType = uidropdown(gfp_panel,'Items', {'spontaneous', 'others'},'Value','spontaneous','Position',[210 175 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_averageRef = uilabel(gfp_panel,'Position', [10 150 200 20],'HorizontalAlignment','right','Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_averageRef = uicheckbox(gfp_panel,'Position',[210 150 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_normalise = uilabel(gfp_panel,'Position', [10 125 200 20],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_normalise = uicheckbox(gfp_panel,'Position',[210 125 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_minPeakDist = uilabel(gfp_panel,'Position', [10 100 200 20],'HorizontalAlignment','right','Text','Mean Peak Distance : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minPeakDist = uieditfield(gfp_panel,'numeric','Value',10,'Position',[210 100 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_threshold = uilabel(gfp_panel,'Position', [10 75 200 20],'HorizontalAlignment','right','Text','Threshold : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_threshold = uieditfield(gfp_panel,'numeric','Value',1,'Position',[210 75 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_allPeaks = uilabel(gfp_panel,'Position', [10 50 200 20],'HorizontalAlignment','right','Text','Take all Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_allPeaks = uicheckbox(gfp_panel,'Position',[210 50 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_nbPeaks= uilabel(gfp_panel,'Position', [10 25 200 20],'HorizontalAlignment','right','Text','Number of Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_nbPeaks = uicheckbox(gfp_panel,'Position',[210 25 40 20],'Value',1,'Text','all','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbPeaks = uieditfield(gfp_panel,'numeric','Value',0,'Position',[255 25 70 20],'Enable','off','HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%% Backfitting
l_labelType = uilabel(backfitting_panel,'Position', [10 135 200 20],'HorizontalAlignment','right','Text','Backfitting Label : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_labelType = uidropdown(backfitting_panel,'Items', {'backfit', 'others'},'Value','backfit','Position',[210 135 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_smoothType = uilabel(backfitting_panel,'Position', [10 110 200 20],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_smoothType = uidropdown(backfitting_panel,'Items', {'reject-segment', 'others'},'Value','reject-segment','Position',[210 110 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_minTime = uilabel(backfitting_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minTime = uieditfield(backfitting_panel,'numeric','Value',30,'Position',[210 85 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_polarity= uilabel(backfitting_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_polarity = uicheckbox(backfitting_panel,'Position',[210 60 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

end




