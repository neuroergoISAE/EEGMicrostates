function pl_microstates_backfitting(eeg_data, fp_lastlevel_prototypes, s)
    %%
    %eeg_data : data to backfit on
    %lastlevel_prototypes: prototypes used for the lase level backfitting
    %(group level in majority of cases)
    %

    lastLevel = char(settings.levels(end)); % last segmentation (clustering) level
    %% Extract subject id and session (if existing)
    fn_ID = char(extractBetween(eeg_data,s.path.gfp,'eegdata.mat'));
    fp_output = [s.path.backfitting,fn_ID]; %backfitting output for this eegdata file (one/participant or /session if existing)
    %if output folder does not exist: folder creation

    if ~isfolder(fp_output)
        mkdir(fp_output);
    end

    %% Backfitting on the lastlevel prototypes (recommanded: group level)

    for l = 1:length(s.levels)
        
    end
    %if backfitting_level == GROUP : 
    fn_prototypes = [fp_lastlevel_prototypes.folder,filesep,fp_lastlevel_prototypes.name] ;
    fn_eeg = eeg_data;
    fn_output = [fp_output,'BACKFITRINGGROUP.mat']; %output for the ... Backfitting on this eeg data

    %if backfitting_level == SESSION : 
    fp_prototypes =  dir([s.path.session,fn_ID]);
    fp_prototypes = fp_prototypes(contains({fp_prototypes.name},extractAfter(fp_lastlevel_prototypes.name,lastLevel)));
    fn_prototypes = [fp_prototypes.folder,filesep,fp_prototypes.name]; % session level reordered microstates prototypes
    fn_eeg = eeg_data;
    fn_output = [fp_output,'BACKFITRINGGROUP.mat']; %output for the ... Backfitting on this eeg data

    %if backfitting level == PARTICIPANT
    level = s.levels(l);
    fp_prototypes =  dir([s.path.participant,extractBefore(fn_ID,filesep)]); % subject folder extracted from eegdata folder name, session removed if necesseray
    fp_prototypes = fp_prototypes(contains({fp_prototypes.name},extractAfter(fp_lastlevel_prototypes.name,lastLevel)));
    fn_prototypes = [fp_prototypes.folder,filesep,fp_prototypes.name]; % session level reordered microstates prototypes
    fn_eeg = eeg_data;
    fn_output = [fp_output,le'.mat']; %output for the ... Backfitting on this eeg data

    
    

    %if all input file exist. Output files does not exist or can be
    %overriden
    if (exist(fn_prototypes,'file')==2 && exist(fn_eeg,'file')==2 && ~(exist(fn_output,'file')==2)) ||...
            (s.todo.override && exist(fn_prototypes,'file')&& exist(fn_eeg,'file')==2)

        %if override & old backfitting result exists, delete it
        if s.todo.override && (exist(fn_output,'file')==2)
            delete(fn_output);
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
        EEG = pop_micro_fit(EEG,'polarity', settings.microstate.backfitting.polarity);

        %temporally smooth microstates labels
        EEG = pop_micro_smooth(EEG, ...
            'label_type',  settings.microstate.backfitting.label_type, ...
            'smooth_type', settings.microstate.backfitting.smooth_type, ...
            'minTime',     settings.microstate.backfitting.minTime, ...
            'polarity',    settings.microstate.backfitting.polarity);

        %calculate microstate statistics
        EEG = pop_micro_stats(EEG, ...
            'label_type', settings.microstate.backfitting.label_type, ...
            'polarity',   settings.microstate.backfitting.polarity);

        microstate = EEG.microstate;

        %save the microstate backfitting results
        disp(['..saving ',fn_out])
        save(fn_output,'microstate')
        
        clear microstates

    end
end