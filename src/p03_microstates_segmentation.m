%% p03_microstates_segmentation.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : April 2023
% Description : this script performs one, two or three levels of segmentation, depending on the users settings choices
% current options:
% - Multiple sessions per participant -> 3 levels: Session, Participant, Group
% - Single session per participant -> 2 levels: Participant, Group
% - Single session per participant & 1 clustering -> 1 level: Participant
% Dependencies : EEGlab
% Inputs : settings, structure containing all settings for the analysis
% Outputs: clustering on each level 

function p03_microstates_segmentation(settings)

fp_gfp = dir(settings.path.gfp); %first level clustering on gfp peaks
fp_gfp = fp_gfp(~contains({fp_gfp.name},'.'));

if settings.multipleSessions % Multiple Sessions
    %% SESSION LEVEL CLUSTERING
    for i=1:length(fp_gfp)%for each participant
        fp_gfp_participant = dir([fp_gfp(i).folder, filesep, fp_gfp(i).name]); %participant folder directory
        fp_gfp_session = fp_gfp_participant(~contains({fp_gfp_participant.name},'.')); %each session of this participant
        for j=1:length(fp_gfp_session) %for each session of each participant
            outputSession = [settings.path.session,fp_gfp(i).name,filesep,fp_gfp_session(j).name,filesep];%outputfile: session folder
            pl_microstates_segmentation(fp_gfp_session(j), outputSession,1,settings); %level 1: session
        end
    end
    %% PARTICIPANT LEVEL CLUSTERING (Multiple Sessions)
    fp_session = dir(settings.path.session); %second level clustering on sessions
    fp_session = fp_session(~contains({fp_session.name},'.'));
    for k=1:length(fp_session) % for each participant
        outputParticipant = [settings.path.participant,fp_session(k).name,filesep]; %outputfile: participant folder
        pl_microstates_segmentation(fp_session(k), outputParticipant,2, settings); %level 2: participant
    end
    grouplevelnum = 3;
else % Single Session
    %% PARTICIPANT LEVEL CLUSTERING (Single Session)
     for k=1:length(fp_gfp) %for each participant
        outputParticipant = [settings.path.participant,fp_gfp(k).name,filesep];%outputfile: participant folder
        pl_microstates_segmentation(fp_gfp(k), outputParticipant,1, settings); %level 1: participant
     end
    grouplevelnum = 2;
end
    %% GROUP LEVEL CLUSTERING 
    fp_participant = dir(settings.path.results);
    p_char =  char(extractBetween(settings.path.participant,settings.path.results,filesep)); %how the participant folder is called
    fp_participant = fp_participant(contains({fp_participant.name},p_char));
    outputGroup = settings.path.group; %outputfile: group folder
    pl_microstates_segmentation(fp_participant, outputGroup,grouplevelnum, settings);% level 2 or 3 : group (level 3 if multiple sessions, 2 if single sessions)
    
end