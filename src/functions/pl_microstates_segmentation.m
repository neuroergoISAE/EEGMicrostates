function pl_microstates_segmentation(inputfolder,outputfolder,levelnum,s)

%% try gfp peak detection & get peaks
level = s.levels{levelnum};

%% microstate segmentation/ clustering
%% load data for this segmentation

%output
fp_output_plots = [outputfolder, 'plots', filesep];
if ~isfolder(fp_output_plots)
    mkdir(fp_output_plots);
end
for u = s.microstate.Nmicrostates %loop over microstate models (~ number of clusters)
    
    try
        %% Load Input Data
        disp('.. load data');
        if strcmp(level,s.levels{1}) %first level : GFP as input
            disp([inputfolder.folder,filesep,inputfolder.name,filesep,'gfppeaks.mat']);
            load([inputfolder.folder,filesep,inputfolder.name,filesep,'gfppeaks.mat'],'CEEG'); %leao gfppeaks as CEEG variable
            load([inputfolder.folder,filesep,inputfolder.name,filesep,'chanlocs.mat'],'chanlocs'); %load chanlocs
        else
            previouslevel =  s.levels{levelnum-1};
            %% Append all files of the inferior level (input) for the clustering
            CEEG = [];
            %if  s.multipleSessions %previous folder is one folder up
                previouslevelFolder = [inputfolder.folder,filesep,inputfolder.name,filesep];
                previouslevelFolder = dir(previouslevelFolder); %participant level : all sessions. Groupe level : all participants
            %else
                %previouslevelFolder = dir(inputfolder.folder);
            %end
            previouslevelFolder = previouslevelFolder(~ismember({previouslevelFolder.name},{'.','..'})); %remove parent folders
            load([previouslevelFolder(1).folder,filesep,previouslevelFolder(1).name,filesep,'chanlocs.mat'],'chanlocs'); %load chanlocs of 1st folder (same for all)
            
            for l=1:length(previouslevelFolder)%Participant level : for each session. Group level : for each participant
                disp(['..collect data from',previouslevelFolder(l).name]);
                plFolder = [previouslevelFolder(l).folder,filesep,previouslevelFolder(l).name,filesep];

                %% Merge prototype on one table
                     previous_prototypes = [previouslevel ,'_microstate_prototypes_', num2str(u), 'MS.mat'];

                try
                    if (exist([plFolder,previous_prototypes],'file')==2)
                        load([plFolder,previous_prototypes],'microstate'); %prototypes of this file
                        CEEG = cat(2,CEEG,microstate.prototypes); %add prototype file to the table
                    end
                catch
                    disp('Previous level file not found');
                end
                clear microstate
                clear plfolder
            end
        end
        
        %save CEEG in output folder
        disp('..saving collected prototypes');
        save([outputfolder,'collected_prototypes.mat'],'CEEG','-v7.3');
        %save chanlocs for next level clustering
        save([outputfolder,'chanlocs.mat'],'chanlocs');
        %transform the gfp peak data into a proper eeg structure (needed
        %for the clustering)
        EEG = eeg_emptyset();
        EEG.setname = 'GFPpeakmaps';
        EEG.chanlocs = chanlocs;
        EEG.nbchan = length(chanlocs);
        EEG.trials = 1;
        EEG.srate = s.sr;
        EEG.data = CEEG; % Data to Cluster
        EEG.pnts = size(EEG.data,2);
        EEG.times = (1:size(EEG.data,2))*1000/EEG.srate;
        EEG.nbchan = size(EEG.data,1);
        EEG.microstate.data = EEG.data; % = CEEG
        
        %segment resp. cluster the data
        EEG = pop_micro_segment( ...
            EEG, ...
            'algorithm',      s.microstate.algorithm, ...
            'sorting',        s.microstate.sorting, ...
            'normalise',      s.microstate.normalise, ...
            'Nmicrostates',   u, ...
            'verbose',        s.microstate.verbose, ...
            'Nrepetitions',   s.microstate.Nrepetitions, ...
            'fitmeas',        s.microstate.fitmeas, ...
            'max_iterations', s.microstate.max_iterations, ...
            'threshold',      s.microstate.threshold, ...
            'optimised',      s.microstate.optimised);
        
        %save (individual) segmentation results (incl. individual prototypes)
        Microstate = EEG.microstate;
        disp(['..saving ',outputfolder,level,'_microstate_segmentation_',num2str(u),'MS.mat']);
        save([outputfolder,level,'_microstate_segmentation_',num2str(u),'MS.mat'],'Microstate','-v7.3');

        
        %make and save the figure showing the prototypes of all the
        %different microstate models
        figure;
        MicroPlotTopo( EEG, 'plot_range', [] );
        fn_plots_nMS = [level,'_microstate_prototypes_', num2str(u), 'MS'];
        disp(['..saving ',outputfolder,fn_plot]);
        %saveas(gcf,[fp_output_plots,fn_plots_nMS],'png'); % gcf: returns the current figure handle
        close;
        
        %save the different microstate models resp. the different sets of
        %prototypes (e.g. the set with four prototypes)
        %% Microstate Semgentation
            EEG_u = pop_micro_selectNmicro( ...
                EEG, ...
                'Measures', {'CV', 'GEV'}, ...
                'do_subplots', 1,...
                'Nmicro', u);

            fn_prototypes = [level,'_microstate_prototypes_', num2str(u), 'MS.mat'];
            microstate = EEG_u.microstate;
            disp(['..saving ',outputfolder,fn_prototypes]);
            save([outputfolder,fn_prototypes, ],'microstate','-v7.3');

            %make and save the prototype figure for the current microstate model
            %using a customized color map
            mycolormap = customcolormap_preset(s.figure.customColorMap.colors);
            for i = 1:u
                subplot(1,u,i);
                topoplot(EEG_u.microstate.prototypes(:,i),chanlocs, 'maplimits', s.figure.customColorMap.range);
                set(gcf,'color','w'); % set backround color to white
                colormap(mycolormap); % use customized color map
            end
            saveas(gcf,[fp_output_plots,fn_plots_nMS],'png');
            close;
        clear EEG microstate EEG_u
       
    catch
       disp('!! Error in clustering !!')
    end
end