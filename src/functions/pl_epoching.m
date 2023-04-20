function pl_epoching(inputfolder, s)

    fp_eeg = [inputfolder.folder,filesep,inputfolder.name,filesep,'eeg',filesep];
    fn_eeg = dir(fp_eeg);
    fn_eeg = fn_eeg(contains({fn_eeg.name},'.mat')& ~contains({fn_eeg.name},'reduced')); 
    
    
    fp_output = [s.path.data,filesep,inputfolder.name,filesep,'eeg'];
    if ~isfolder(fp_output)
        mkdir(fp_output)
    end
    fn_output = [fp_output,filesep,'eegdata_EC.mat'];
    %% Load the EEG file
      disp(['..loading ',fn_eeg.folder,filesep,fn_eeg.name])
      load([fn_eeg.folder,filesep,fn_eeg.name],'EEG');
    %% Filtering & average-referencing

      %apply notch filter 
      EEG = pop_eegfiltnew(EEG, ...
        s.epoching.notch.lpf, ... %default : 48
        s.epoching.notch.hpf, ... % default : 52
        [], ... %[]=default filter order
        1); %'revfilt'=1 for notch

      %apply bandpass filter
      EEG = pop_eegfiltnew(EEG, ...
        s.epoching.bandpass.lpf, ... %default : 2
        s.epoching.bandpass.hpf); % default : 20

      %re-referencing to average
      if s.epoching.averageref
        EEG = pop_reref(EEG,[]);
      end
      
      %% Epoch data 30 after trigger label
      EEG = pop_epoch(EEG,s.epoching.triggerlabel, s.epoching.timelimits);
      EEG.data = reshape(EEG.data,[EEG.nbchan,EEG.pnts*EEG.trials]); %EEG.data back to two dimensions (channels x timepoints)
      % cleanup (so the appropriate info is saved in the eeg structure)
      EEG.pnts = size(EEG.data,2); % number of final time points
      EEG.trials = size(EEG.data,3); % number of trials, epochs (should equal 1)
      EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate; 
         
      %% exclude bad data segements (i.e. amplitude too high)
      % extract snippets of X seconds out of EEG.data
      EEG.data = epoch(EEG.data,1:s.epoching.winlength:size(EEG.data,2),...
          s.epoching.timelimits); %segments the data in non-overlapping epochs of 2sec/1000sp length
      EEG.pnts = size(EEG.data,2);
      EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate;
      EEG.trials = size(EEG.data,3);

      % find the good segments (amplitude below treshold)
      EEG.goodsegments = [];
      for g = 1:size(EEG.data,3) % for all epochs (mostly 90)
        A = EEG.data(:,:,g); % g -> current epoch
        if all(abs(A(:)) < s.epoching.mvmax)  % tests if all recorded samples are below mV max (e.g. 90 mV)
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

      %% Save output file
      disp(['save : ', fn_output]);
      save(fn_output,'EEG'); 
end

      