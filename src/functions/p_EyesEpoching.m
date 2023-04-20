function p_EyesEpoching(inputfolder,outputfolder,s)
%% Automagic : check bad channels 
%% Epoch EC 
% Data Quality rating
 %create an info file to have an overview on the overall data quality
    %this always must be created again to be accurate (because files
    %considered to be bad are always checked again in the
    %pl_load_segment_data-function)
    info_dataQuality = {};
    info_dataQuality.nofile = 0;
    info_dataQuality.nofile_IDs = {};
    if s.data.checkqualityratings
        info_dataQuality.badautomagic = 0;
        info_dataQuality.badautomagic_IDs = {};
    end
    info_dataQuality.zerodata = 0;
    info_dataQuality.zerodata_IDs = {};
    info_dataQuality.badtrigger = 0;
    info_dataQuality.badtrigger_IDs = {};
    info_dataQuality.insufficienteyesclosed = 0;
    info_dataQuality.insufficienteyesclosed_IDs = {};
    
 %% set output filepath and filename
  fp_output = [outputfolder,inputfolder.name,filesep]; % fp ~ file path
  if ~isfolder(fp_output) % if fp_output is not a directory
    mkdir(fp_output); % make it a directory 
  end
  fn_info = 'info.mat'; % fn ~ file name
%   fn_eegdata = 'eegdata.mat';
  fn_eegdata_eyesclosed = 'eegdata_eyesclosed.mat';
%   fn_eegdata_eyesopen = 'eegdata_eyesopen.mat'; 

  %check if all outputfiles exist
  allfilepathnames = {};
  allfilepathnames(1,end+1) = {[fp_output,fn_info]}; % end + 1 -> add a column
%   allfilepathnames(1,end+1) = {[fp_output,fn_eegdata]};
  allfilepathnames(1,end+1) = {[fp_output,fn_eegdata_eyesclosed]};
%   allfilepathnames(1,end+1) = {[fp_output,fn_eegdata_eyesopen]};
  ind = [];
  for fpn = allfilepathnames
    ind(1,end+1)=exist(fpn{1})==2; % exist(fpn{1}) yields 2, if file exists already
    % if file does not exist, a 0 gets added to ind, otherwhise a 1 (file exists) 
  end
  all_files_exist = sum(ind)==length(ind); % do all the files exist?
  
  %if not all output files exist or (||) override requested, continue
  if ~all_files_exist || settings.todo.override 
      %if override requested & old process folder of the subject exists..
      if settings.todo.override && (exist(fp_output) == 7)
          try
          rmdir(fp_output, 's') %..delete it with all the files in it (just to really start from scratch again)
          mkdir(fp_output) %and create the folder again
          end
      end 
           
    %% info file creation for current subject
    %make info file (meta data for the current subject)
    info = [];
    info.subjectID = inputfolder.name;
    info.inputpath = [inputfolder.folder,filesep, inputfolder.name,filesep, 'eeg', filesep,]; 
    info.inputname = ''; % empty  character array
    info.inputpathname = '';
    info.outputpath = '';
    info.qualityrating = '';
    info.numsamples_eyesclosed = 0;
    info.numsamples_eyesopen = 0;
    info.nofile = false;
    info.zerodata = false;

    %% check if file of interest in the input folder ("RestingState_EEG.mat"-file)
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
      info_dataQuality.nofile = info_dataQuality.nofile + 1; %update info file of the overall data quality
      info_dataQuality.nofile_IDs{end+1} = info.subjectID;
    else % if files of interests exist..
      % update info file 
      info.inputname = [files.name];
      if settings.data.checkqualityratings
      info.qualityrating = info.inputname(1);
      end 
      info.inputpathname = [files.folder,filesep,files.name];
      
    %% check rating, load data & check if zero data
    % if rating should be checked AND rating insufficient (sum = 0), skip processing
    if settings.data.checkqualityratings &&...
            sum(strcmp(settings.data.qualityratings, info.qualityrating)) == 0 
        disp(['..skipping due to unsufficient automagic rating: ',inputfolder.name]) %skip subject
        info_dataQuality.badautomagic = info_dataQuality.badautomagic + 1; %update info file of the data quality
        info_dataQuality.badautomagic_IDs{end+1} = info.subjectID;
    else % rating is sufficient (or should not be checked)
  
      %load the EEG file
      disp(['..loading ',files.folder,filesep,files.name])
      load([files.folder,filesep,files.name],'EEG');
      %check if some zero/empty EEG, add to info structure
      info.zerodata = (min(EEG.data(:))==0) && (max(EEG.data(:))==0); % true if both max. and min. amplitude of all data points equals 0
      %add filepath and name to info 
      info.inputpathname = [files.folder,filesep,files.name];

      % if zero data, skip processing
      if info.zerodata %if not zero/empty EEG
          disp(['..skipping because zero data available: ',inputfolder.name]) % skip subject
          info_dataQuality.zerodata = info_dataQuality.zerodata + 1; %update info file of the data quality
          info_dataQuality.zerodata_IDs{end+1} = info.subjectID;
      else        
          %% Filtering & average-referencing
          
          %apply notch filter 
          EEG = pop_eegfiltnew(EEG, ...
            settings.spectro.notch.lpf, ...
            settings.spectro.notch.hpf, ...
            [], ... %[]=default filter order
            1); %'revfilt'=1 for notch
        
          %apply bandpass filter
          EEG = pop_eegfiltnew(EEG, ...
            settings.spectro.bandpass.lpf, ...
            settings.spectro.bandpass.hpf);
        
          %re-referencing to average
          if settings.averageref == 1
            EEG = pop_reref(EEG,[]);
          end
          
          %update info file
          info.outputpath = fp_output;

