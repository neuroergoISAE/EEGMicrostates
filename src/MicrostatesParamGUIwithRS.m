%% Param Window for MicrostatesGUI
% March 2024 - CH
function [settings, cancel] = MicrostatesParamGUI(settings)

default =defaultsettings();

backgroundColor = '#344372';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
settings_fig = uifigure('Position', [745 200 800 700], 'Color', backgroundColor, 'Icon', 'external_files/cerveau.png','WindowStyle','modal','Resize','off');
% if isfile(['settings',filesep,'settings.mat'])
%     load(['settings',filesep,'settings.mat']);
%     disp(settings.path)
%     if strcmp(settings.name,'')
%         settings.name = ['Project_',date()];
%     end
% else
%     settings = struct();
%     settings.path.project = '';
%     settings.dataFormat = '.set';
%     settings.path.eeglab = 'D:\eeglab\eeglab2023.0';
%     settings.path.data = '';
%     settings.name = ['Project_',date()];
% end
%settings = struct();
guidata(settings_fig,settings);
%% panels
restingState_panel = uipanel(settings_fig, 'Position', [20 520 360 170], 'BackgroundColor', backgroundColor,'Title','Resting State Extraction ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
additionalpreproc_panel = uipanel(settings_fig, 'Position', [20  270 360 230], 'BackgroundColor', backgroundColor,'Title','Additional Prepocessing ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
gfp_panel= uipanel(settings_fig, 'Position', [20 35 360 215], 'BackgroundColor', backgroundColor,'Title','GFP ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
clustering_panel  = uipanel(settings_fig, 'Position', [420 390 360 300], 'BackgroundColor', backgroundColor,'Title','Clustering ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfitting_panel = uipanel(settings_fig, 'Position', [420  210 360 150], 'BackgroundColor', backgroundColor,'Title','Backfitting ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
metrics_panel = uipanel(settings_fig, 'Position', [420 90 360 100], 'BackgroundColor', backgroundColor,'Title','Metrics ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%subpanels
RStrigger_panel =  uipanel(restingState_panel, 'Position', [10 40 340 55], 'BackgroundColor', backgroundColor,'Title','','FontSize',fontsize,'ForegroundColor', foregroundColor);
filter_panel = uipanel(additionalpreproc_panel, 'Position', [10 85 340 55], 'BackgroundColor', backgroundColor,'Title','','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
repetition_panel = uipanel(clustering_panel, 'Position', [10 120 340 55], 'BackgroundColor', backgroundColor,'Title','','FontSize',fontsize+2,'ForegroundColor', foregroundColor);


%% Resting State Extraction
l_RS = uilabel(restingState_panel,'Position', [10 110 200 20],'HorizontalAlignment','right', 'Text','Extract Restings State : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_RS=  uicheckbox(restingState_panel,'Position',[210 110 20 20],'Value',settings.todo.RS,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event)Enable_RS(cbx));

l_RStriggerlabel = uilabel(restingState_panel,'Position', [25 85 120 20], 'BackgroundColor', backgroundColor,'HorizontalAlignment','center', 'Text','Trigger Label','FontSize',fontsize,'FontColor',foregroundColor);

l_RSEC = uilabel(RStrigger_panel,'Position', [5 15 100 20],'HorizontalAlignment','right', 'Text','Close eyes : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSEC = uieditfield(RStrigger_panel,'Value',settings.preproc.EClabel,'Position',[105 15 60 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_RSEO = uilabel(RStrigger_panel,'Position', [155 15 110 20],'HorizontalAlignment','right', 'Text','Open eyes : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSEO = uieditfield(RStrigger_panel,'Value',settings.preproc.EOlabel,'Position',[265 15 60 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_RSLatency = uilabel(restingState_panel,'Position', [10 10 200 20],'HorizontalAlignment','right', 'Text','Eyes Opened Latency  : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_RSLatencystart = uieditfield(restingState_panel,'numeric','Value',settings.preproc.timelimits(1),'Position',[210 10 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);
ef_RSLatencyend = uieditfield(restingState_panel,'numeric','Value',settings.preproc.timelimits(2),'Position',[250 10 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

%% Additional Preprocessing
l_addPreproc = uilabel(additionalpreproc_panel,'Position', [10 170 200 20],'HorizontalAlignment','right', 'Text','Additional Preprocessing : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_addPreproc =  uicheckbox(additionalpreproc_panel,'Position',[210 170 20 20],'Value',settings.todo.addpreproc,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event)Enable_Preproc(cbx));

l_averageRef = uilabel(additionalpreproc_panel,'Position', [10 145 200 20],'HorizontalAlignment','right', 'Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_averageRef =  uicheckbox(additionalpreproc_panel,'Position',[210 145 20 20],'Value',settings.preproc.avgref,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_lowNotch = uilabel(filter_panel,'Position', [5 30 130 20],'HorizontalAlignment','right', 'Text','Low Notch : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_lowNotch = uieditfield(filter_panel,'numeric','Value',settings.preproc.notch.low,'Position',[135 30 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_highNotch = uilabel(filter_panel,'Position', [175 30 130 20],'HorizontalAlignment','right', 'Text','High Notch : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_highNotch = uieditfield(filter_panel,'numeric','Value',settings.preproc.notch.high,'Position',[305 30 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_lowPb = uilabel(filter_panel,'Position', [5 5 130 20],'HorizontalAlignment','right', 'Text','Low Pass Band : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_lowPb = uieditfield(filter_panel,'numeric','Value',settings.preproc.bandpass.low,'Position',[135 5 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_highPb = uilabel(filter_panel,'Position',[175 5 130 20],'HorizontalAlignment','right', 'Text','High Pass Band : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_highPb = uieditfield(filter_panel,'numeric','Value',settings.preproc.bandpass.high,'Position',[305 5 30 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);


l_mvMax = uilabel(additionalpreproc_panel,'Position', [10 60 200 20],'HorizontalAlignment','right', 'Text','Maximum mV : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_mvMax = uieditfield(additionalpreproc_panel,'numeric','Value',settings.preproc.mvmax,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_nGoodSample = uilabel(additionalpreproc_panel,'Position', [10 35 200 20],'HorizontalAlignment','right', 'Text','Number of Good Sample : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nGoodSample = uieditfield(additionalpreproc_panel,'numeric','Value',settings.nGoodSamples,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);

l_SampleRate = uilabel(additionalpreproc_panel,'Position', [10 10 200 20],'HorizontalAlignment','right', 'Text','Sampling Rate : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_sampleRate = uieditfield(additionalpreproc_panel,'numeric','Value',settings.sr,'Position',[210 10 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'Enable',false);


%% GFP
%l_gfpType = uilabel(gfp_panel,'Position', [10 160 200 20],'HorizontalAlignment','right','Text','GFP Data Type : ','FontSize',fontsize,'FontColor',foregroundColor);
%dd_gfpType = uidropdown(gfp_panel,'Items', {'spontaneous', 'others'},'Value','spontaneous','Position',[210 160 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_gfpaverageRef = uilabel(gfp_panel,'Position', [10 135 200 20],'HorizontalAlignment','right','Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_gfpaverageRef = uicheckbox(gfp_panel,'Position',[210 135 20 20],'Value',settings.microstate.gfp.avgref,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_GFPnormalise = uilabel(gfp_panel,'Position', [10 110 200 20],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFPnormalise = uicheckbox(gfp_panel,'Position',[210 110 20 20],'Value',settings.microstate.gfp.normalise,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_minPeakDist = uilabel(gfp_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','Mean Peak Distance : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minPeakDist = uieditfield(gfp_panel,'numeric','Value',settings.microstate.gfp.MinPeakDist,'Position',[210 85 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_GFPthreshold = uilabel(gfp_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Threshold : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_GFPthreshold = uieditfield(gfp_panel,'numeric','Value',settings.microstate.gfp.GFPthresh,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_allPeaks = uilabel(gfp_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Take all Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_allPeaks = uicheckbox(gfp_panel,'Position',[210 35 20 20],'Value',settings.microstate.gfp.takeallpeaks,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event)Enable_Npeaks(cbx));

l_nbPeaks= uilabel(gfp_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Number of Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_nbPeaks = uicheckbox(gfp_panel,'Position',[210 10 40 20],'Value',1,'Text','all','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbPeaks = uieditfield(gfp_panel,'numeric','Position',[210 10 70 20],'Enable','off','HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%add function if cb nbPeaks unchecked : show ef_nbpeaks
%% Clustering
l_algorithm = uilabel(clustering_panel,'Position', [10 240 200 20],'HorizontalAlignment','right','Text','Clustering Algorithm : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_algorithm = uidropdown(clustering_panel,'Items', {'modkmeans','kmeans','taahc','aahc','varmicro'},'Value',settings.microstate.algorithm,'Position',[210 240 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_sorting = uilabel(clustering_panel,'Position', [10 215 200 20],'HorizontalAlignment','right','Text','Sorting : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_sorting = uidropdown(clustering_panel,'Items', {'Global explained variance', 'Chronological appearance','Frequency'},'Value',settings.microstate.sorting,'Position',[210 215 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_normalise = uilabel(clustering_panel,'Position', [10 210 200 20],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_normalise = uicheckbox(clustering_panel,'Position',[210 210 20 20],'Value',0,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

%l_nbMS = uilabel(clustering_panel,'Position', [10 190 200 20],'HorizontalAlignment','right','Text','Number of Microstates : ','FontSize',fontsize,'FontColor',foregroundColor);
%ef_nbMS = uieditfield(clustering_panel,'Value','4','Position',[210 190 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_verbose = uilabel(clustering_panel,'Position', [10 160 200 20],'HorizontalAlignment','right','Text','Verbose : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_verbose = uicheckbox(clustering_panel,'Position',[210 160 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_nbRep = uilabel(clustering_panel,'Position', [25 165 150 20], 'BackgroundColor', backgroundColor,'HorizontalAlignment','center','Text','Number of repetion  ','FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepFirst = uilabel(repetition_panel,'Position', [5 15 100 20],'HorizontalAlignment','right','Text','First Level : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepFirst = uieditfield(repetition_panel,'numeric','Value',settings.microstate.Nrepfirstlevel,'Position',[105 15 50 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepOther = uilabel(repetition_panel,'Position', [160 15 105 20],'HorizontalAlignment','right','Text','Other Levels : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepOther = uieditfield(repetition_panel,'numeric','Value',settings.microstate.Nrepotherlevel,'Position',[265 15 50 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_fitMeas = uilabel(clustering_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','FitMeas : ','FontSize',fontsize,'FontColor',foregroundColor);
%dd_fitMeas = uidropdown(clustering_panel,'Items', {'CV', 'others'},'Value','CV','Position',[210 85 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_maxIterations = uilabel(clustering_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Max iterations: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_maxIteration = uieditfield(clustering_panel,'numeric','Value',settings.microstate.max_iterations,'Position',[210 60 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_threshold = uilabel(clustering_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Threshold: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_threshold = uieditfield(clustering_panel,'numeric','Value',settings.microstate.threshold,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%l_optimize = uilabel(clustering_panel,'Position', [10 120 200 20],'HorizontalAlignment','right','Text','Optimize : ','FontSize',fontsize,'FontColor',foregroundColor);
%cb_optimize = uicheckbox(clustering_panel,'Position',[210 120 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_polarity = uilabel(clustering_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_polarity = uicheckbox(clustering_panel,'Position',[210 10 20 20],'Value',settings.microstate.orderingpolarity,'Text','','FontSize',fontsize,'FontColor',foregroundColor);


%% Backfitting
%l_labelType = uilabel(backfitting_panel,'Position', [10 85 200 20],'HorizontalAlignment','right','Text','Backfitting Label : ','FontSize',fontsize,'FontColor',foregroundColor);
%dd_labelType = uidropdown(backfitting_panel,'Items', {'backfit', 'segmentation'},'Value','backfit','Position',[210 85 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_smoothType = uilabel(backfitting_panel,'Position', [10 60 200 20],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_smoothType = uidropdown(backfitting_panel,'Items', {'reject segments', 'windowed'},'Value',settings.microstate.backfitting.smoothtype,'Position',[210 60 130 20],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_minTime = uilabel(backfitting_panel,'Position', [10 35 200 20],'HorizontalAlignment','right','Text','Minimum Time : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minTime = uieditfield(backfitting_panel,'numeric','Value',settings.microstate.backfitting.mintime,'Position',[210 35 70 20],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_BackfitPolarity= uilabel(backfitting_panel,'Position', [10 10 200 20],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_BackfitPolarity = uicheckbox(backfitting_panel,'Position',[210 10 20 20],'Value',settings.microstate.backfitting.polarity,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

%% Metrics
l_labelGEVTot =  uilabel(metrics_panel,'Position', [0 35 100 20],'HorizontalAlignment','right','Text','GEVtotal','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEVTot = uicheckbox(metrics_panel,'Position',[105 35 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GEVTot, event) metricscbx(cb_GEVTot,l_labelGEVTot));

l_labelGEV =  uilabel(metrics_panel,'Position', [115 35 50 20],'HorizontalAlignment','right','Text','GEV','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEV = uicheckbox(metrics_panel,'Position',[170 35 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GEV, event) metricscbx(cb_GEV,l_labelGEV));

l_labelGFP =  uilabel(metrics_panel,'Position', [180 35 50 20],'HorizontalAlignment','right','Text','GFP','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFP = uicheckbox(metrics_panel,'Position',[235 35 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GFP, event) metricscbx(cb_GFP,l_labelGFP));

l_labelMSParCorr =  uilabel(metrics_panel,'Position', [245 35 90 20],'HorizontalAlignment','right','Text','MspatCorr','FontSize',fontsize,'FontColor',foregroundColor);
cb_MSParCorr = uicheckbox(metrics_panel,'Position',[340 35 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_MSParCorr, event) metricscbx(cb_MSParCorr,l_labelMSParCorr));

l_labelOccurence =  uilabel(metrics_panel,'Position', [0 10 100 20],'HorizontalAlignment','right','Text','Occurence','FontSize',fontsize,'FontColor',foregroundColor);
cb_Occurence = uicheckbox(metrics_panel,'Position',[105 10 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Occurence, event) metricscbx(cb_Occurence,l_labelOccurence));

l_labelDuration =  uilabel(metrics_panel,'Position', [120 10 100 20],'HorizontalAlignment','right','Text','Duration','FontSize',fontsize,'FontColor',foregroundColor);
cb_Duration = uicheckbox(metrics_panel,'Position',[225 10 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Duration, event) metricscbx(cb_Duration,l_labelDuration));

l_labelCoverage =  uilabel(metrics_panel,'Position', [235 10 100 20],'HorizontalAlignment','right','Text','Coverage','FontSize',fontsize,'FontColor',foregroundColor);
cb_Coverage = uicheckbox(metrics_panel,'Position',[340 10 20 20],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Coverage, event) metricscbx(cb_Coverage,l_labelCoverage));


%% Reset Button
b_reset = uibutton(settings_fig,'Text','Reset','Position', [460 25 110 45],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'ButtonPushedFcn',@(src,event) resetParam());
b_save = uibutton(settings_fig,'Text','Save and Quit','Position', [580 25 110 45],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'ButtonPushedFcn',@(src,event) saveButtonPushed());

%% FUNCTIONS
waitfor(settings_fig);
function metricscbx(cbx,label)
    if cbx.Value && ismember(settings.microstate.metrics,label.Text)
        settings.microstate.metrics(end+1) = label.Text;
    end
    if ~cbx.Value
        settings.microstate.metrics(ismember(settings.microstate.metrics,label.Text)) = [];
    end
    disp(settings.microstate.metrics)
end
function Enable_RS(cbx)
    if cbx.Value
        ef_RSEC.Enable = true;
        ef_RSEO.Enable=true;
        ef_RSLatencystart.Enable = true;
        ef_RSLatencyend.Enable = true;
    else
        ef_RSEC.Enable = false;
        ef_RSEO.Enable=false;
        ef_RSLatencystart.Enable = false;
        ef_RSLatencyend.Enable = false;
    end

end
function Enable_Preproc(cbx)
    if cbx.Value
        cb_averageRef.Enable = true;
        ef_lowNotch.Enable = true;
        ef_highNotch.Enable = true;
        ef_lowPb.Enable = true;
        ef_highPb.Enable = true;
        ef_mvMax.Enable = true;
        ef_nGoodSample.Enable = true;
        ef_sampleRate.Enable = true;
    else
        cb_averageRef.Enable = false;
        ef_lowNotch.Enable = false;
        ef_highNotch.Enable = false;
        ef_lowPb.Enable = false;
        ef_highPb.Enable = false;
        ef_mvMax.Enable = false;
        ef_nGoodSample.Enable = false;
        ef_sampleRate.Enable = false;
    end
end
function Enable_Npeaks(cbx)
    if cbx.Value
        ef_nbPeaks.Enable = false;
    else
        ef_nbPeaks.Enable = true;
    end
end

function resetParam()
    
    set(cb_averageRef,'Value',default.preproc.avgref);
    set(ef_lowNotch,'Value',default.preproc.notch.low);
    set(ef_highNotch,'Value',default.preproc.notch.high);
    set(ef_lowPb,'Value',default.preproc.bandpass.low);
    set(ef_highPb,'Value',default.preproc.bandpass.high);
    set(ef_mvMax,'Value',default.preproc.mvmax);
    set(ef_RSEC,'Value',default.preproc.EClabel);
    set(ef_RSEO,'Value',default.preproc.EOlabel);
    set(ef_RSLatencystart,'Value',default.preproc.timelimits(1)); 
    set(ef_RSLatencyend,'Value',default.preproc.timelimits(2));
    set(ef_nGoodSample,'Value',default.nGoodSamples);
    set(ef_sampleRate,'Value',default.sr);
    set(cb_gfpaverageRef,'Value',default.microstate.gfp.avgref);
    set(cb_GFPnormalise,'Value',default.microstate.gfp.normalise);
    set(ef_minPeakDist,'Value',default.microstate.gfp.MinPeakDist);
    set(ef_GFPthreshold,'Value',default.microstate.gfp.GFPthresh);
    set(dd_algorithm,'Value',default.microstate.algorithm);
    set(dd_sorting,'Value',default.microstate.sorting);
    set(ef_nbRepFirst,'Value',default.microstate.Nrepfirstlevel);
    set(ef_nbRepOther,'Value',default.microstate.Nrepotherlevel);
    set(ef_maxIteration,'Value',default.microstate.max_iterations);
    set(ef_threshold,'Value',default.microstate.threshold);
    set(cb_polarity,'Value',default.microstate.orderingpolarity);
    set(dd_smoothType,'Value',default.microstate.backfitting.smoothtype);
    set(ef_minTime,'Value',default.microstate.backfitting.mintime);
    set(cb_BackfitPolarity,'Value',default.microstate.backfitting.polarity);
    
    set(cb_GEVTot,'Value',true);
    set(cb_GEV,'Value',true);
    set(cb_Coverage,'Value',true);
    set(cb_Occurence,'Value',true);
    set(cb_Duration,'Value',true);    
    set(cb_GFP,'Value',true);   
    set(cb_MSParCorr,'Value',true);
    
    set(cb_RS,'Value',false);
    Enable_RS(cb_RS);
    set(cb_addPreproc,'Value',false);
    Enable_Preproc(cb_addPreproc);
    set(ef_nbPeaks,'Value',0);
    set(cb_allPeaks,'Value',true);

end

function saveButtonPushed()
    settings.todo.RS = cb_RS.Value;
    settings.todo.addpreproc = cb_addPreproc.Value;
    settings.preproc.avgref = cb_averageRef.Value;
    settings.preproc.notch.low = ef_lowNotch.Value;
    settings.preproc.notch.high = ef_highNotch.Value;
    settings.preproc.bandpass.low = ef_lowPb.Value;
    settings.preproc.bandpass.high = ef_highPb.Value;
    settings.preproc.mvmax = ef_mvMax.Value;
    settings.preproc.EClabel = ef_RSEC.Value;
    settings.preproc.EOlabel = ef_RSEO.Value;
    settings.preproc.timelimits = [ef_RSLatencystart.Value ef_RSLatencyend.Value] ;
    settings.nGoodSamples = ef_nGoodSample.Value;
    settings.sr = ef_sampleRate.Value;
    settings.microstate.gfp.avgref = cb_gfpaverageRef.Value; 
    settings.microstate.gfp.normalise = cb_GFPnormalise.Value;
    settings.microstate.gfp.MinPeakDist = ef_minPeakDist.Value;
    settings.microstate.gfp.GFPthresh = ef_GFPthreshold.Value;
    settings.microstate.gfp.takeallpeaks = cb_allPeaks.Value;
    if cb_allPeaks.Value
        settings.microstate.gfp.Npeaks = [];
    else
        settings.microstate.gfp.Npeaks = ef_nbPeaks.Value;
    end
    settings.microstate.gfp.Npeaks = ef_nbPeaks.Value;
    settings.microstate.algorithm = dd_algorithm.Value;
    settings.microstate.sorting = dd_sorting.Value;
    settings.microstate.Nrepfirstlevel = ef_nbRepFirst.Value;
    settings.microstate.Nrepotherlevel = ef_nbRepOther.Value;
    settings.microstate.maxiteration = ef_maxIteration.Value;
    settings.microstate.threshold = ef_threshold.Value;
    settings.microstate.orderingpolarity = cb_polarity.Value;
    settings.microstate.backfitting.smoothtype = dd_smoothType.Value;
    settings.microstate.backfitting.mintime = ef_minTime.Value;
    settings.microstate.backfitting.polarity = cb_BackfitPolarity.Value; 
    %settings.microstate.metrics = {'GEVtotal','Gfp','Occurence','Duration','Coverage','GEV','MspatCorr'};
    close(settings_fig);
end

end