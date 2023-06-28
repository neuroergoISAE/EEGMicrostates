%% pl_microstates_backfitting.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script backfits the eeg data on each requested level and for requested each number of cluster (microstates) 
% Dependencies : EEGlab, customcolormap
% Inputs :
% - eeg_data :  eeg data of the participant/session, on which the backfitting will be applied 
% - fp_lastlevel_prototypes : directory of the prototypes used for the last level backfitting (group level)
% - h : number of microstates cluster
% - s : structure containing all settings
% Outputs: backfitting>sub>ses>'level'_microstate_backfitting_'n'MS.mat or backfitting>sub>'level'_microstate_backfitting_'n'MS.matfiles 


function pl_microstates_backfitting(eeg_data, fp_lastlevel_prototypes,h, s)

lastLevel = char(s.levels(end)); % last segmentation (clustering) level
%% Extract subject id and session
fn_ID = char(extractBetween(eeg_data,s.path.gfp,'eegdata.mat'));
fp_output = [s.path.backfitting,fn_ID]; %backfitting output name for this eegdata participant/session file

if ~isfolder(fp_output)
    mkdir(fp_output); %if output folder does not exist: folder creation
end

%% Backfitting on the requested level prototypes (mandatory: group level)
for l = s.backfittingLevels 
    level = char(l);
    switch level
        case 'session' 
            fp_prototypes =  dir([s.path.session,fn_ID]);
            fp_prototypes = fp_prototypes(contains({fp_prototypes.name},extractAfter(fp_lastlevel_prototypes.name,lastLevel)));
            fn_prototypes = [fp_prototypes.folder,filesep,fp_prototypes.name]; %session level reordered microstates prototypes
        case 'participant' 
            fp_prototypes =  dir([s.path.participant,extractBefore(fn_ID,filesep)]); % participant folder extracted from eegdata folder name, session removed if necesseray
            fp_prototypes = fp_prototypes(contains({fp_prototypes.name},extractAfter(fp_lastlevel_prototypes.name,lastLevel)));
            fn_prototypes = [fp_prototypes.folder,filesep,fp_prototypes.name]; %participant level reordered microstates prototypes
        case 'group'
            fn_prototypes = [fp_lastlevel_prototypes.folder,filesep,fp_lastlevel_prototypes.name] ; %group level reordered microstates prototypes
    end
    fn_eeg = eeg_data;
    fn_output = [fp_output,level,'_microstate_backfitting_',num2str(h),'MS.mat']; %output for the current level backfitting on input eeg data
    
    
    if (exist(fn_prototypes,'file')==2 && exist(fn_eeg,'file')==2 && ~(exist(fn_output,'file')==2)) ||...
            (s.todo.override && exist(fn_prototypes,'file')&& exist(fn_eeg,'file')==2)%if all input file exist. Output files does not exist or can be overriden        
        if s.todo.override && (exist(fn_output,'file')==2)
            delete(fn_output);%if override & old backfitting result exists, delete it
        end
        
        %% BACKFITTING
        %load the EEG data
        disp(['..loading ',fn_eeg])
        load(fn_eeg,'EEG');
        
        %load the microstate prototypes
        disp(['..loading ',fn_prototypes])
        load(fn_prototypes,'microstate_ordered');
        
        %add prototypes to EEG data
        EEG.microstate = [];
        EEG.microstate.prototypes = microstate_ordered;
        clear microstate_ordered;
        
        %perform the backfitting
        EEG = pop_micro_fit(EEG,'polarity', s.microstate.backfitting.polarity);
        
        %temporally smooth microstates labels
        EEG = pop_micro_smooth(EEG, ...
            'label_type',  s.microstate.backfitting.label_type, ...
            'smooth_type', s.microstate.backfitting.smooth_type, ...
            'minTime',     s.microstate.backfitting.minTime, ...
            'polarity',    s.microstate.backfitting.polarity);
        
        %calculate microstate statistics
        EEG = pop_micro_stats(EEG, ...
            'label_type', s.microstate.backfitting.label_type, ...
            'polarity',   s.microstate.backfitting.polarity);
        
        microstate = EEG.microstate;
        
        %save the microstate backfitting results
        disp(['..saving ',fn_output])
        save(fn_output,'microstate')
        
        clear microstates
        
    end  
end
end