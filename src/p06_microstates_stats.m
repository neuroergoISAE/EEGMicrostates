function p06_microstates_stats(settings)

if settings.todo.microstates_stats
    for h = settings.microstate.backfitting.Nmicrostates
        
        for l=settings.levels
            level = char(l);
            disp(['p06 Save Stats : ',level, ' ',num2str(h),' MS']);
            fp_microstates = dir([settings.path.backfitting,'**\*',level,'*',num2str(h),'MS.mat']);
            
            pl_microstates_states(fp_microstates,level,h,settings); % all files in this directory on the same table
            
        end
        
    end
end

end