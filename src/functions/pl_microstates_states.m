function pl_microstates_states(fp_microstates,level,h,s)


    output_table = table; %empty table
    fn_output_mat = [s.path.tables,'stats_',level,'_',num2str(h),'MS.mat']; % output table with all files stats
    fn_output_csv = [s.path.csv,'stats_',level,'_',num2str(h),'MS.csv']; % output csv with all files stats

    if ~(exist(fn_output_csv,'file')==2 && exist(fn_output_mat,'file')==2) || s.todo.override
        %if override & files already exist, delete the files
        if s.todo.override && (exist(fn_output_mat,'file')==2 && exist(fn_output_csv,'file')==2)
            delete(fn_output_mat);
            delete(fn_output_csv);
        end
        %% For each file
        for i=1:length(fp_microstates)

            fn_microstate = [fp_microstates(i).folder,filesep,fp_microstates(i).name];

            %if input file exist and output not (or override possible)

            if exist(fn_microstate,'file')==2

                % extract stats from this file and add it to the output table
                file_table = table; %empty table for this file
                
                %% Participant Id and Session (if existing)
                file_IDs = extractBetween(fn_microstate,s.path.backfitting,fp_microstates(i).name);
                file_IDs =split(file_IDs,'\'); %if multiple sessions : will show ses number and sub id
                file_IDs = file_IDs(~cellfun('isempty',file_IDs)); 
                file_table.subjectID = char(file_IDs(1));% participant id
                if length(file_IDs)>1 % participant session if existing
                    file_table.session = char(file_IDs(2)); 
                end

                %% Microstates Stats
                load(fn_microstate,'microstate');
                
                %loop over microstates input variables
                for vn = s.microstate.stats
                    %get values from input variable
                    vals = microstate.stats.(vn{1});
                    %if signle value
                    if length(vals)==1
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
                    %add subject stats to output table
                    output_table = cat(1, output_table, file_table);
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
