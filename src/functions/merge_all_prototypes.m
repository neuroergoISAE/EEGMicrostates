function peeg = merge_all_prototypes(peeg,y,folder,s,levelnum)
% vCH
%% Merge all microstates prototypes from previous level for the next level clustering
  previouslevel =  s.levels{levelnum-1};
  %input path and names
  fn_prototypes = [previouslevel ,'_microstate_prototypes_', num2str(y), 'MS.mat'];

  %if individual prototypes exists for this subject...
  if (exist([folder,fn_prototypes],'file')==2)
    %...load them
    load([folder,fn_prototypes],'microstate') %prototypes of the subject
    
    %add them to the table with all individual prototypes
    peeg = cat(2,peeg,microstate.prototypes); 
  end

end