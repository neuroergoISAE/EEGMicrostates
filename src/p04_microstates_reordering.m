function p04_microstates_reordering(settings)
%% If required: Ask for reordering on last level

%if this step is required
if settings.todo.microstates_reordering==1
    lastLevel = char(settings.levels(end)); % last segmentation (clustering) level
    level_path = eval(['settings.path.',lastLevel]);
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; % for the cluster new names
    for h = settings.microstate.Nmicrostates
        %% reorder the last-level microstate prototypes
        disp(['p04: (nMS = ',num2str(h),') - reordering ',lastLevel,'-level prototypes']);
        %% Path
        microstates_path = dir([level_path,'**',filesep,'*microstate*.mat']); % Path containing all prototypes .mat files
        microstates_path = microstates_path(contains({microstates_path.name},['prototypes_',num2str(h),'MS'])& ...
            ~contains({microstates_path.name},'reordered')); % exclude already reordered files, will be overriden if required
        
        for i=1:length(microstates_path) % Reorder each MS prototype found in the path (1 for group level, Nb participants for participant level, Nb participants * Nb sessions for session level)
            %% Files
            fn_microstates = [microstates_path(i).folder,filesep,microstates_path(i).name];
            fn_microstates_ordered = insertBefore(fn_microstates,'.mat','_reordered'); % name for the reordered file
            fn_plot = [microstates_path(i).folder,filesep,'plots',filesep,lastLevel,'_microstate_prototypes_',num2str(h),'MS']; %.png?
            fn_plot_ordered = [fn_plot,'_reordered'];
            
            if (exist(fn_microstates,'file')==2 && ~(exist(fn_microstates_ordered,'file')==2)) || settings.todo.override
                if settings.todo.override && exist(fn_microstates_ordered,'file')==2
                    delete(fn_microstates_ordered); % if override required: delete already present ordered files
                end
                
                load([microstates_path(i).folder,filesep,'chanlocs.mat'],'chanlocs');
                %load the last level microstate prototypes (not ordered)
                disp(['..loading ',fn_microstates])
                load(fn_microstates,'microstate');
                samplePrototypes = microstate.prototypes;
                                
            end
            
        end
        
        %% decide how to order them by visual inspection & order them accordingly
        orderingCompleted = 0;
        while ~orderingCompleted
            
            %create indices for the different microstate classes
            for k = 1:h
                eval(['idx_MS.', alphabet(k), ' = 0;']); %idx_MS. ??
            end
            
            %plot not-ordered prototypes
            mycolormap = customcolormap_preset(settings.figure.customColorMap.colors);
           % t = tiledlayout(1,h);
            for i = 1:h
                %nexttile
                subplot(1,h,i);
                topoplot(samplePrototypes(:,i),chanlocs, 'maplimits', settings.figure.customColorMap.range);
                title(i); % add title
                set(gcf,'color','w'); % set backround color to white
                colormap(mycolormap); % use customized color map
            end
            
            %make a decision regarding the order
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            disp('REORDERING OF PROTOTYPES');
            disp(['cluster size = ', num2str(h), ' MS']);
            disp('  ');
            %                 disp('Description of position:');
            %                 disp('from left to right, from top to bottom');
            %                 disp('Example (four prototypes:');
            %                 disp('upper-right = 1; upper-left = 2');
            %                 disp('lower-right = 3; lower-left = 4');
            for p = 1:h
                disp(['Microstate ', alphabet(p), ' position ?']);
                disp(' ');
                idx_MS.(alphabet(p)) = input('position = ');
            end
            
            %reorder prototypes
            samplePrototypes_ordered = zeros(size(samplePrototypes));
            for t = 1:h
                samplePrototypes_ordered(:, t) = samplePrototypes(:, idx_MS.(alphabet(t)));
            end
            close;
            %plot the ordered prototypes...
            mycolormap = customcolormap_preset(settings.figure.customColorMap.colors);
            %t = tiledlayout(1,h);
            for q = 1:h
                %nexttile
                subplot(1,h,q);
                topoplot(samplePrototypes_ordered(:,q),chanlocs, 'maplimits', settings.figure.customColorMap.range);
                title(q); % add title
                set(gcf,'color','w'); %set backround color to white
                colormap(mycolormap); %use customized color map
            end
            %.. and check if the chosen order is correct
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            disp('PROTOTYPES REORDERED')
            disp('CORRECT ORDER ?')
            orderingCompleted = input('correct (yes = 1, no = 0)? '); % order correct?
            
            %if the order is correct, save the prototypes & the
            %corresponding plots
            if orderingCompleted
                microstate_ordered = samplePrototypes_ordered;
                disp(['..saving ',fn_microstates_ordered]);
                save(fn_microstates_ordered,'microstate_ordered');
                disp(['..saving ',fn_plot_ordered]);
                saveas(gcf,fn_plot_ordered,'png');
            end
            close; %close the figure
        end
        clear samplePrototypes_ordered microstate_ordered
        
       
    end
    
    
    %% REORDER SUB LEVELS
    for h = settings.microstate.Nmicrostates
        ordered_microstates_path = dir([level_path,'**',filesep,'*',num2str(h),'MS_reordered.mat']); 
        load([ordered_microstates_path.folder,filesep,ordered_microstates_path.name],'microstate_ordered');% load ordered microstates prototypes for this number of MS
        for lev = 1:length(settings.levels)-1
            level = char(settings.levels(lev)); % current level
            folder = dir(eval(['settings.path.',level]));
            folder = dir([folder(1).folder,filesep,'**',filesep,'*microstate_prototypes_',num2str(h),'MS.mat']); %all prototypes to reorder
            for i= 1:numel(folder) % for each file in this level
                disp(['p04 (nMS = ',num2str(h),') : reordering ',level,' level prototypes: ', num2str(i),filesep, num2str(numel(folder))]);
                pl_microstates_reordering(folder(i),settings,microstate_ordered,h,chanlocs)
            end
        end
    end
    
end
clear samplePrototypes microstate








%% Reorder on each existing sub level
end