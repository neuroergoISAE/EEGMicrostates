%% Microstates Main GUI
% Author : C. Hamery
% Date : 04.2024
% Description : Main GUI window for the microstates analysis
% Dependencies : EEGlab, Signal Processin Toolbox, Statistics and Machine Learning Toolbox, customcolormap
% This window allows the user to modify project's information
% If a settings.mat file already exists in the settings folder, will load this file instead of default parameters
% Output : settings.mat file for reproducibility or further uses

function [settings] = MicrostatesGUI()
backgroundColor = '#004675';
foregroundColor = '#FFFFFF';
fontsize = 20;
microstates_fig = uifigure('Position', [745 200 800 700], 'Color', backgroundColor, 'Icon', 'external_files/cerveau.png','WindowStyle','modal','Resize','off');
if isfile(['settings',filesep,'settings.mat'])% if already existing settings in path, load settings, else default

    settings = load(['settings',filesep,'settings.mat']);
else
    settings = defaultsettings();
end
guidata(microstates_fig,settings);

%% Panels
project_panel =  uipanel(microstates_fig, 'Position', [50 350 700 290], 'BackgroundColor', backgroundColor,'Title','Project ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
microstates_panel =  uipanel(microstates_fig, 'Position', [50 100 700 225], 'BackgroundColor', backgroundColor,'Title','Microstates ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%% GUI
% Project Name
l_projectname = uilabel(project_panel,'Position', [10 210 200 30],'HorizontalAlignment','right', 'Text','Project Name : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_projectname = uieditfield(project_panel, 'Position', [220, 210, 250, 30],'Value',settings.name,'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
% Input Data Folder
l_datafolder = uilabel(project_panel,'Position', [10 160 200 30],'HorizontalAlignment','right', 'Text','Input Data Folder : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_datafolder = uieditfield(project_panel, 'Position', [220, 160, 250, 30],'Value',settings.path.data,'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
btn_datafolder = uibutton(project_panel, 'Text', 'Browse', 'Position', [485, 160, 100, 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor, 'ButtonPushedFcn', @(~, ~) selectDirectory(ef_datafolder));
% Data Type
l_datatype = uilabel(project_panel,'Position', [10 100 200 30],'HorizontalAlignment','right','Text','Data Type : ','FontSize',fontsize,'FontColor',foregroundColor);
dd_datatype = uidropdown(project_panel,'Items', {'.set','.mat'},'Value',settings.dataformat,'Position',[220 100 130 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
%Sanpling Rate
l_sr = uilabel(project_panel,'Position', [350 100 200 30],'HorizontalAlignment','right','Text','Sampling Rate : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_sr = uieditfield(project_panel, 'Value',string(settings.sr),'Position', [550 100 100 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);

%Output Data Folder
l_outputfolder = uilabel(project_panel,'Position', [10 60 200 30],'HorizontalAlignment','right', 'Text','Output Folder : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_outputfolder = uieditfield(project_panel, 'Position', [220, 60, 250, 30],'Value',settings.path.project,'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
btn_outputfolder = uibutton(project_panel, 'Text', 'Browse', 'Position', [485, 60, 100, 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor, 'ButtonPushedFcn', @(~, ~) selectDirectory(ef_outputfolder));

%EEGLAB PATH
l_eeglabpath = uilabel(project_panel,'Position', [10 10 200 30],'HorizontalAlignment','right', 'Text','EEGLAB Path : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_eeglabpath = uieditfield(project_panel, 'Position', [220, 10, 250, 30],'Value',settings.path.eeglab,'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
btn_eeglabpath = uibutton(project_panel, 'Text', 'Browse', 'Position', [485, 10, 100, 30],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor, 'ButtonPushedFcn', @(~, ~) selectDirectory(ef_eeglabpath));

% Number of Microstates
l_nbmicrostates = uilabel(microstates_panel,'Position', [10 150 250 30],'HorizontalAlignment','right', 'Text','Number of Microstates : ','FontSize',fontsize,'FontColor',foregroundColor);
ef_nbmicrostates = uieditfield(microstates_panel, 'Value',string(settings.microstates.Nmicrostates),'Position', [270, 150, 100, 30],'HorizontalAlignment','left','BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor);
im_interrogation = uiimage(microstates_panel,'Position',[375 155 18 18],'ImageSource','infoicon.png','BackgroundColor','none','Tooltip','[x y] for multiple microstates');
% Clustering Param
l_cluster = uilabel(microstates_panel,'Position', [30 100 300 25], 'Text','Select Clustering levels: ','FontSize',fontsize,'FontColor',foregroundColor);
cbx_participant = uicheckbox(microstates_panel,'Position',[450 100 25 25],'Text','','ValueChangedFcn', @(cbx,event) cBoxChanged_Participant(cbx));
l_participant = uilabel(microstates_panel,'Position', [480 100 100 25], 'Text','Participant','FontSize',fontsize,'FontColor',foregroundColor);
cbx_session = uicheckbox(microstates_panel,'Position',[320 100 25 25],'Enable','off','Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn', @(cbx,event) cBoxChanged_MultipleSessions(cbx,cbx_participant));
l_session = uilabel(microstates_panel,'Position', [350 100 100 25], 'Text','Session','FontSize',fontsize,'FontColor',foregroundColor);
cbx_group = uicheckbox(microstates_panel,'Position',[600 100 25 25],'Value',1,'Text','','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event) groubCbx(cbx));
l_group = uilabel(microstates_panel,'Position', [630 100 150 25], 'Text','Group','FontSize',fontsize,'FontColor',foregroundColor);

% Multiple or Single Sessions
l_bg_session = uilabel(microstates_panel,'Position',[30 10 250 50],'WordWrap','on', 'Text','Multiple or Single Session for each participant: ','FontSize',fontsize,'FontColor', foregroundColor);
bg_session = uibuttongroup('Parent',microstates_panel,'Position',[300 10 350 50],'BackgroundColor',backgroundColor,'SelectionChangedFcn',@(bg_session,event) cBoxChanged_Session(bg_session,cbx_session));
rb_single = uiradiobutton(bg_session,'Position',[30 10 150 30],'Text','Single','FontSize',fontsize,'FontColor', foregroundColor);
rb_multiple = uiradiobutton(bg_session,'Position',[190 10 150 30],'Text','Multiple','FontSize',fontsize,'FontColor', foregroundColor);

% Config Button
btn_config = uibutton(microstates_fig, 'Text', 'Change Settings', 'Position', [150, 30, 200, 40],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor, 'ButtonPushedFcn', @(~, ~) openconfig());
% Run Button
btn_run = uibutton(microstates_fig, 'Text', 'Run Analysis', 'Position', [450, 30, 200, 40],'BackgroundColor', backgroundColor,'FontSize',fontsize,'FontColor',foregroundColor, 'ButtonPushedFcn', @(~, ~) runanalysis());

%% FUNCTIONS
waitfor(microstates_fig);
function selectDirectory(editField)
    directory = uigetdir();
    if directory
        editField.Value = directory;
    end
end
function openconfig()
    settings = MicrostatesParamGUI(settings);
end
function groubCbx(cbx)
        cbx.Value = 1; % group checkbox is mandatory
    end
function cBoxChanged_Session(cbx,cbxsess) 
    val = cbx.SelectedObject.Text;
    if strcmp(val,rb_single.Text) %single session
        cbxsess.Enable = 'off';
        cbxsess.Value = 0;
    else
        cbxsess.Enable = 'on';
    end
end
function cBoxChanged_Participant(cbxpart)
    if cbx_session.Value == 1 % if session cbx is checked, must check participant session (cannot be unchecked unless session is unchecked)
        set(cbxpart, 'Value', 1);
    end
end
function cBoxChanged_MultipleSessions(cbxsess,cbxpart)
    disp(cbxpart.Value);
    if cbxsess.Value == 1 % if session cbx is checked, must check participant session (cannot be unchecked unless session is unchecked)
        set(cbxpart, 'Value', 1);
    end

end
function runanalysis()
    settings.path.project = ef_outputfolder.Value;
    settings.path.data = ef_datafolder.Value;
    settings.path.eeglab = ef_eeglabpath.Value;
    settings.name = ef_projectname.Value;
    settings.microstate.Nmicrostates = str2num(ef_nbmicrostates.Value);
    settings.dataformat = dd_datatype.Value;
    settings.sr = str2num(ef_sr.Value);
    settings.multipleSessions = rb_multiple.Value;
    if cbx_session.Value && cbx_participant.Value
            settings.backfittingLevels ={'session','participant','group'};
    else
        if cbx_session.Value && ~ cbx_participant.Value
        settings.backfittingLevels = {'session','group'};
        else
            if ~cbx_session.Value && cbx_participant.Value
                settings.backfittingLevels = {'participant','group'};
            else
                settings.backfittingLevels = {'group'};
            end
        end
    end
    settings.levels = settings.backfittingLevels;
    save('settings/settings','-struct','settings'); % Save the 'param' structure variable to a file for future use
    close(microstates_fig);
end
end