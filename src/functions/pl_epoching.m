%% pl_epoching.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads each of the eeg data, selects the epochs of interest (as requested)
% and saves the new eeg data in the EpochedData folder (which is then considered as the Data folder). This script also checks for the Number of sample and copies them in the gfp level folder for the next step of the analysis
% the purpose if this step is to simplify the later backfitting procedure and to ensure the data safety 
% Dependencies : EEGlab
% Inputs :
% - inputfolder :  location of the eeg data of each participant/session
% - outputfolder : location for the output eegdata_TriggerName.mat file (in EpochedData>sub>eeg or EpochedData>sub>ses>eeg folder) &nd location for the output eegdata.mat file (in gfp>sub or gfp>sub>ses folder)
% - s : structure containing all settings
% Outputs: eegdata_TriggerName.mat file for each participant/session in the EpochedData folder
function pl_epoching(inputfolder,outputfolder, s)
%% Check existing files
fp_eeg = [inputfolder.folder,filesep,inputfolder.name,filesep,'eeg',filesep]; % eeg data folder
fn_eeg = dir(fp_eeg);
fn_eeg = fn_eeg(contains({fn_eeg.name},'.mat')& ~contains({fn_eeg.name},'reduced'));  % eeg data file

fp_output = [s.path.data,filesep,outputfolder,filesep,'eeg']; % Epoched Data folder
fp_output_gfp = [s.path.gfp,outputfolder]; %save output eegdata directly in gfp folder as well (will then skip pl_load_data.m)
if ~isfolder(fp_output)
    mkdir(fp_output)
end
if ~isfolder(fp_output_gfp)
    mkdir(fp_output_gfp)
end
outputfolder = [fp_output,filesep,'eegdata_',s.epoching.triggerlabel,'.mat'];
fp_output_gfp = [fp_output_gfp,filesep,'eegdata.mat'];
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

%% Epoch data depending on the trigger label and the trigger timelimits
EEG = pop_epoch(EEG,s.epoching.triggerlabel, s.epoching.timelimits);
EEG.data = reshape(EEG.data,[EEG.nbchan,EEG.pnts*EEG.trials]); %EEG.data back to two dimensions (channels x timepoints)
% cleanup (so the appropriate info is saved in the eeg structure)
EEG.pnts = size(EEG.data,2); % number of final time points
EEG.trials = size(EEG.data,3); % number of trials, epochs (should equal 1)
EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate;

%% Exclude bad data segements (i.e. amplitude too high)

EEG.data = epoch(EEG.data,1:s.epoching.winlength:size(EEG.data,2),s.epoching.spectro.timelimits);% extract snippets of X seconds out of EEG.data
EEG.pnts = size(EEG.data,2); %segments the data in non-overlapping epochs of 2sec/1000sp length
EEG.times = 1: 1000/EEG.srate: size(EEG.data,2)*1000/EEG.srate;
EEG.times = 1:s.sr/EEG.srate : size(EEG.data,2)/s.sr/EEG.srate;
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

%% Check if enough samples

%% Save output file
disp(['save : ', outputfolder, ' and : ', fp_output_gfp ]);
save(outputfolder,'EEG');
save(fp_output_gfp,'EEG');
end