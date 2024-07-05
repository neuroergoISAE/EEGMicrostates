%% Param Window for MicrostatesGUI
% Author : C. Hamery
% Date : 03.2024
% Description : GUI containing all customizable parameters for the microstates analysis
% If a settings.mat file already exists in the settings folder, will load this file instead of default parameters

function [settings, cancel] = MicrostatesParamGUI(settings)

default =defaultsettings();

backgroundColor = '#004675';
foregroundColor = '#FFFFFF';
fontsize = 20;
cancel = 0;
settings_fig = uifigure('Position', [745 200 800 600], 'Color', backgroundColor, 'Icon', 'external_files/cerveau.png','WindowStyle','modal','Resize','off');
guidata(settings_fig,settings);

%% panels
gfp_panel= uipanel(settings_fig, 'Position', [20 300 360 280], 'BackgroundColor', backgroundColor,'Title','GFP ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
clustering_panel  = uipanel(settings_fig, 'Position', [420 270 360 310], 'BackgroundColor', backgroundColor,'Title','Clustering ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfitting_panel = uipanel(settings_fig, 'Position', [420  100 360 150], 'BackgroundColor', backgroundColor,'Title','Backfitting ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
metrics_panel = uipanel(settings_fig, 'Position', [20 100 360 180], 'BackgroundColor', backgroundColor,'Title','Metrics ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

% subpanels
repetition_panel = uipanel(clustering_panel, 'Position', [10 120 340 55], 'BackgroundColor', backgroundColor,'Title','','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%% GFP
l_gfpaverageRef = uilabel(gfp_panel,'Position', [10 210 230 30],'HorizontalAlignment','right','Text','Average Reference : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_gfpaverageRef = uicheckbox(gfp_panel,'Position',[240 210 20 30],'Value',settings.microstate.gfp.avgref,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_GFPnormalise = uilabel(gfp_panel,'Position', [10 170 230 30],'HorizontalAlignment','right','Text','Normalise : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFPnormalise = uicheckbox(gfp_panel,'Position',[240 170 20 30],'Value',settings.microstate.gfp.normalise,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

l_minPeakDist = uilabel(gfp_panel,'Position', [10 130 230 30],'HorizontalAlignment','right','Text','Mean Peak Distance : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minPeakDist = uieditfield(gfp_panel,'numeric','Value',settings.microstate.gfp.MinPeakDist,'Position',[240 130 70 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_GFPthreshold = uilabel(gfp_panel,'Position', [10 90 230 30],'HorizontalAlignment','right','Text','Threshold : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_GFPthreshold = uieditfield(gfp_panel,'numeric','Value',settings.microstate.gfp.GFPthresh,'Position',[240 90 70 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_allPeaks = uilabel(gfp_panel,'Position', [10 50 230 30],'HorizontalAlignment','right','Text','Take all Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_allPeaks = uicheckbox(gfp_panel,'Position',[240 50 30 30],'Value',settings.microstate.gfp.takeallpeaks,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event)Enable_Npeaks(cbx));

l_nbPeaks= uilabel(gfp_panel,'Position', [10 10 230 30],'HorizontalAlignment','right','Text','Number of Peaks : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbPeaks = uieditfield(gfp_panel,'numeric','Position',[240 10 70 30],'Enable','off','HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

if ~settings.microstate.gfp.takeallpeaks
    ef_nbPeaks.Enable = 'on';
    ef_nbPeaks.Value = settings.microstate.gfp.Npeaks;
end

%% Clustering
l_algorithm = uilabel(clustering_panel,'Position', [10 230 200 30],'HorizontalAlignment','right','Text','Clustering Algorithm : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_algorithm = uidropdown(clustering_panel,'Items', {'modkmeans','kmeans','taahc','aahc','varmicro'},'Value',settings.microstate.algorithm,'Position',[210 230 130 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_sorting = uilabel(clustering_panel,'Position', [10 190 200 30],'HorizontalAlignment','right','Text','Sorting : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_sorting = uidropdown(clustering_panel,'Items', {'Global explained variance', 'Chronological appearance','Frequency'},'Value',settings.microstate.sorting,'Position',[210 190 130 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_nbRep = uilabel(clustering_panel,'Position', [25 160 300 30], 'BackgroundColor', backgroundColor,'HorizontalAlignment','center','Text','Number of repetion  per Level','FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepFirst = uilabel(repetition_panel,'Position', [5 10 100 30],'HorizontalAlignment','right','Text','First : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepFirst = uieditfield(repetition_panel,'numeric','Value',settings.microstate.Nrepfirstlevel,'Position',[105 10 60 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
l_nbRepOther = uilabel(repetition_panel,'Position', [160 10 100 30],'HorizontalAlignment','right','Text','Others : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbRepOther = uieditfield(repetition_panel,'numeric','Value',settings.microstate.Nrepotherlevel,'Position',[265 10 60 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_maxIterations = uilabel(clustering_panel,'Position', [10 75 200 30],'HorizontalAlignment','right','Text','Max iterations: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_maxIteration = uieditfield(clustering_panel,'numeric','Value',settings.microstate.max_iterations,'Position',[210 75 70 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_threshold = uilabel(clustering_panel,'Position', [10 40 200 30],'HorizontalAlignment','right','Text','Threshold: ','FontSize',fontsize,'FontColor',foregroundColor);
ef_threshold = uieditfield(clustering_panel,'numeric','Value',settings.microstate.threshold,'Position',[210 40 70 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_polarity = uilabel(clustering_panel,'Position', [10 10 200 30],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_polarity = uicheckbox(clustering_panel,'Position',[210 10 30 30],'Value',settings.microstate.orderingpolarity,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

%% Backfitting
l_smoothType = uilabel(backfitting_panel,'Position', [10 80 200 30],'HorizontalAlignment','right','Text','Smoothing Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_smoothType = uidropdown(backfitting_panel,'Items', {'reject segments', 'windowed'},'Value',settings.microstate.backfitting.smoothtype,'Position',[210 80 130 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_minTime = uilabel(backfitting_panel,'Position', [10 45 200 30],'HorizontalAlignment','right','Text','Minimum Time : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_minTime = uieditfield(backfitting_panel,'numeric','Value',settings.microstate.backfitting.mintime,'Position',[210 45 70 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

l_BackfitPolarity= uilabel(backfitting_panel,'Position', [10 10 200 30],'HorizontalAlignment','right','Text','Polarity : ','FontSize',fontsize,'FontColor',foregroundColor);
cb_BackfitPolarity = uicheckbox(backfitting_panel,'Position',[210 10 30 30],'Value',settings.microstate.backfitting.polarity,'Text','','FontSize',fontsize,'FontColor',foregroundColor);

%% Metrics
l_labelGEVTot =  uilabel(metrics_panel,'Position', [10 100 100 30],'HorizontalAlignment','right','Text','GEVtotal','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEVTot = uicheckbox(metrics_panel,'Position',[115 100 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GEVTot, event) metricscbx(cb_GEVTot,l_labelGEVTot));

l_labelGEV =  uilabel(metrics_panel,'Position', [10 70 100 30],'HorizontalAlignment','right','Text','GEV','FontSize',fontsize,'FontColor',foregroundColor);
cb_GEV = uicheckbox(metrics_panel,'Position',[115 70 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GEV, event) metricscbx(cb_GEV,l_labelGEV));

l_labelGFP =  uilabel(metrics_panel,'Position', [10 40 100 30],'HorizontalAlignment','right','Text','GFP','FontSize',fontsize,'FontColor',foregroundColor);
cb_GFP = uicheckbox(metrics_panel,'Position',[115 40 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_GFP, event) metricscbx(cb_GFP,l_labelGFP));

l_labelMSParCorr =  uilabel(metrics_panel,'Position', [10 10 100 30],'HorizontalAlignment','right','Text','MspatCorr','FontSize',fontsize,'FontColor',foregroundColor);
cb_MSParCorr = uicheckbox(metrics_panel,'Position',[115 10 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_MSParCorr, event) metricscbx(cb_MSParCorr,l_labelMSParCorr));

l_labelOccurence =  uilabel(metrics_panel,'Position', [180 80 100 30],'HorizontalAlignment','right','Text','Occurence','FontSize',fontsize,'FontColor',foregroundColor);
cb_Occurence = uicheckbox(metrics_panel,'Position',[290 80 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Occurence, event) metricscbx(cb_Occurence,l_labelOccurence));

l_labelDuration =  uilabel(metrics_panel,'Position', [180 50 100 30],'HorizontalAlignment','right','Text','Duration','FontSize',fontsize,'FontColor',foregroundColor);
cb_Duration = uicheckbox(metrics_panel,'Position',[290 50 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Duration, event) metricscbx(cb_Duration,l_labelDuration));

l_labelCoverage =  uilabel(metrics_panel,'Position', [180 20 100 30],'HorizontalAlignment','right','Text','Coverage','FontSize',fontsize,'FontColor',foregroundColor);
cb_Coverage = uicheckbox(metrics_panel,'Position',[290 20 30 30],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cb_Coverage, event) metricscbx(cb_Coverage,l_labelCoverage));

%% Reset Button
b_reset = uibutton(settings_fig,'Text','Reset','Position', [150, 30, 200, 40],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'ButtonPushedFcn',@(src,event) resetParam());
b_save = uibutton(settings_fig,'Text','Save and Quit','Position', [450, 30, 200, 40],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor,'ButtonPushedFcn',@(src,event) saveButtonPushed());

%% FUNCTIONS
waitfor(settings_fig);
function metricscbx(cbx,label)
    if cbx.Value & ismember(settings.microstate.metrics,label.Text)
        settings.microstate.metrics(end+1) = label.Text;
    end
    if ~cbx.Value
        settings.microstate.metrics(ismember(settings.microstate.metrics,label.Text)) = [];
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
    
    set(ef_nbPeaks,'Value',0);
    set(cb_allPeaks,'Value',true);

end

function saveButtonPushed()
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
    save('settings/settings','-struct','settings'); % Save the 'param' structure variable to a file for future use
    close(settings_fig);
end

end