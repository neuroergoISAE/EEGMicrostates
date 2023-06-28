%% p06_microstates_stats.m
% Author : hamery adapted from Christian Pfeiffer & Moritz Truninger
% Date : 2023
% Description : this script computes the backfitting results stats for all participants/session and on all levels
% Dependencies : EEGlab
% Inputs : settings, structure containing all settings for the analysis
% Outputs: csv and tables for each level and each number of cluster (microstates)

function p06_microstates_stats(settings)

if settings.todo.microstates_stats
    for h = settings.microstate.Nmicrostates
        for l = settings.backfittingLevels % stats on each backfitted levels
            level = char(l);
            disp(['p06 Save Stats : ',level, ' ',num2str(h),' MS']);
            fp_microstates = dir([settings.path.backfitting,'**',filesep,'*',level,'*',num2str(h),'MS.mat']);
            pl_microstates_stats(fp_microstates,level,h,settings); %all files in this directory on the same table
        end
    end
end

end