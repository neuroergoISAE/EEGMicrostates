%% p04_microstates_reordering.m
% Author :  C.Hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script reoders the microstates prototype according to the users' inputs
% Input: settings, structure containing all settings for the analysis
% Output: reordered cluster for the last level and each number of cluster (microstates)

function p04_microstates_reordering(settings)

if settings.todo.microstates_reordering
    lastLevel = char(settings.levels(end)); % last segmentation (clustering) level
    level_path = eval(['settings.path.',lastLevel]);
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; % for the cluster new names
    for h = settings.microstate.Nmicrostates
        %% REORDER THE LAST LEVEL PROTOTYPES
        disp(['p04: (nMS = ',num2str(h),') - reordering ',lastLevel,'-level prototypes']);
        
        microstates_path = dir([level_path,'**',filesep,'*microstate*.mat']); %path containing all prototypes .mat files
        microstates_path = microstates_path(contains({microstates_path.name},['prototypes_',num2str(h),'MS'])& ...
            ~contains({microstates_path.name},'reordered')); %exclude already reordered files, will be overriden if required
        
        for i=1:length(microstates_path) %reorder each MS prototype found in the path (1 for group level, Nb participants for participant level, Nb participants * Nb sessions for session level)
            fn_microstates = [microstates_path(i).folder,filesep,microstates_path(i).name];
            fn_microstates_ordered = insertBefore(fn_microstates,'.mat','_reordered'); % name for the reordered file
            fn_plot = [microstates_path(i).folder,filesep,'plots',filesep,lastLevel,'_microstate_prototypes_',num2str(h),'MS']; %.png?
            fn_plot_ordered = [fn_plot,'_reordered'];
            
            if (exist(fn_microstates,'file')==2 && ~(exist(fn_microstates_ordered,'file')==2)) || settings.todo.override
                if settings.todo.override && exist(fn_microstates_ordered,'file')==2
                    delete(fn_microstates_ordered); % if override required: delete already present ordered files
                end
               
                load([microstates_path(i).folder,filesep,'chanlocs.mat'],'chanlocs');%load chanlocs
   
                disp(['..loading ',fn_microstates])
                load(fn_microstates,'microstate'); %load the last level microstate prototypes (not ordered)
                
                samplePrototypes = microstate.prototypes;             
            end
        end
        
        %% ask for user to reorder the prototuypes by visual inspection & order them accordingly
        orderingCompleted = 0;
        while ~orderingCompleted
            for k = 1:h %create indices for the different microstate classes
                eval(['idx_MS.', alphabet(k), ' = 0;']); %idx_MS. ??
            end
            
            mycolormap = customcolormap_preset(settings.customColorMap.colors);%plot not-ordered prototypes
            for i = 1:h
                subplot(1,h,i);
                topoplot(samplePrototypes(:,i),chanlocs, 'maplimits', settings.customColorMap.range);
                title(i); % add title
                set(gcf,'color','w'); % set backround color to white
                colormap(mycolormap); % use customized color map
            end
            
            %ask for the user to input the new order
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            disp('REORDERING OF THE MICROSTATES PROTOTYPES');
            disp(['cluster size = ', num2str(h), ' MS']);
            disp('  ');
            
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
            
            %plot the ordered prototypes
            mycolormap = customcolormap_preset(settings.customColorMap.colors);

            for q = 1:h
                subplot(1,h,q);
                topoplot(samplePrototypes_ordered(:,q),chanlocs, 'maplimits', settings.customColorMap.range,'style','both');
                title(q); % add title                set(gcf,'color','none'); %set backround color to white
                colormap(mycolormap); %use customized color map
            end
            %aks for validation of the new order
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            disp('MICROSTATES PROTOTYPES REORDERED')
            disp('CORRECT ORDER ?')
            orderingCompleted = input('correct (yes = 1, no = 0)? ');
            
            %save reordered microstates prototypes and plots
            if orderingCompleted
                microstate_ordered = samplePrototypes_ordered;
                disp(['..saving ',fn_microstates_ordered]);
                save(fn_microstates_ordered,'microstate_ordered');
                disp(['..saving ',fn_plot_ordered]);
                exportgraphics(gcf,[fn_plot_ordered,'.png'],'Resolution',600) %the resolution can be changed for lighter files
            end
            close; %close the figure
        end
        clear samplePrototypes_ordered microstate_ordered
               
    end  
    %% REORDER SUB LEVELS according to the last level reordered microstates prototypes 
    for h = settings.microstate.Nmicrostates
        ordered_microstates_path = dir([level_path,'**',filesep,'*',num2str(h),'MS_reordered.mat']); 
        load([ordered_microstates_path.folder,filesep,ordered_microstates_path.name],'microstate_ordered');% load ordered microstates prototypes for this number of cluster
        for lev = 1:length(settings.levels)-1 %for each sub levels 
            level = char(settings.levels(lev)); % current level
            folder = dir(eval(['settings.path.',level]));
            folder = dir([folder(1).folder,filesep,'**',filesep,'*microstate_prototypes_',num2str(h),'MS.mat']); %all prototypes to reorder
            for i= 1:numel(folder) % for each file in this level
                disp(['p04 (nMS = ',num2str(h),') : reordering ',level,' level prototypes: ', num2str(i),filesep, num2str(numel(folder))]);
                pl_microstates_reordering(folder(i),microstate_ordered,h,chanlocs,settings) % reordering
            end
        end
    end
end
clear samplePrototypes microstate
end