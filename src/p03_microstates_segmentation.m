%% p03_microstates_segmentation.m
% Author : C.Hamery
% Date : 06.2024
% Description : this script performs one, two or three levels of segmentation, depending on the users settings choices
% Current options:
% - Multiple sessions & 3 clustering levels: Session, Participant, Group
% - Multiple sessions & 2 clustering levels: Participant, Group
% - Multiple sessions & 1 clustering level: Group
% - Single session & 2 levels: Participant, Group
% - Single session & 1 clustering level: Participant
% Input : settings, structure containing all settings for the analysis
% Output: cluster for each required level and each number of microstates

function p03_microstates_segmentation(settings)
fp_gfp = dir(settings.path.gfp); %first level clustering on gfp peaks
fp_gfp = fp_gfp(~contains({fp_gfp.name},'.'));
%% FIRST LEVEL (segmentation on GFP)
if settings.levels(1)=="group" % ONE LEVEL CLUSTERING
    inputfolder = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    pl_microstates_segmentation(inputfolder, settings.path.group,1,settings); %level 1: session
elseif settings.levels(1) == "participant" % TWO LEVELS CLUSTERING
    % First level clustering : participant
     fp_gfp = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    for k=1:length(fp_gfp) %for each participant
        inputfolder =fp_gfp(k);
        folder_name = extractAfter(fp_gfp(k).folder,settings.path.gfp);
        outputfolder = [settings.path.participant,folder_name,filesep]; %outputfile: participant folder
        pl_microstates_segmentation(inputfolder, outputfolder,1, settings); %level 1: participant, level 2: group
    end
elseif settings.levels(1) == "session"
    fp_gfp = dir([settings.path.gfp,'**',filesep,'gfppeaks.mat']); % all gfp peaks
    for k=1:length(fp_gfp) %for each session
        inputfolder =fp_gfp(k);
        folder_name = extractAfter(fp_gfp(k).folder,settings.path.gfp);
        outputfolder = [settings.path.session,folder_name,filesep]; %outputfile: session folder
        pl_microstates_segmentation(inputfolder, outputfolder,1, settings); %level 2: participant
    end
end
%% SECOND LEVEL (if exists)
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
%% THIRD LEVEL (if exists)
if length(settings.levels)> 2
    if settings.levels(3) =="group"
        fp_participant = dir(settings.path.MS_results);
        p_char =  char(extractBetween(settings.path.participant,[settings.path.MS_results,filesep],filesep)); %how the participant folder is called
        fp_participant = fp_participant(contains({fp_participant.name},p_char));
        outputGroup = settings.path.group; %outputfile: group folder
        pl_microstates_segmentation(fp_participant, outputGroup,3, settings);% level 2 or 3 : group (level 3 if multiple sessions, 2 if single sessions)
    
    end
end
end
