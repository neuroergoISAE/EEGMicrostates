%% pl_microstates_stats.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script computes the backfitting results stats for all participants/session and on all levels
% Dependencies : EEGlab, customcolormap
% Inputs :
% - eeg_data :  eeg data of the participant/session, on which the backfitting will be applied 
% - fp_lastlevel_prototypes : directory of the prototypes used for the last level backfitting (group level)
% - h : number of microstates cluster
% - s : structure containing all settings
% Outputs: stats>csv>stats_'level'_backfit_'n'MS.csv and  stats>table>stats_'level'_backfit_'n'MS.mat

function pl_microstates_stats(inputfolder,level,h,s)

    output_table = table; %empty table
    fn_output_mat = [s.path.tables,'stats_',level,'_backfit_',num2str(h),'MS.mat']; %output table with all files stats
    fn_output_csv = [s.path.csv,'stats_',level,'_backfit_',num2str(h),'MS.csv']; %output csv with all files stats

    if ~(exist(fn_output_csv,'file')==2 && exist(fn_output_mat,'file')==2) || s.todo.override
        %if override & files already exist, delete the files
        if s.todo.override && (exist(fn_output_mat,'file')==2 && exist(fn_output_csv,'file')==2)
            delete(fn_output_mat);
            delete(fn_output_csv);
        end
        %% For each participant/session
        for i=1:length(inputfolder)
            fn_microstate = [inputfolder(i).folder,filesep,inputfolder(i).name]; %backfitting file 
            if exist(fn_microstate,'file')==2 %if input file exist and output not (or override possible)
                file_table = table; %empty table for this file
                
                %% Participant Id and Session (if existing)
                file_IDs = extractBetween(fn_microstate,s.path.backfitting,inputfolder(i).name);
                file_IDs =split(file_IDs,'\'); %if multiple sessions : will show ses number and sub id
                file_IDs = file_IDs(~cellfun('isempty',file_IDs)); 
                file_table.subjectID = char(file_IDs(1));% participant id
                if length(file_IDs)>1 % participant session if existing
                    file_table.session = char(file_IDs(2)); 
                end

                %% Microstates Stats
                load(fn_microstate,'microstate');
                %loop over microstates input variables
                for vn = s.microstate.metrics
                    vals = microstate.stats.(vn{1}); %get values from input variable
                    if length(vals)==1 %if single value
                        %add value to output table
                        colname = sprintf('%s',lower(vn{1}));
                        file_table.(colname) = vals; % add to file table
                    else %if multiple values (for each microstates)
                        for j = 1:length(vals)
                            colname = sprintf('%s%d',lower(vn{1}),j);
                            file_table.(colname) = vals(j); % add to file table
                        end
                    end
                    clear vals;
                end
                %% Add this file stats to output table
                if size(file_table,2)>1
                    %add missing columns as NaN values
                    output_colnames = output_table.Properties.VariableNames;
                    file_colnames = file_table.Properties.VariableNames;
                    
                    %test if non existing column in file_table
                    ind = ones(1,length(output_colnames));
                    for vn = file_colnames
                        ind(contains(output_colnames,vn))= 0;
                    end
                    output_colnames=output_colnames(logical(ind));
                    for vn = output_colnames
                        file_table.(vn{1})=NaN;
                    end
                    clear hdrRef hdr ind vn;
                    
                    output_table = cat(1, output_table, file_table);%add subject stats to output table
                end
            end
        end
        %% Save microstate stats as .mat table
            disp(['..saving ',fn_output_mat])
            save(fn_output_mat,'output_table')

        %% Save microstate features as .csv file
            disp(['..saving ',fn_output_csv])
            writetable(output_table, fn_output_csv, 'Delimiter', ',');
    end
end
