function p03_microstates_segmentation(settings)
%vCH
%% Description
% Perform one, two or three levels of segmentation, depending on the user'settings
% choices
% current Options:
% - Multiple sessions per participant -> 3 levels: Session, Participant, Group
% - Single session per participant -> 2 levels: Participant, Group
% - Single session per participant & 1 clustering -> 1 level: Participant

%% MULTIPLE SESSIONS
if settings.multipleSessions %three levels of clustering : session, participant and group
%% FIRST LEVEL CLUSTERING : Sessions
% FOR EACH n : MS    
    %input file : gfp folder
    gfpFolder = dir(settings.path.gfp); %first level clustering on gfp peaks
    gfpFolder = gfpFolder(contains({gfpFolder.name},'sub'));    
    for i=1:length(gfpFolder)%for each participant
        participantgfpFolder = dir([gfpFolder(i).folder, filesep, gfpFolder(i).name]); %participant folder directory
        sessiongfpFolder = participantgfpFolder(contains({participantgfpFolder.name},'ses')); % each session of this participant
        for j=1:length(sessiongfpFolder) %for each session of each participant
                %outputfile: session folder
                outputSession = [settings.path.session,gfpFolder(i).name,filesep,sessiongfpFolder(j).name,filesep];
                pl_microstates_Segmentation(sessiongfpFolder(j), outputSession,settings,1);
        end
    end
%% SECOND LEVEL CLUSTERING : Participants
    sessionFolder = dir(settings.path.session); %second level clustering on sessions
    sessionFolder = sessionFolder(contains({sessionFolder.name},'sub'));
    for k=1:length(sessionFolder)
        outputParticipant = [settings.path.participant,sessionFolder(k).name,filesep];
        pl_microstates_Segmentation(sessionFolder(k), outputParticipant, settings,2);
    end
%% THIRD LEVEL CLUSTERING : Group
    participantFolder = dir(settings.path.results);
    p_char =  char(extractBetween(settings.path.participant,settings.path.results,filesep)); % how the participant folder is called
    participantFolder = participantFolder(contains({participantFolder.name},p_char));
    outputGroup = settings.path.group;
    pl_microstates_Segmentation(participantFolder, outputGroup, settings,3);
    
%% SINGLE SESSION
else % Case single Session : 2 levels of clustering : participant and group
%% FIRST LEVEL CLUSTERING : Participants    
    pl_microstates_participantSegmentation(settings);
%% SECOND LEVEL CLUSTERING : Group    
    pl_microstates_groupSegmentation(settings);
end
end