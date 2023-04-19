function [param, cancel] = paramGUI

backgroundColor = '#121212';
foregroundColor = '#FFFFFF';
fontsize = 16;
cancel = 0;
gui_fig = uifigure('position',[745 420 700 500], 'Color', backgroundColor); %
param = struct("RSSelection","First","levelSelection","1st & 2nd Level","participantSelection","Participants (INTER)","sessionSelection","");
[param.projectName, param.path.global_path, param.path.raw_Data, param.path.eeglab] = deal("");
guidata(gui_fig,param);
uilabel(gui_fig,'Text',"Microstates Analysis Parameters",'Position',[0 460 500 30], 'HorizontalAlignment','center','FontSize',fontsize+2,'FontColor', foregroundColor, 'FontSize', 20);

%% panels
eyes_panel = uipanel(gui_fig, 'Position', [40 100 420 100], 'BackgroundColor', backgroundColor);
%% labels
l_eeglab = uilabel(gui_fig,'Text','','Position',[300 320 240 30],'FontSize',fontsize,'FontColor', foregroundColor);
l_raw= uilabel(eyes_panel,'Text','','Position',[40 10 420 30],'FontSize',fontsize,'FontColor', foregroundColor);
l_global=uilabel(gui_fig,'Text','' ,'Position',[300 360 240 30],'FontSize',fontsize,'FontColor', foregroundColor);


