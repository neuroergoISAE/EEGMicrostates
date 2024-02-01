%% Automagic 

function Autoautomagic(s)

addAutomagicPaths();

configfile = load([s.path.project,filesep,'external_files',filesep,'Automagic3.0_Configuration.mat']); %Loads older config file (can be modified)

Params = configfile.self.params;

name = [s.name,'_Automagic_Results']; %automagic project file
dataFolder = s.path.RS_data;%input files
resultFolder = s.path.automagic_data ; %output files
ext = '.mat'; %files extention
VisualisationParams = configfile.self.vParams;
samplingrate = 500;

self = Project(name, dataFolder, resultFolder, ext, Params, VisualisationParams, samplingrate); %create project

self.preprocessAll(); %preprocessing with config files parameters
self.interpolateSelected(); %interpolation
runAutomagic();

%self(); %open main GUI, please select project and proceed to Quality rating
%please proceed manually to Quality rating (cannot be done through script)
disp('Please proceed to Quality rating, then press enter.');
%pause;
%% TEST IF QUALTY RATING WAS DONE BEFORE NEXT STEP
qualitybool = false;
while ~qualitybool
    files = dir(strcat(s.path.preprocessed_data,'\**\*.mat'));
     files = files(...
      contains({files.name},'p') ...
      & contains({files.name},'.mat') ...
      & ~contains({files.name},'reduced') ... 
      & ~contains({files.name},'project_state') ...% string should not contain 'reduced'
      );
      for s =1:length(files)
          disp(files(s).name);
          qualitybool = startsWith(files(s).name,'g');
          disp(qualitybool);
          if(~qualitybool)
              disp('Please proceed to Quality rating. Press enter when it is done');
              pause;
              break
          end
      end
end
disp('Automagic done. Press Enter to continue');
pause;
removeAutomagicPath();
end