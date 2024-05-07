%% pl_microstates_reordering.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script reorders the microstates prototypes of each sub levels according to the last level reordered prototypes
% Dependencies : EEGlab, customcolormap
% Inputs :
% - toreorder_folder :  location of the microstates prototype to reorder
% - lastlevel_orderedmicrostates : reordered microstates prototypes (last level)
% - nMS : number of cluster
% - chanlocs : chanlocs file location
% - s : structure containing all settings
% Outputs: 'level'_microstate_prototype_'n'MS_reordered.mat and 'level'_microstate_prototype_'n'MS_reordered.png files for each participant/session and each level

function pl_microstates_reordering(toreorder_folder,lastlevel_orderedmicrostates,nMS,chanlocs,s)

  fn_microstates = [toreorder_folder.folder,filesep,toreorder_folder.name];
  fn_microstates_ordered = insertBefore(fn_microstates,'.mat','_reordered'); % name for the reordered file
  
  fn_plot = [toreorder_folder.folder,filesep,'plots',filesep,erase(toreorder_folder.name,'.mat')]; 
  fn_plot_ordered = [fn_plot,'_reordered']; % name for the reordered plot

  if ((exist(fn_microstates,'file')==2) && (~(exist(fn_microstates_ordered,'file')==2)))|| (s.todo.override && (exist(fn_microstates,'file')==2))
      %if override & old ordered individual prototypes exist, delete them
      if s.todo.override && (exist(fn_microstates_ordered,'file')==2)
          delete(fn_microstates_ordered);
      end 
      
      %% reordering of microstates prototype
      load(fn_microstates,'microstate');  %load the microstate prototype to reorder
      maps2sort(1,:,:) = microstate.prototypes'; %needed to be transposed and in 3D for the function below
      clear microstate
      
      %compare the individual prototypes with the sample-level prototypes
      %to get the appropriate sort order using a function of thomas koenig
      [~,SortOrder, Communality, polarity] = ArrangeMapsBasedOnMean(maps2sort,lastlevel_orderedmicrostates',s.microstate.orderingpolarity);
      
      %order the individual microstates
      microstate_ordered(:,:) =  squeeze(maps2sort(1,:,:))'; %back to 2D & transpose back
      microstate_ordered = microstate_ordered(:,SortOrder(1,:)); %apply the obtained sort order
      
      %plot the ordered prototypes
      mycolormap = customcolormap_preset(s.customColorMap.colors);
      for q = 1:nMS
          subplot(1,nMS,q);
          topoplot(microstate_ordered(:,q),chanlocs, 'maplimits', s.customColorMap.range);
          set(gcf,'color','w'); % set backround color to white
          colormap(mycolormap); % use customized color map
      end 

      %save the reordered prototypes & the corresponding plots
      disp(['..saving ',fn_microstates_ordered]);
      save(fn_microstates_ordered,'microstate_ordered')
      saveas(gcf,fn_plot_ordered,'png')
      close;
  end
end