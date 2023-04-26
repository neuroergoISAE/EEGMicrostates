function p06_microstates_stats(settings)

if settings.todo.microstates_stats
    for h = settings.microstate.Nmicrostates
        
        for l=settings.backfittingLevels % stats on the backfitted levels only
            level = char(l);
            disp(['p06 Save Stats : ',level, ' ',num2str(h),' MS']);
            fp_microstates = dir([settings.path.backfitting,'**',filesep,'*',level,'*',num2str(h),'MS.mat']);
            
            pl_microstates_stats(fp_microstates,level,h,settings); % all files in this directory on the same table
            
        end
        
    end
end

end