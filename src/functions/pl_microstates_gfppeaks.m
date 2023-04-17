function pl_microstates_gfppeaks(inputfolder,outputfolder,s)
%% Description
% input: inputfolderpath for the current subject, outputfolderp., s
% using this path, the following input files are loaded:
% - info-file
% - eeg data
% output (saved directly to the outputfolder):
% - gfp peaks file
% use: get gfp peak maps for each session or each participant

%% INPUT
%input path and names
fp_input = [inputfolder.folder,filesep,inputfolder.name,filesep];
fn_info = 'info.mat';
fn_eegdata = 'eegdata.mat';
% do both input files exist?
input_files_exist = exist([fp_input,fn_eegdata],'file') == 2 && exist([fp_input,fn_info],'file') == 2;
%% OUTPUT
%output path and names
fp_output = [outputfolder,filesep];
fp_output_plots = [fp_output, 'plots', filesep];
if ~isfolder(fp_output_plots)
    mkdir(fp_output_plots);
end
fn_gfppeaks= 'gfppeaks.mat';
fn__plot_gfppeaks =  'gfppeaks';
output_files_exist = exist([fp_output,fn_gfppeaks],'file') == 2;
%%
% if all input exists & output does not exist yet (or should be
% overriden), continue
if input_files_exist && (~output_files_exist || s.todo.override)
    % if override & output files exist, delete them
    if s.todo.override && output_files_exist
        delete([fp_output,fn_gfppeaks]);
    end
    
    %% load info file, add some defaults & load segmented data
    disp(['..loading ',fp_input,fn_info]);
    load([fp_input,fn_info],'info')
    info.numgfppeaks= 0;
    
        %load segmented eegdata
        disp(['..loading ',fp_input,fn_eegdata]);
        load([fp_input,fn_eegdata],'EEG')
        
        %% try gfp peak detection & get peaks
        try
            
            %how many peaks should be taken
            if s.microstate.gfppeaks.takeAllPeaks % if all available peaks should be taken
                Npeaks = eval('info.numsamples'); % Npeaks = maximum peaks possible (= total amount of data points)
            else % if only a subset of the peaks should be taken
                Npeaks = s.microstate.gfppeaks.Npeaks; % Npeaks = predetermined number
            end
            
            %get GFP peaks
            EEG = pop_micro_selectdata( ...
                EEG, ...
                [], ... % no ALLEEG, because data gets only taken from current subject (one eeg structure)
                'datatype',    s.microstate.gfppeaks.datatype, ...
                'avgref',      s.microstate.gfppeaks.avgref, ...
                'normalise',   s.microstate.gfppeaks.normalise, ...
                'MinPeakDist', s.microstate.gfppeaks.MinPeakDist, ...
                'Npeaks',      Npeaks, ... % if Npeaks >= available GFP peaks, all the peaks get taken
                'GFPthresh',   s.microstate.gfppeaks.GFPthresh);
            
            %plot the taken peaks & save it
            plot(std(EEG.microstate.data,1))
            saveas(gcf,[fp_output_plots, fn__plot_gfppeaks], 'png')
            close;
            
            %create structure with gfp peak data only
            CEEG = EEG.microstate.data;
            
            %update info file
            eval(['info.numgfppeaks_','=size(CEEG,2);']); % number of peaks of current subject
            
            %save gfp peaks
            save([fp_output,fn_gfppeaks],'CEEG');
            
            %save chanlocs (needed in the section below)
            chanlocs = EEG.chanlocs;
            fn_chanlocs = 'chanlocs.mat';
            save([fp_output,fn_chanlocs],'chanlocs');
            
        catch
            disp('!! Error in gfp peak extraction!!')
        end
        
        %save info file
        save([fp_output,fn_info],'info');
        
end