%% pl_microstates_gfppeaks.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script loads each of the eeg data, extracts the gfp peaks maps and save them in the gfp folder for each participant/session
% Dependencies : EEGlab
% Inputs :
% - inputfolder :  location of the eeg data of each participant/session
% - outputfolder : location for the output gfppeaks.mat and gfppeaks.png file (in gfp>sub> or gfp>sub>ses> folder)
% - s : structure containing all settings
% Outputs: gfppeaks.mat and gfppeaks.png files for each participant/session
function pl_microstates_gfppeaks(inputfolder,outputfolder,s)
%% Check existing files
fp_input = [inputfolder.folder,filesep,inputfolder.name,filesep];
fn_eegdata = 'eegdata.mat';
input_files_exist = exist([fp_input,fn_eegdata],'file') == 2 ; % check if input file exists

fp_output = [outputfolder,filesep];%output path and names
fp_output_plots = [fp_output, 'plots', filesep];
if ~isfolder(fp_output_plots)
    mkdir(fp_output_plots);
end
fn_gfppeaks= 'gfppeaks.mat';
fn__plot_gfppeaks =  'gfppeaks';
output_files_exist = exist([fp_output,fn_gfppeaks],'file') == 2; % check if output file already exists

if input_files_exist && (~output_files_exist || s.todo.override) %if gfppeaks (output) file does not exist or can be overriden
    if s.todo.override && output_files_exist
        delete([fp_output,fn_gfppeaks]); %override already existing gfppeaks file
    end
    
    %% load eegdata file
    
    disp(['..loading ',fp_input,fn_eegdata]);
    load([fp_input,fn_eegdata],'EEG')
    
    %% Gfp peak detection & get peaks
   % try
        %number of peaks : 
        if s.microstate.gfp.takeallpeaks %all available peaks should be taken
            Npeaks = EEG.pnts; % Npeaks = maximum peaks possible (= total amount of data points)
        else %only a subset of the peaks should be taken
            Npeaks = s.microstate.gfp.Npeaks; % Npeaks = predetermined number
        end
        
        %get GFP peaks
        EEG = pop_micro_selectdata( ...
            EEG, ...
            [], ... 
            'datatype',    s.microstate.gfp.datatype, ... %default : 'spontaneous'
            'avgref',      s.microstate.gfp.avgref, ... %default : 1
            'normalise',   s.microstate.gfp.normalise, ... %default : 1
            'MinPeakDist', s.microstate.gfp.MinPeakDist, ... %default : 10
            'Npeaks',      Npeaks, ... % if Npeaks >= available GFP peaks, all the peaks get taken
            'GFPthresh',   s.microstate.gfp.GFPthresh); %default  : 1
        
        %plot the taken peaks & save it
        plot(std(EEG.microstate.data,1))
        saveas(gcf,[fp_output_plots, fn__plot_gfppeaks], 'png')
        close;
        
        %create structure with gfp peak data only
        CEEG = EEG.microstate.data;
        
        %save gfp peaks
        save([fp_output,fn_gfppeaks],'CEEG');
        
        %save chanlocs (needed in the section below)
        chanlocs = EEG.chanlocs;
        fn_chanlocs = 'chanlocs.mat';
        save([fp_output,fn_chanlocs],'chanlocs');
        
   % catch
       % disp('!! Error in gfp peak extraction!!')
   %end
end