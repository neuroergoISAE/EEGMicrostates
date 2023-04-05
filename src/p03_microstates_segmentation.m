function p03_microstates_segmentation(s)
%vCH
%% Description
% Perform one, two or three levels of segmentation, depending on the user's
% choices
% current Options:
% - Multiple sessions per participant -> 3 levels: Session, Participant, Group
% - Single session per participant -> 2 levels: Participant, Group
% - Single session per participant & 1 clustering -> 1 level: Participant

%% MULTIPLE SESSIONS
if s.multipleSessions %three levels of clustering : session, participant and group
%% FIRST LEVEL CLUSTERING : Sessions
% FOR EACH n : MS    
    %input file : gfp folder
    gfpFolder = dir(s.path.gfp); %first level clustering on gfp peaks
    gfpFolder = gfpFolder(contains({gfpFolder.name},'sub'));    
    for i=1:length(gfpFolder)%for each participant
        participantgfpFolder = dir([gfpFolder(i).folder, filesep, gfpFolder(i).name]); %participant folder directory
        sessiongfpFolder = participantgfpFolder(contains({participantgfpFolder.name},'ses')); % each session of this participant
        for j=1:length(sessiongfpFolder) %for each session of each participant
                %outputfile: session folder
                outputSession = [s.path.session,gfpFolder(i).name,filesep,sessiongfpFolder(j).name,filesep];
                pl_microstates_Segmentation(sessiongfpFolder(j), outputSession,s,1);
        end
    end
%% SECOND LEVEL CLUSTERING : Participants
    sessionFolder = dir(s.path.session); %second level clustering on sessions
    sessionFolder = sessionFolder(contains({sessionFolder.name},'sub'));
    for k=1:length(sessionFolder)
        outputParticipant = [s.path.participant,sessionFolder(k).name,filesep];
        pl_microstates_Segmentation(sessionFolder(k), outputParticipant, s,2);
    end
%% THIRD LEVEL CLUSTERING : Group
    participantFolder = dir(s.path.results);
    p_char =  char(extractBetween(s.path.participant,s.path.results,'\')); % how the participant folder is called
    participantFolder = participantFolder(contains({participantFolder.name},p_char));
    outputGroup = s.path.group;
    pl_microstates_Segmentation(participantFolder, outputGroup, s,3);
    
%% SINGLE SESSION
else % Case single Session : 2 levels of clustering : participant and group
%% FIRST LEVEL CLUSTERING : Participants    
    pl_microstates_participantSegmentation(s);
%% SECOND LEVEL CLUSTERING : Group    
    pl_microstates_groupSegmentation(s);
end
end