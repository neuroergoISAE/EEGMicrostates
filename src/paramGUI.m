function [param, cancel] = paramGUI

backgroundColor = '#141414';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
gui_fig = uifigure('position',[745 200 800 700], 'Color', backgroundColor); %
if isfile(['settings',filesep,'param.mat'])
    load(['settings',filesep,'param.mat']);
    disp(param.path)
    if strcmp(param.name,'')
        param.name = ['Project_',date()];
    end
else
    param = struct();
    param.path.project = '';
    param.path.eeglab = 'D:\eeglab\eeglab2023.0';
    param.path.data = '';
    param.name = ['Project_',date()];
end
guidata(gui_fig,param);
uilabel(gui_fig,'Text',"Microstates Analysis Parameters",'Position',[0 660 800 30], 'HorizontalAlignment','center','FontSize',fontsize+4,'FontWeight','Bold','FontColor', foregroundColor, 'FontSize', 20);

%% panels
path_panel = uipanel(gui_fig, 'Position', [50 490 700 120], 'BackgroundColor', backgroundColor,'Title','Directories Selection ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
epoching = uipanel(gui_fig, 'Position', [50 370 700 100], 'BackgroundColor', backgroundColor,'Title','Epoch of Interest ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
session_panel = uipanel(gui_fig,'Position', [50 250 700 100], 'BackgroundColor' , backgroundColor,'Title','Sessions ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfit_panel = uipanel(gui_fig,'Position', [50 130 700 100], 'BackgroundColor' , backgroundColor,'Title','Backfitting','FontSize',fontsize+2,'ForegroundColor', foregroundColor);

%Project Name
uilabel(gui_fig,'Text',"Project Name : ",'Position',[55 620 150 30],'FontSize',fontsize+2,'FontColor', foregroundColor);
efname = uieditfield(gui_fig,'Position',[200 620 550 30],'Value',param.name,'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);

%% labels
%l_global=uilabel(path_panel,'Text',param.path.src,'Position',[40 60 325 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
%Global Path
btnProjectPath = uibutton(path_panel,'push', 'Text', 'Project Folder Directory',...
    'Position', [25 35 200 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnProjectPath.ButtonPushedFcn = @selectProjectDirectory;
l_project = uilabel(path_panel,'Text',param.path.project,...
    'Position',[35 5 225 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
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

%% Epoch of interest extraction
efTrigger = uieditfield(epoching,'Position',[470 40 100 30],'Value','RS_EC','Enable','off',...
    'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
l_trigger = uilabel(epoching,'Text','Trigger Label : ','Position',[300 40 120 30],'FontSize',fontsize,'FontColor', foregroundColor,'Enable','off');

beginTriggerVal = uieditfield(epoching,'numeric','Limits',[0 Inf],'RoundFractionalValues','on','Position',[240 5 40 30],'Enable','off',...
   'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
labelbegintriggerVal = uilabel(epoching,'Text','Trigger Begin Time (s) : ','HorizontalAlignment','left','Position',[30 5 200 30],'FontSize',fontsize,'FontColor', foregroundColor,'Enable','off');

endTriggerVal = uieditfield(epoching,'numeric','Limits',[0 Inf],'RoundFractionalValues','on','Position',[530 5 40 30],'Enable','off',...
   'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
labelendtriggerVal = uilabel(epoching,'Text','Triger End Time (s) : ','HorizontalAlignment','left','Position',[320 5 200 30],'FontSize',fontsize,'FontColor', foregroundColor,'Enable','off');

cbxEpoch = uicheckbox(epoching,'Text','Proceed to Epoching Extraction','Value', 0,...
                  'Position',[30 40 300 30],'Fontcolor',foregroundColor,'FontSize',fontsize,'ValueChangedFcn',...
                   @(cbxEpoch,event) cBoxChanged(cbxEpoch,efTrigger,l_trigger,beginTriggerVal,labelbegintriggerVal,endTriggerVal,labelendtriggerVal));

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

%% FUNCTIONS
waitfor(gui_fig);
    function selecteeglabDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.eeglab = directory;%[directory,filesep];
        l_eeglab.Text = param.path.eeglab;
        guidata(src,param)
    end
 function selectProjectDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.project = directory;%[directory,filesep];
        l_project.Text = param.path.project;
        guidata(src,param)
    end
    function selectInputDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.data = [directory,filesep];
        l_inputData.Text = param.path.data;
        guidata(src,param)
    end
function cBoxChanged(cbx,btn1,lab1,btn2,lab2,btn3,lab3)
    val = cbx.Value;
    if val
        btn1.Enable = 'on';
        lab1.Enable = 'on';
        btn2.Enable = 'on';
        lab2.Enable = 'on';
        btn3.Enable = 'on';
        lab3.Enable = 'on';
    else
        btn1.Enable = 'off';
        lab1.Enable = 'off';
        btn2.Enable = 'off';
        lab2.Enable = 'off';
        btn3.Enable = 'off';
        lab3.Enable = 'off';
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
    
    %Epoching
    param.todo.eyes_epoching = cbxEpoch.Value;
    if cbxEpoch.Value
        %param.path.datatoepoch = param.path.data;
        param.epoching.triggerlabel = efTrigger.Value;
        param.epoching.timelimits = [beginTriggerVal.Value endTriggerVal.Value];
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
end