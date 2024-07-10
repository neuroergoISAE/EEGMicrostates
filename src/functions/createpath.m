%% Create path for microstates Analysis Inputs and Outputs
% April 2024 - CH

function s = createpath(s)

addpath(s.path.eeglab);
eeglab; close %add egglab functions to path
s.path.src =fileparts(matlab.desktop.editor.getActiveFilename); 
%s.path.preprocessed_data = [s.path.project,filesep,s.name,filesep,'Preprocessed_Data'];
s.path.MS_results= [s.path.project,filesep,s.name,filesep,'Microstates_Results'];
s.path.chanloc = [s.path.project,filesep,'external_files',filesep,'Loc_10-20_64Elec.elp'];
%% Folders
function createfolder(fn)
    if ~isfolder(fn)
        mkdir(fn);
    end
end
%createfolder(s.path.preprocessed_data);
createfolder(s.path.MS_results);
cd(s.path.src);
s.path.gfp = [s.path.MS_results,filesep,'gfp',filesep]; %intermediate gfp output (participant or session)
createfolder(s.path.gfp);
s.path.tables = [s.path.MS_results,filesep,'stats',filesep,'tables',filesep]; %mat tables with final features
createfolder(s.path.tables);
s.path.csv=[s.path.MS_results,filesep,'stats',filesep,'csv',filesep]; %csv files with final features
createfolder(s.path.csv);
s.path.group=[s.path.MS_results,filesep,'group',filesep]; %intermediate group output (sample-level prototypes)
createfolder(s.path.group);
s.path.participant=[s.path.MS_results,filesep,'participant',filesep]; %intermediate participant output (participant-level prototypes)
createfolder(s.path.participant);
s.path.backfitting=[s.path.MS_results,filesep,'backfitting',filesep]; %backfitting output (participant or session levels)
createfolder(s.path.backfitting);
if any(strcmp(s.backfittingLevels,'session')) %if session level required
    s.path.session=[s.path.MS_results,filesep,'session',filesep]; %intermediate session output (session-level prototypes)
    createfolder(s.path.session);
end
%%  Toolbox
s.path.microstates=[s.path.eeglab,filesep,'plugins',filesep,'MST1.0', filesep]; %toolbox poulsen
s.path.microstatesKoenig = [s.path.eeglab,filesep,'plugins',filesep,'MicrostateAnalysis1.2',filesep,'Microstates1.2', filesep]; %toolbox koenig
s.path.colormap = [fileparts(s.path.src),filesep,'external_files',filesep,'customcolormap',filesep]; %for the microstates plots

%% add paths
addpath(s.path.src);
addpath(s.path.eeglab);
addpath(s.path.microstates);
addpath(s.path.microstatesKoenig);
addpath(s.path.colormap);
%% Custom Color Map
s.customColorMap.colors = 'red-white-blue';
s.customColorMap.range = [-0.25 0.25];

end