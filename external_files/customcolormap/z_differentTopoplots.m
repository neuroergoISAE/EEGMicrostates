clear all, clc

% load settings
if ismac
addpath('/Volumes/methlab/Students/HBN_Moritz/Microstate Analysis/src');
elseif ispc
addpath('Z:/Students/HBN_Moritz/src/');
end 
addpath('settings')
s = p00_general_settings;

addpath('/Volumes/methlab/Students/HBN_Moritz/Microstate Analysis/src/functions/customcolormap')

load('/Volumes/methlab/Students/HBN_Moritz/Microstate Analysis/results/dimApp/group/microstates/chanlocs.mat')
load('/Volumes/methlab/Students/HBN_Moritz/Microstate Analysis/results/dimApp/group/microstates/microstate_prototypes_eyesclosed_4MS.mat')

mycolormap = customcolormap_preset('red-white-blue');

for i = 1:4
nexttile
topoplot(microstate.prototypes(:,i),chanlocs, 'maplimits', [-0.2 0.2]);
colorbar;
set(gcf,'color','w'); % set backround color to white
colormap(mycolormap);
end 
