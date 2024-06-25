%% p03_microstates_segmentation.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script performs one, two or three levels of segmentation, depending on the users settings choices
% current options:
% - Multiple sessions per participant -> 3 levels: Session, Participant, Group
% - Single session per participant -> 2 levels: Participant, Group
% - Single session per participant & 1 clustering -> 1 level: Participant
% Dependencies : EEGlab
% Inputs : settings, structure containing all settings for the analysis
% Outputs: cluster for each level and each number of microstates
% 
% function p03_microstates_segmentation(settings)
% 
% if settings.todo.microstates_segmentation
%     fp_gfp = dir(settings.path.gfp); %first level clustering on gfp peaks
%     fp_gfp = fp_gfp(~contains({fp_gfp.name},'.'));
%     
%     if settings.multipleSessions % Multiple Sessions
%         %% if only group clustering (no session and participant clustering)
%         if settings.levels(1)=="group"
%             inputfolder = dir(settings.path.gfp);
%             inputfolder = inputfolder(contains({inputfolder.name},'group'));
%             pl_microstates_segmentation(inputfolder, settings.path.group,1,settings); %level 1: session
%             %% if participant AND group clustering (no session clustering)
%         elseif settings.levels(1) == "participant" & settings.levels(2) == "group"
%             for k=1:length(fp_gfp) %for each participant
%                 outputParticipant = [settings.path.participant,fp_gfp(k).name,filesep];%outputfile: participant folder
%                 pl_microstates_segmentation(fp_gfp(k), outputParticipant,1, settings); %level 1: participant
%             end
%             grouplevelnum = 2;
%         else
%             %% if session AND partiicpant AND group clustering
%             % SESSION LEVEL CLUSTERING
%             for i=1:length(fp_gfp)%for each session
%                 fp_gfp_participant = dir([fp_gfp(i).folder, filesep, fp_gfp(i).name]); %participant folder directory
%                 fp_gfp_session = fp_gfp_participant(~contains({fp_gfp_participant.name},'.')); %each session of this participant
%                 for j=1:length(fp_gfp_session) %for each session of each participant
%                     outputSession = [settings.path.session,fp_gfp(i).name,filesep,fp_gfp_session(j).name,filesep];%outputfile: session folder
%                     pl_microstates_segmentation(fp_gfp_session(j), outputSession,1,settings); %level 1: session
%                 end
%             end
%             % PARTICIPANT LEVEL CLUSTERING (Multiple Sessions)
%             fp_session = dir(settings.path.session); %second level clustering on participant
%             fp_session = fp_session(~contains({fp_session.name},'.'));
%             for k=1:length(fp_session) % for each participant
%                 outputParticipant = [settings.path.participant,fp_session(k).name,filesep]; %outputfile: participant folder
%                 pl_microstates_segmentation(fp_session(k), outputParticipant,2, settings); %level 2: participant
%             end
%             grouplevelnum = 3;
%         end
%     else
%         %% Single Session
%         %PARTICIPANT LEVEL CLUSTERING (Single Session)
%         for k=1:length(fp_gfp) %for each participant
%             outputParticipant = [settings.path.participant,fp_gfp(k).name,filesep];%outputfile: participant folder
%             pl_microstates_segmentation(fp_gfp(k), outputParticipant,1, settings); %level 1: participant
%         end
%         grouplevelnum = 2;
%     end
%     %% GROUP LEVEL CLUSTERING
%     fp_participant = dir(settings.path.MS_results);
%     p_char =  char(extractBetween(settings.path.participant,[settings.path.MS_results,filesep],filesep)); %how the participant folder is called
%     fp_participant = fp_participant(contains({fp_participant.name},p_char));
%     outputGroup = settings.path.group; %outputfile: group folder
%     pl_microstates_segmentation(fp_participant, outputGroup,grouplevelnum, settings);% level 2 or 3 : group (level 3 if multiple sessions, 2 if single sessions)
%     
% end
% 
% end

function p03_microstates_segmentation(settings)
%% THREE CASES :
% -session/participant/group (multiple sessions)
% -participant/group (single or multiple sessions)
% -group (single or multiple sessions)
fp_gfp = dir(settings.path.gfp); %first level clustering on gfp peaks
fp_gfp = fp_gfp(~contains({fp_gfp.name},'.'));
% FIRST LEVEL (segmentation on GFP)
if settings.levels(1)=="group" %ONE LEVEL CLUSTERING
    inputfolder = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    pl_microstates_segmentation(inputfolder, settings.path.group,1,settings); %level 1: session
