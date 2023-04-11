function pl_microstates_reordering(toreorder_folder,s,lastlevel_orderedmicrostates,nMS,chanlocs)

  warning('off');
  fn_microstates = [toreorder_folder.folder,filesep,toreorder_folder.name];
  fn_microstates_ordered = insertBefore(fn_microstates,'.mat','_reordered'); % name for the reordered file
  
  fn_plot = [toreorder_folder.folder,filesep,'plots',filesep,erase(toreorder_folder.name,'.mat')]; %.png?
  fn_plot_ordered = [fn_plot,'_reordered'];

  %only perform the backfitting if input file is present, output file is not present,
  %(or if override is requested and input file is present)..
  if ((exist(fn_microstates,'file')==2) && (~(exist(fn_microstates_ordered,'file')==2)))|| (s.todo.override && (exist(fn_microstates,'file')==2))
      %if override & old ordered individual prototypes exist, delete them
      if s.todo.override && (exist(fn_microstates_ordered,'file')==2)
          delete(fn_microstates_ordered);
      end 
      
      %% ordering of microstates prototype
      %load the microstate prototype to reorder
      load(fn_microstates,'microstate'); 
      maps2sort(1,:,:) = microstate.prototypes'; %needed to be transposed and in 3D for the function below
      clear microstate
      
      %compare the individual prototypes with the sample-level prototypes
      %to get the appropriate sort order using a function of thomas koenig
      [~,SortOrder, Communality, polarity] = ArrangeMapsBasedOnMean(maps2sort,lastlevel_orderedmicrostates',s.microstate.ordering.polarity);
      
      %order the individual microstates
      microstate_ordered(:,:) =  squeeze(maps2sort(1,:,:))'; %back to 2D & transpose back
      microstate_ordered = microstate_ordered(:,SortOrder(1,:)); %apply the obtained sort order
      
      %plot the ordered prototypes
      %t = tiledlayout(1,nMS);
      mycolormap = customcolormap_preset(s.figure.customColorMap.colors);
      for q = 1:nMS
          %nexttile
          subplot(1,nMS,q);
          topoplot(microstate_ordered(:,q),chanlocs, 'maplimits', s.figure.customColorMap.range);
          set(gcf,'color','w'); % set backround color to white
          colormap(mycolormap); % use customized color map
      end 

      %save the reordered protos & the corresponding plots
      disp(['..saving ',fn_microstates_ordered]);
      save(fn_microstates_ordered,'microstate_ordered')
      saveas(gcf,fn_plot_ordered,'png')
      close;
  end
end