%           %save continuous EEG (filtered etc.)
%           save([fp_output,fn_eegdata],'EEG'); 

          %make a copy of the continuous data
          EEG_cnt = EEG;
          
          %% extract eyes-closed data

          %loop over eye conditions
          for eyes = {'eyesclosed'} %,'eyesopen'}
            
              % Segmentation, cuts out segments interest (e.g. eyesclosed only), and concatenates them into a "continuous" dataset
              EEG = RestingSegment(EEG_cnt,settings.segment.(eyes{1})); % settings.segment.(eyes{1}): information about events & timelimits
            
              %% exclude bad data segements (i.e. amplitude too high)
                      
              % extract snippets of X seconds out of EEG.data
              EEG.data = epoch(EEG.data,1:settings.spectro.winlength:size(EEG.data,2),...
                  settings.spectro.timelimits); %segments the data in non-overlapping epochs of 2sec/1000sp length
              EEG.pnts = size(EEG.data,2);
              EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate;
              EEG.trials = size(EEG.data,3);

              % find the good segments (amplitude below treshold)
              EEG.goodsegments = [];
              for g = 1:size(EEG.data,3) % for all epochs (mostly 90)
              clear A
              A = EEG.data(:,:,g); % g -> current epoch
              if all(abs(A(:)) < settings.spectro.mvmax)  % tests if all recorded samples are below mV max (e.g. 90 mV)
              EEG.goodsegments(end+1) = g;
              end
              end
              EEG.data = EEG.data(:,:,EEG.goodsegments);

              % put it back to continuous EEG format and cleanup the EEG structure
              EEG.trials = length(EEG.goodsegments);
              EEG.data = reshape(EEG.data,[EEG.nbchan,EEG.pnts*EEG.trials]); 
              EEG.pnts = size(EEG.data,2);
              EEG.trials = size(EEG.data,3);
              EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate;

              % update info-file
              eval(['info.numsamples_',eyes{1},'= EEG.pnts;']); % 'info.numsamples_eyesclosed= EEG.pnts;' wird ausgeführt
              
              % only continue (i.e. save it) if there are enough samples
              if eval(['info.numsamples_',eyes{1}, '<=', num2str(settings.nGoodSamples)]) % if not enough samples
                  disp(['..skipping',eyes{1},'-file because not enough (good) samples: ',inputfolder.name]) % skip subject
                  eval(['info_dataQuality.insufficient',eyes{1},' = '...
                      ,'info_dataQuality.insufficient',eyes{1} ,' + 1;']); %update info file of the data quality
                  eval(['info_dataQuality.insufficient',eyes{1}, '_IDs{end+1} = info.subjectID']);
                  
              else %else: there are enough samples
              %save segmented and concatenated EEG
              fn = ['eegdata_',eyes{1},'.mat']; 
              save([fp_output,fn],'EEG'); 
              end
          end
      end
    end
    end 
    %save the info file (for the subject)
    save([fp_output,fn_info],'info'); 
end