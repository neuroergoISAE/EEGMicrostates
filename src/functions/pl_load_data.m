function pl_load_data(inputfolder,outputfolder,s)
%% Description
% Create epochs and check quality rating if required
%if not: create info file
%% If eyes epoching not done
if s.todo.eyes_epoching
    %p_EyesEpoching(inputfolder,outputfolder,s);
else
    %% load file
    fp_output = [outputfolder,inputfolder.name,filesep]; % fp ~ file path
    if ~isfolder(fp_output) % if fp_output is not a directory
        mkdir(fp_output); % make it a directory
    end
    fn_info = 'info.mat'; % fn ~ file name
    fn_eegdata = 'eegdata.mat';
    % do both eeg_files exist?
    all_files_exist = exist([fp_output,fn_eegdata],'file') == 2 && exist([fp_output,fn_info],'file') == 2;
    
    %if not all output eeg_files exist or (||) override requested, continue
    if ~all_files_exist || s.todo.override
        %if override requested & old process folder of the subject exists
        if s.todo.override && (exist(fp_output,'dir') == 7)
            try
                rmdir(fp_output, 's') %..delete it with all the eeg_files in it (just to really start from scratch again)
                mkdir(fp_output) %and create the folder again
            catch
                disp("Folder could not be remove");
            end
        end
        
        %% Info file creation for current subject
        inputfolder
        info = [];
        info.subjectID = inputfolder.name;
        info.inputpath = [inputfolder.folder,filesep, inputfolder.name,filesep, 'eeg', filesep];
        info.inputname = '';
        info.inputpathname = '';
        info.outputpath = '';
        info.numsamples = 0;
        info.nofile = false;
        info.zerodata = false;
        info
        %% check if file of interest in the input folder 
        eeg_files = dir(info.inputpath);
        eeg_files = eeg_files(...
            contains({eeg_files.name},'p') ...
            & contains({eeg_files.name},'.mat') ...
            & ~contains({eeg_files.name},'reduced') ... % string should not contain 'reduced'
            );
        %% Load EEG file
        disp('.. load eeg file'); 
        info.nofile = isempty(eeg_files); % true if no file
        if ~info.nofile % if no EEG file of interest available
            load([eeg_files.folder,filesep,eeg_files.name],'EEG'); % load EEG to determine Nsamples
            info.numsamples= EEG.pnts;
            % update info file
            info.inputname = [eeg_files.name];
            info.inputpathname = [eeg_files.folder,filesep,eeg_files.name];
            % only save this file if  enough samples
            if info.numsamples <= s.data.nGoodSamples % if not enough samples
                disp(['..skipping this file because not enough (good) samples: ',inputfolder.name]) % skip subject
            end
        else
            disp(['..skipping due to inexisting input file: ',inputfolder.folder,filesep,inputfolder.name]) % skip subject
        end

        %% Save Files in GFP directory
        disp(['..copying file in gfp directory: ',fp_output, fn_eegdata]);
        %save eegdata
        save([fp_output, fn_eegdata],'EEG');
        %save info file
        save([fp_output,fn_info],'info');
    end
end