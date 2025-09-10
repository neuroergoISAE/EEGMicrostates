% PLOT MS
phDgreen  = [67 106 33]/255;   % "#436A21"
phDorange = [202 64 0]/255;    % "#CA4000"
white     = [1 1 1];
chanlocs = 'E:\ACERI\Microstates\external_files\Loc_10-20_64Elec.elp';
templates = microstate_ordered;

nMaps = size(templates,2);
labels = arrayfun(@(x) char('A'+x-1), 1:nMaps, 'UniformOutput', false);

% --- Custom diverging colormap: green → white → orange ---
phDgreen  = [67 106 33]/255;   % "#436A21"
phDorange = [202 64 0]/255;    % "#CA4000"
white     = [1 1 1];
N = 256; halfN = round(N/2);

cmap1 = [linspace(phDgreen(1), white(1), halfN)' ...
         linspace(phDgreen(2), white(2), halfN)' ...
         linspace(phDgreen(3), white(3), halfN)'];

cmap2 = [linspace(white(1), phDorange(1), halfN)' ...
         linspace(white(2), phDorange(2), halfN)' ...
         linspace(white(3), phDorange(3), halfN)'];

cmap = [cmap1; cmap2];

% --- Shared color limits for all maps ---
maxAbs = max(abs(templates(:)));
clim   = [-maxAbs maxAbs];

% ==== PLOT ====
figure('Units','normalized','Position',[0.1 0.1 0.8 0.5]);

for i = 1:nMaps
    subplot(1,nMaps,i);
    topoplot( templates(:,i), chanlocs, ...
        'style','fill', ...        % smooth interpolation
        'shading','interp', ...    % smooth shading
        'maplimits',clim, ...      % same scale for all
        'headrad','rim', ...       % full head outline
        'electrodes','on', ...      % clean (no dots)
        'emarkersize',2);   
        %'numcontour',5 );          % 2 contour lines (light, not cluttered)

    title(['Microstate ' labels{i}],'FontWeight','bold');
    axis off;
end

colormap(cmap);