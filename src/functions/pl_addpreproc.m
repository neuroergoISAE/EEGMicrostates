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
function pl_addpreproc(inputfolder, s)
%% Check existing files
fp_eeg = [inputfolder.folder,filesep,inputfolder.name,filesep,'eeg',filesep]; % eeg data folder
fn_eeg = dir(fp_eeg);
fn_eeg = fn_eeg(contains({fn_eeg.name},'.mat')& ~contains({fn_eeg.name},'reduced'));  % eeg data file

fp_output_gfp = [s.path.gfp,inputfolder.name]; %save output eegdata directly in gfp folder as well (will then skip pl_load_data.m)

if ~isfolder(fp_output_gfp)
    mkdir(fp_output_gfp)
end
fp_output_gfp = [fp_output_gfp,filesep,'eegdata.mat'];
%% Load the EEG file
disp(['..loading ',fn_eeg.folder,filesep,fn_eeg.name])
load([fn_eeg.folder,filesep,fn_eeg.name],'EEG');
%% Filtering & average-referencing

%apply notch filter
EEG = pop_eegfiltnew(EEG, ...
    s.preproc.notch.low, ... %default : 48
    s.preproc.notch.high, ... % default : 52
    [], ... %[]=default filter order
    1); %'revfilt'=1 for notch

%apply bandpass filter
EEG = pop_eegfiltnew(EEG, ...
    s.preproc.bandpass.low, ... %default : 2
    s.preproc.bandpass.high); % default : 20

%re-referencing to average
if s.preproc.avgref
    EEG = pop_reref(EEG,[]);
end

%% Epoch data depending on the trigger label and the trigger timelimits
EEG = pop_epoch(EEG,s.preproc.EClabel, s.preproc.timelimits);
EEG = eeg_epoch2continuous(EEG);

%% Exclude bad data segements (i.e. amplitude too high)
    tmin= 0; tmax=2;
    points_per_epoch = (tmax - tmin) * EEG.srate;
    epochs = zeros(EEG.nbchan, points_per_epoch, floor(EEG.pnts/points_per_epoch));
    for i = 1:size(epochs, 3)
        epochs(:,:,i) = EEG.data(:, (i-1)*points_per_epoch + 1:i*points_per_epoch);
    end
    EEG_epoch = EEG;
    EEG_epoch.data = epochs;
    EEG_epoch.pnts = points_per_epoch;
    EEG_epoch.trials = size(epochs, 3);
    EEG_epoch.xmin = tmin;
    EEG_epoch.xmax = tmax;

    % Select good segments
    amp_threshold = s.preproc.mvmax; % in microvolts
    max_amplitudes = max(max(abs(EEG_epoch.data), [], 1), [], 2); %maximum absolute amplitude in each epoch
    max_amplitudes = squeeze(max_amplitudes);
    good_epochs = max_amplitudes < amp_threshold;

    if sum(good_epochs)<size(EEG_epoch.data,3)
        EEG_epoch = pop_select(EEG_epoch, 'trial', find(good_epochs));%Select only the good epochs
        EEG = eeg_epoch2continuous(EEG_epoch);
    else
        EEG = eeg_epoch2continuous(EEG_epoch); % Concatenate the good epochs into continuous data
    end
    data_length = EEG.pnts / EEG.srate; % Length in seconds

%% Check if enough samples and Save output file
    if data_length < 20 %% 20 SECONDES
        disp(['..skipping this file because not enough (good) samples: ',inputfolder.name]) % skip subject
    else %if not enough sample
        disp(['save : ', inputfolder.name, ' and : ', fp_output_gfp ]);
        save(fp_output_gfp,'EEG');
    end
end