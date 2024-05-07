function [param, cancel] = MicrostatesGUI

backgroundColor = '#344372';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
gui_fig = uifigure('Position', [745 200 800 700], 'Color', backgroundColor, 'Icon', 'cerveau.png', 'WindowStyle','alwaysontop' ); 
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

guidata(gui_fig,param);
uilabel(gui_fig,'Text',"Microstates Analysis Parameters",'Position',[0 660 800 30], 'HorizontalAlignment','center','FontSize',fontsize+4,'FontWeight','Bold','FontColor', foregroundColor, 'FontSize', 20);

%% panels
path_panel = uipanel(gui_fig, 'Position', [50 450 700 150], 'BackgroundColor', backgroundColor,'Title','Directories Selection ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
session_panel = uipanel(gui_fig,'Position', [50 300 700 100], 'BackgroundColor' , backgroundColor,'Title','Sessions ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfit_panel = uipanel(gui_fig,'Position', [50 150 700 100], 'BackgroundColor' , backgroundColor,'Title','Backfitting','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%Project Name
uilabel(gui_fig,'Text',"Project Name : ",'Position',[55 620 150 30],'FontSize',fontsize+2,'FontColor', foregroundColor);
efname = uieditfield(gui_fig,'Position',[200 620 550 30],'Value',param.name,'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
%% Param Button
%param_button = uibutton(gui_fig, "ButtonPushedFcn",@(src,event) openParamGUI(param));
%% labels
%l_global=uilabel(path_panel,'Text',param.path.src,'Position',[40 60 325 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
%Global Path
%btnProjectPath = uibutton(path_panel,'push', 'Text', 'Project Folder Directory',...
%    'Position', [25 35 200 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
%btnProjectPath.ButtonPushedFcn = @selectProjectDirectory;
%l_project = uilabel(path_panel,'Text',param.path.project,...
%    'Position',[35 5 225 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
% Input Path
btnInputPath = uibutton(path_panel,'push', 'Text', 'Input Data Directory','Enable','on',...
    'Position', [250 35 200 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnInputPath.ButtonPushedFcn = @selectInputDirectory;
l_inputData = uilabel(path_panel,'Text',param.path.data,...
    'Position',[260 5 225 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
%Eeglab Path
btnEEGLabPath = uibutton(path_panel,'push', 'Text', 'EEGLab Directory',...
    'Position', [475 35 200 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnEEGLabPath.ButtonPushedFcn = @selecteeglabDirectory;
l_eeglab = uilabel(path_panel,'Text',param.path.eeglab,...
    'Position',[485 5 225 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
%% Data Format
dataFormats = {'.set', '.mat'};
uilabel(path_panel,'Text',"Data Format:",'Position',[25 80 150 30],'FontSize',fontsize+2,'FontColor', foregroundColor);
formatDropdown = uidropdown(path_panel, 'Items', dataFormats, 'Position', [150 80 150 30], 'Value',param.dataFormat, 'FontSize', fontsize, 'BackgroundColor', backgroundColor, 'FontColor', foregroundColor);

%% Backfitting Param
l_backfit = uilabel(backfit_panel,'Position', [30 25 300 25], 'Text','Select Required Backfitting levels: ','FontSize',fontsize,'FontColor',foregroundColor);
cbx_session = uicheckbox(backfit_panel,'Position',[320 25 200 25],'Enable','off','Text','Session','FontSize',fontsize,'FontColor',foregroundColor);
cbx_participant = uicheckbox(backfit_panel,'Position',[450 25 200 25],'Text','Participant','FontSize',fontsize,'FontColor',foregroundColor);
cbx_group = uicheckbox(backfit_panel,'Position',[600 25 200 25],'Value',1,'Text','Group','FontSize',fontsize,'FontColor',foregroundColor,'ValueChangedFcn',@(cbx,event) groubCbx(cbx));

%% Multiple or Single Sessions
l_bg_session = uilabel(session_panel,'Position',[30 15 250 50],'WordWrap','on', 'Text','Multiple or Single Session for each participant: ','FontSize',fontsize,'FontColor', foregroundColor);
bg_session = uibuttongroup('Parent',session_panel,'Position',[300 10 350 50],'BackgroundColor',backgroundColor,'SelectionChangedFcn',@(bg_session,event) cBoxChanged_Session(bg_session,cbx_session));
rb_single = uiradiobutton(bg_session,'Position',[30 10 150 30],'Text','Single Session','FontSize',fontsize,'FontColor', foregroundColor);
rb_multiple = uiradiobutton(bg_session,'Position',[190 10 150 30],'Text','Multiple Sessions','FontSize',fontsize,'FontColor', foregroundColor);


%% Save Button
save_btn = uibutton(gui_fig, 'Position', [300 70 200 40],'Text','Save Parameters',...
    'FontWeight','Bold','BackgroundColor',backgroundColor,'FontSize',fontsize+2,...
    'FontColor',foregroundColor, 'ButtonPushedFcn',@(src,event) saveButtonPushed());

%% Ok Button
run_btn = uibutton(gui_fig, 'Position', [300 20 200 40],'Text','Run',...
    'FontWeight','Bold','BackgroundColor',backgroundColor,'FontSize',fontsize+2,...
    'FontColor',foregroundColor,'Enable','off', 'ButtonPushedFcn',@(src,event) runButtonPushed());
   % Set font to Barlow for all UI components
%% FUNCTIONS
waitfor(gui_fig);
    function openParamGUI(param)
        MicrostatesParamGUI(param);
    end
    function selecteeglabDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.eeglab = directory;%[directory,filesep];
        l_eeglab.Text = param.path.eeglab;
        guidata(src,param)
    end
    function selectInputDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.data = [directory,filesep];
        l_inputData.Text = param.path.data;
        guidata(src,param)
    end
function cBoxChanged(cbx,btn1,lab1,btn2,lab2,btn3,lab3,btn4,lab4)
    val = cbx.Value;
    if val
        btn1.Enable = 'on';
        lab1.Enable = 'on';
        btn2.Enable = 'on';
        lab2.Enable = 'on';
        btn3.Enable = 'on';
        lab3.Enable = 'on';
        btn4.Enable = 'on';
        lab4.Enable = 'on';
    else
        btn1.Enable = 'off';
        lab1.Enable = 'off';
        btn2.Enable = 'off';
        lab2.Enable = 'off';
        btn3.Enable = 'off';
        lab3.Enable = 'off';
        btn4.Enable = 'off';
        lab4.Enable = 'off';
    end
end

function cBoxChanged_Session(cbx,cbx2) 
    val = cbx.SelectedObject.Text;
    
    if strcmp(val,rb_single.Text)
        cbx2.Enable = 'off';
        cbx2.Value = 0;
    else
        cbx2.Enable = 'on';

    end
end
function groubCbx(cbx)
        cbx.Value = 1; % group checkbox is mandatory
    end
function saveButtonPushed()
    param.name = efname.Value;
    if param.path.eeglab == ""
            param.path.eeglab = l_eeglab.Text ;
    end
    
    %param multipleSessions
    param.multipleSessions = rb_multiple.Value ;
    %param.backfittingLevels
    if cbx_session.Value && cbx_participant.Value
            param.backfittingLevels ={'session','participant','group'};
    else
        if cbx_session.Value && ~ cbx_participant.Value
        param.backfittingLevels = {'session','group'};
        else
            if ~cbx_session.Value && cbx_participant.Value
                param.backfittingLevels = {'participant','group'};
            else
                param.backfittingLevels = {'group'};
            end
        end

    end
    save(['settings',filesep,'param.mat'], 'param') ;
    run_btn.Enable = 'on';
end
function runButtonPushed()
    close(gui_fig);
end
changeFont(gui_fig);
function changeFont(fig)
    % Set font to Barlow for all UI components in the figure
    components = findall(fig, '-property', 'FontName');
    for i = 1:numel(components)
        set(components(i), 'FontName', 'Barlow');
    end
end
end
