function [param, cancel] = paramGUI

backgroundColor = '#141414';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
gui_fig = uifigure('position',[745 200 800 700], 'Color', backgroundColor); %
param = struct();[param.path.src, param.path.datatoepoch ,param.path.data, param.path.eeglab] = deal("");
guidata(gui_fig,param);
uilabel(gui_fig,'Text',"Microstates Analysis Parameters",'Position',[0 660 800 30], 'HorizontalAlignment','center','FontSize',fontsize+4,'FontWeight','Bold','FontColor', foregroundColor, 'FontSize', 20);

%% panels
path_panel = uipanel(gui_fig, 'Position', [50 420 700 170], 'BackgroundColor', backgroundColor,'Title','Directories Selection ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
eyes_panel = uipanel(gui_fig, 'Position', [50 330 700 70], 'BackgroundColor', backgroundColor,'Title','Eyes Epoching ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
session_panel = uipanel(gui_fig,'Position', [50 210 700 100], 'BackgroundColor' , backgroundColor,'Title','Sessions ','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
backfit_panel = uipanel(gui_fig,'Position', [50 80 700 100], 'BackgroundColor' , backgroundColor,'Title','Backfitting','FontSize',fontsize+2,'ForegroundColor', foregroundColor);
%Project Name
uilabel(gui_fig,'Text',"Project Name : ",'Position',[55 620 150 30],'FontSize',fontsize+2,'FontColor', foregroundColor);
efname = uieditfield(gui_fig,'Position',[200 620 550 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
%% labels
l_global=uilabel(path_panel,'Text',pwd,'Position',[40 60 325 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
l_eeglab = uilabel(path_panel,'Text','D:\eeglab\eeglab2023.0','Position',[380 60 325 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');
%Global Path
btnSrcPath = uibutton(path_panel,'push', 'Text', 'Select Source Folder Directory',...
    'Position', [30 95 300 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnSrcPath.ButtonPushedFcn = @selectSrcDirectory;
%Eeglab Path
btnEEGLabPath = uibutton(path_panel,'push', 'Text', 'Select EEGLab Directory',...
    'Position', [370 95 300 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnEEGLabPath.ButtonPushedFcn = @selecteeglabDirectory;

btnInputPath = uibutton(path_panel,'push', 'Text', 'Select Input Data Directory','Enable','on',...
    'Position', [30 10 300 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnInputPath.ButtonPushedFcn = @selectInputDirectory;
l_inputData = uilabel(path_panel,'Text','','Position',[350 10 325 30],'FontSize',fontsize,'FontColor', foregroundColor,'FontAngle','Italic');

%% Closed Eyes extraction
efTrigger = uieditfield(eyes_panel,'Position',[330 5 50 30],'Value','EC','Enable','off',...
    'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
l_trigger = uilabel(eyes_panel,'Text','Trigger Label','Position',[385 5 120 30],'FontSize',fontsize,'FontColor', foregroundColor,'Enable','off');
efTriggerVal = uieditfield(eyes_panel,'numeric','Limits',[0 Inf],'RoundFractionalValues','on','Position',[510 5 50 30],'Enable','off',...
   'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
l_triggerVal = uilabel(eyes_panel,'Text','Trigger Duration','Position',[565 5 120 30],'FontSize',fontsize,'FontColor', foregroundColor,'Enable','off');

cbxEyes = uicheckbox(eyes_panel,'Text','Add Epoch (Closed Eyes) Extraction','Value', 0,...
                  'Position',[30 5 300 30],'Fontcolor',foregroundColor,'FontSize',fontsize,'ValueChangedFcn',...
                   @(cbxEyes,event) cBoxChanged(cbxEyes,efTrigger,l_trigger,efTriggerVal,l_triggerVal,btnInputPath));

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


%% Ok Button
ok_btn = uibutton(gui_fig, 'Position', [300 20 200 40],'Text','Save Parameters',...
    'FontWeight','Bold','BackgroundColor',backgroundColor,'FontSize',fontsize+2,...
    'FontColor',foregroundColor, 'ButtonPushedFcn',@(src,event) okButtonPushed());

%% FUNCTIONS
waitfor(gui_fig);
    function selectSrcDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.src = directory;%[directory,filesep];
        l_global.Text = param.path.src;
        guidata(src,param)
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
function cBoxChanged(cbx,btn1,lab1,btn2,lab2,btn3)
    val = cbx.Value;
    if val
        btn1.Enable = 'on';
        lab1.Enable = 'on';
        btn2.Enable = 'on';
        lab2.Enable = 'on';
        btn3.Enable = 'on';
    else
        btn1.Enable = 'off';
        lab1.Enable = 'off';
        btn2.Enable = 'off';
        lab2.Enable = 'off';
        btn3.Enable = 'off';
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
function okButtonPushed()
    param.name = efname.Value;
    if param.path.src == ""
            param.path.src = l_global.Text ;
    end
    if param.path.eeglab == ""
            param.path.eeglab = l_eeglab.Text ;
    end
    
    %Epoching
    param.todo.eyes_epoching = cbxEyes.Value;
    if cbxEyes.Value
        param.path.datatoepoch = param.path.data;
        param.epoching.triggerlabel = efTrigger.Value;
        param.epoching.timelimits = [0 efTriggerVal.Value];
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
    disp(bg_session.SelectedObject)
    close(gui_fig);
end
end