elseif settings.levels(1) == "participant" %&& settings.levels(2) =="group" % TWO LEVELS CLUSTERING
    % First level clustering : participant
     fp_gfp = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    for k=1:length(fp_gfp) % for each participant
        inputfolder =fp_gfp(k);
        folder_name = extractAfter(fp_gfp(k).folder,settings.path.gfp);
        outputfolder = [settings.path.participant,folder_name,filesep]; %outputfile: participant folder
        pl_microstates_segmentation(inputfolder, outputfolder,1, settings); %level 1: participant, level 2: group
    end
elseif settings.levels(1) == "session"
    fp_gfp = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    for k=1:length(fp_gfp) % for each session
        inputfolder =fp_gfp(k);
        folder_name = extractAfter(fp_gfp(k).folder,settings.path.gfp);
        outputfolder = [settings.path.session,folder_name,filesep]; %outputfile: session folder
        pl_microstates_segmentation(inputfolder, outputfolder,1, settings); %level 2: participant
    end
end
% SECOND LEVEL (if exists)
if length(settings.levels)> 1 
    if settings.levels(2) =="group"
        fp_participant = dir(settings.path.MS_results);
        p_char =  char(extractBetween(settings.path.participant,[settings.path.MS_results,filesep],filesep)); %how the participant folder is called
        fp_participant = fp_participant(contains({fp_participant.name},p_char));
        outputGroup = settings.path.group; %outputfile: group folder
        pl_microstates_segmentation(fp_participant, outputGroup,2, settings);% level 2 group   
    elseif settings.levels(2) == "participant"
            fp_session = dir(settings.path.session); %second level clustering on participant
            fp_session = fp_session(~contains({fp_session.name},'.'));    
            for k=1:length(fp_session) % for each participant
                inputfolder =fp_session(k);
                outputfolder = [settings.path.participant,fp_session(k).name,filesep]; %outputfile: participant folder
                pl_microstates_segmentation(inputfolder, outputfolder,2, settings); %level 2: participant
            end
    end
end
% THIRD LEVEL (if exists)
if length(settings.levels)> 2
    if settings.levels(3) =="group"
        fp_participant = dir(settings.path.MS_results);
        p_char =  char(extractBetween(settings.path.participant,[settings.path.MS_results,filesep],filesep)); %how the participant folder is called
        fp_participant = fp_participant(contains({fp_participant.name},p_char));
        outputGroup = settings.path.group; %outputfile: group folder
        pl_microstates_segmentation(fp_participant, outputGroup,3, settings);% level 2 or 3 : group (level 3 if multiple sessions, 2 if single sessions)
    
    end
end
    
        
    
    
    
%     
%     
%     if settings.multipleSessions % Multiple Sessions
%         %% if session AND partiicpant AND group clustering
%         % SESSION LEVEL CLUSTERING
%         for i=1:length(fp_gfp)%for each session
%             fp_gfp_participant = dir([fp_gfp(i).folder, filesep, fp_gfp(i).name]); %participant folder directory
%             fp_gfp_session = fp_gfp_participant(~contains({fp_gfp_participant.name},'.')); %each session of this participant
%             for j=1:length(fp_gfp_session) %for each session of each participant
%                 outputSession = [settings.path.session,fp_gfp(i).name,filesep,fp_gfp_session(j).name,filesep];%outputfile: session folder
%                 pl_microstates_segmentation(fp_gfp_session(j), outputSession,1,settings); %level 1: session
%             end
%         end
%         % PARTICIPANT LEVEL CLUSTERING (Multiple Sessions)
%         fp_session = dir(settings.path.session); %second level clustering on participant
%         fp_session = fp_session(~contains({fp_session.name},'.'));
%         for k=1:length(fp_session) % for each participant
%             outputParticipant = [settings.path.participant,fp_session(k).name,filesep]; %outputfile: participant folder
%             pl_microstates_segmentation(fp_session(k), outputParticipant,2, settings); %level 2: participant
%         end
%         grouplevelnum = 3;
%     else
%         %% Single Session
%         %PARTICIPANT LEVEL CLUSTERING (Single Session)
%         for k=1:length(fp_gfp) %for each participant
%             outputParticipant = [settings.path.participant,fp_gfp(k).name,filesep];%outputfile: participant folder
%             pl_microstates_segmentation(fp_gfp(k), outputParticipant,1, settings); %level 1: participant
%         end
%         grouplevelnum = 2;
%     end
%     %% GROUP LEVEL CLUSTERING
%     fp_participant = dir(settings.path.MS_results);
%     p_char =  char(extractBetween(settings.path.participant,[settings.path.MS_results,filesep],filesep)); %how the participant folder is called
%     fp_participant = fp_participant(contains({fp_participant.name},p_char));
%     outputGroup = settings.path.group; %outputfile: group folder
%     pl_microstates_segmentation(fp_participant, outputGroup,grouplevelnum, settings);% level 2 or 3 : group (level 3 if multiple sessions, 2 if single sessions)
% end
end