%Project Name
uilabel(gui_fig,'Text',"Project Name : ",'Position',[40 430 420 30],'FontSize',fontsize,'FontColor', foregroundColor);
project_name = uieditfield(gui_fig,'Position',[40 400 400 30],"ValueChangedFcn",@projectnameField,'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
%Global Path
btnGlobalPath = uibutton(gui_fig,'push', 'Text', 'Select Global Project Directory',...
    'Position', [40 360 250 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnGlobalPath.ButtonPushedFcn = @selectGlobalDirectory;
%Eeglab Path
btnEEGLabPath = uibutton(gui_fig,'push', 'Text', 'Select EEGLab Directory',...
    'Position', [40 320 250 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnEEGLabPath.ButtonPushedFcn = @selecteeglabectory;


% Raw Data Path
btnRawDataPath= uibutton(eyes_panel,'push', 'Text', 'Select Raw Data Directory','Enable','off',...
    'Position', [30 40 250 30],'FontSize',fontsize, 'BackgroundColor', backgroundColor, 'FontColor',foregroundColor);
btnRawDataPath.ButtonPushedFcn = @selectRawPathDirectory;
% Closed Eyes extraction
cbxEyes = uicheckbox(eyes_panel,'Text','Add Closed Eyes Extraction','Value', 0,...
                  'Position',[30 70 420 30],'Fontcolor',foregroundColor,'FontSize',fontsize,'ValueChangedFcn', @(cbxEyes,event) cBoxChanged(cbxEyes,btnRawDataPath));


%% FUNCTIONS
waitfor(gui_fig);
    function projectnameField(src,~)
        param = guidata(src);
        param.projectName = src.Value;
        guidata(src,param);
    end
    function selectGlobalDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.global_path = directory;%[directory,filesep];
        l_global.Text = param.path.global_path;
        guidata(src,param)
    end
    function selectRawPathDirectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.raw_Data = directory;%[directory,filesep];
        guidata(src,param)
        l_raw.Text = param.path.raw_Data;
    end
    function selecteeglabectory(src,~)
        directory = uigetdir();
        param = guidata(src);
        param.path.eeglab = directory;%[directory,filesep];
        l_eeglab.Text = param.path.eeglab;
        guidata(src,param)
    end
function cBoxChanged(cbx,btn)
    val = cbx.Value;
    if val
        btn.Enable = 'on';
    else
        btn.Enable = 'off';
    end
end
             
% 
% 
% % Participant or Patients
% bgParticipants = uibuttongroup('Parent',set_panel,'Position',[225, 95 ,160 75],'Title',"Analysis type", 'BackgroundColor', backgroundColor,'ForegroundColor',foregroundColor, "SelectionChangedFcn",@participantSelection);
% rbparticipant1 = uiradiobutton(bgParticipants,'Text',"Patients (INTRA)",'Position',[10 30 150 15],  'FontColor',foregroundColor);
% rbparticipant2 = uiradiobutton(bgParticipants,'Text',"Participants (INTER)",'Position',[10 10 150 15],  'FontColor',foregroundColor);
% set(bgParticipants,'SelectedObject',rbparticipant2);
% %if participants: single or multiple sessions
% bgSessions = uibuttongroup('Visible','on','Parent',set_panel,'Position',[225 10 160 75],'Title',"Sessions", 'BackgroundColor', backgroundColor,'ForegroundColor',foregroundColor, "SelectionChangedFcn",@sessionSelection);
% rbsession1 = uiradiobutton(bgSessions,'Text',"Single",'Position',[10 30 150 15],  'FontColor',foregroundColor);
% rbsession2 = uiradiobutton(bgSessions,'Text',"Multiple",'Position',[10 10 150 15],  'FontColor',foregroundColor);
% 
% uibutton(gui_fig,'push','Position',[200 32 100 30],'Text','Ok','ButtonPushedFcn',@ok_fun, 'BackgroundColor', backgroundColor,'FontColor',foregroundColor);
% 
% waitfor(gui_fig);
%     function projectnameField(src,~)
%         param = guidata(src);
%         param.projectName = src.Value;
%         guidata(src,param);
%     end
%     function selectGlobalDirectory(src,~)
%         directory = uigetdir();
%         param = guidata(src);
%         param.path.global_path = directory;%[directory,filesep];
%         uilabel(gui_fig,'Text', param.path.global_path,'Position',[260 360 240 30],'FontColor', foregroundColor);
%         guidata(src,param)
%     end
%     function selectRawPathDirectory(src,~)
%         directory = uigetdir();
%         param = guidata(src);
%         param.path.raw_Data = directory;%[directory,filesep];
%         guidata(src,param)
%         uilabel(gui_fig,'Text', param.path.raw_Data,'Position',[260 320 240 30],'FontColor', foregroundColor);
%         
%     end
%     function selecteeglabectory(src,~)
%         directory = uigetdir();
%         param = guidata(src);
%         param.path.eeglab = directory;%[directory,filesep];
%         uilabel(gui_fig,'Text',param.path.eeglab,'Position',[260 280 240 30],'FontColor', foregroundColor);
%         guidata(src,param)
%     end
% 
%     function RSSelection(src,event)
%         param = guidata(src);
%         param.RSSelection =event.NewValue.Text;
%         guidata(src,param);
%     end
%     function levelSelection(src,event)
%         param = guidata(src);
%         param.levelSelection =event.NewValue.Text;
%         guidata(src,param);
%     end
%     function participantSelection(src,event)
%         if rbparticipant2.Value == true
%             bgSessions.Visible = "on";
%         else
%             bgSessions.Visible = "off";
%             param.sessionSelection = "";
%             
%         end
%         param = guidata(src);
%         param.participantSelection =event.NewValue.Text;
%         guidata(src,param);
%     end
%     function sessionSelection(src,event)
%         param = guidata(src);
%         param.path.sessionSelection =event.NewValue.Text;
%         guidata(src,param);
%     end
% 
%     function ok_fun(src,~)
%         param = guidata(src);
%         param.projectName = project_name.Value;
%         guidata(src,param)
%         disp(param);
%         if ~strcmp({param.projectName, param.path.global_path, param.path.raw_Data,param.path.eeglab},"")
%             cancel = 1;
%             delete(gui_fig);
%             %% uj,
%         else
%             uilabel(gui_fig,'Text', 'Entrez tous les paramètres','Position',[0 5 500 30],'FontColor', '#B00020', 'HorizontalAlignment','center');
%         end
%         
%     end
end