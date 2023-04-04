function pl_load_data(inputfolder,outputfolder,s)
% vCH
%% Description
% Create epochs and check quality rating if required
%if not: create info file
%% If eyes epoching not done
if s.todo.eyes_epoching
    p_EyesEpoching(inputfolder,outputfolder,s);
else
    %% load file
    fp_output = [outputfolder,inputfolder.name,filesep]; % fp ~ file path
    if ~isfolder(fp_output) % if fp_output is not a directory
        mkdir(fp_output); % make it a directory
    end
    fn_info = 'info.mat'; % fn ~ file name
    fn_eegdata = 'eegdata.mat';
    % do both files exist?
    all_files_exist = exist([fp_output,fn_eegdata],'file') == 2 && exist([fp_output,fn_info],'file') == 2;
    
    %if not all output files exist or (||) override requested, continue
    if ~all_files_exist || s.todo.override
        %if override requested & old process folder of the subject exists
        if s.todo.override && (exist(fp_output,'dir') == 7)
            try
                rmdir(fp_output, 's') %..delete it with all the files in it (just to really start from scratch again)
                mkdir(fp_output) %and create the folder again
            catch
                disp("Folder could not be remove");
            end
        end
        
        %% info file creation for current subject
        %make info file (meta data for the current file)
        info = [];
        info.subjectID = inputfolder.name;
        info.inputpath = [inputfolder.folder,filesep, inputfolder.name,filesep, 'eeg', filesep,];
        info.inputname = '';
        info.inputpathname = '';
        info.outputpath = '';
        info.numsamples = 0;
        info.nofile = false;
        info.zerodata = false;
        
        %% check if file of interest in the input folder 
        files = dir(info.inputpath);
        files = files(...
            contains({files.name},'p') ...
            & contains({files.name},'.mat') ...
            & ~contains({files.name},'reduced') ... % string should not contain 'reduced'
            );
        info.nofile = isempty(files); % true if no file
        %if no files of interest in the folder, skip processing
        if info.nofile
            disp(['..skipping due to inexisting input file: ',inputfolder.folder,filesep,inputfolder.name]) % skip subject
        else % if files of interests exist..
            % update info file
            info.inputname = [files.name];
            info.inputpathname = [files.folder,filesep,files.name];
        end
        
        %copy eegdata in gfp directory
        disp(['..copying file in gfp direcotyr: ',files.folder,filesep,files.name]);
        copyfile([files.folder,filesep,files.name], [fp_output,fn_eegdata]);
        %save info file in gfp directory      
        save([fp_output,fn_info],'info');
    end
end