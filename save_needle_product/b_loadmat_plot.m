clc
clear
close all

folder_LV0 = 'F:\data_needle\mat_needle\';
list_mat = dir([folder_LV0 '*.mat']);
for indx_mat = 1 : length(list_mat)
    date_num_mat( indx_mat) = datenum( [ '20' list_mat(indx_mat).name(1:9) ], 'yyyymmdd_hh'  );
end


day_start = datetime(2018,4,1);
day_end = datetime(2018,5,1);
num_fig_day = 4;

day_plot = day_start : 1/num_fig_day : day_end;

for indx_plot = 1 : length(day_plot)
    
    temp = abs(day_plot(indx_plot) - date_num_mat); num_st = find(temp < 1/24/10);
    temp = abs(day_plot(indx_plot)+1/num_fig_day-1/24 - date_num_mat); num_ed = find(temp < 1/24/10);

end


data_needle_total  = [];
data_needle_total.time = [];
data_needle_total.time_model = [];
data_needle_total.range = [];
data_needle_total.LDR_needle =  [];
data_needle_total.Z_needle  = [ ] ;
data_needle_total.Z_total  = [ ] ;
data_needle_total.v_total  = [ ] ;
data_needle_total.v_needle = [];
data_needle_total.T = [];
data_needle_total.RH = [];

for indx_mat =  1  :  length(list_mat)
    path_file = fullfile( list_mat( indx_mat ).folder , list_mat( indx_mat ).name )
    load(path_file) 
    data_needle_total.time = [data_needle_total.time data_needle.time];
    data_needle_total.range = data_needle.range;
    data_needle_total.LDR_needle =  [data_needle_total.LDR_needle data_needle.LDR_needle ];
    data_needle_total.Z_needle  = [ data_needle_total.Z_needle   data_needle.Z_needle] ;
    data_needle_total.Z_total  = [data_needle_total.Z_total data_needle.Z_total] ;
    data_needle_total.v_total  = [data_needle_total.v_total  data_needle.v_total] ;
    data_needle_total.v_needle = [data_needle_total.v_needle data_needle.v_needle];
    
    % model
    data_needle_total.T = [data_needle_total.T  data_needle.T-273.15];
    data_needle_total.RH = [data_needle_total.RH data_needle.T-273.15];
    data_needle_total.time_model = [data_needle_total.time_model data_needle.time(1)];
end

data_needle_total.Z_needle(data_needle_total.Z_needle < -80) = nan;
data_needle_total.range =data_needle_total.range /1000;


%% plot setting
close all

height_text = 0:0.5:5;
ylim_value = [0 2.9];
xlim_value = [data_needle_total.time(1) data_needle_total.time(end)];
xticknum = double( fix(data_needle_total.time(1)) ) + [0: 24]/24;
 
% load LangRainbow.mat
colorscale = jet(21);
 
crange_v_needle = [-1 0.2];
crange_v_total = [-2 0.5];
crange_Z_needle = [-30 10];
crange_Z_total = [-30 30];

p3(1) = 0.06;
p4(1) = 0.06;
p2(1) = p3(1);
p1(1) = p3(1);

p4(3) = 0.83;
p3(3) = 0.83;
p2(3) = p3(3) ;
p1(3) = p3(3) ;

p4(4) = 0.22;
p3(4) = 0.22;
p2(4) = p3(4);
p1(4) = p3(4);

p4(2) = 0.08;
p3(2) = p4(2) +(p4(4) + 0.005)*1;
p2(2) = p4(2) +(p4(4) + 0.005)*2;
p1(2) = p4(2) +(p4(4) + 0.005)*3;


figure

set(gcf, 'Position' , [20 20 1000 800] )

h1 = subplot(4,  1, 1);

pcolor( data_needle_total.time , data_needle_total.range, data_needle_total.Z_needle )
shading flat
colormap( colorscale )
caxis( crange_Z_needle )
colorbar

yticks( height_text ) 
ylim(ylim_value);
xlim(xlim_value);
set(gca,'xtick', xticknum)
datetick('x' ,'HH:MM' , 'keepticks' , 'keeplimits')
ylabel('Height [km]')
xlabel('Time [UTC]')
xticklabels([])

set(h1, 'position', p1);
pos.ax1 = get(h1,'Position');

cb.cb1 = colorbar; 
clab_label = get(cb.cb1,'ylabel') ;      % labeling the color bar
set(clab_label ,'String','Z_{needle} [dB]', 'FontSize', 12) ;    
pos_clab.cb1 = get(cb.cb1, 'Position');
pos_clab.cb1(4) = 0.15;
pos_clab.cb1(3) = 0.015;
set(cb.cb1 , 'Position', pos_clab.cb1);

h2 = subplot(4,  1, 2);
ax21 = gca;
pcolor(ax21, data_needle_total.time , data_needle_total.range , data_needle_total.v_needle)
shading flat
colormap(  colorscale )
caxis( crange_v_needle )
 colorbar
 
yticks(ax21, height_text ) 
ylim(ylim_value);
xlim(xlim_value);
set(gca,'xtick', xticknum)
datetick('x' ,'HH:MM' , 'keepticks' , 'keeplimits')
ylabel('Height [km]')
xlabel('Time [UTC]')
xticklabels([])

set(h2, 'position', p2);
pos.ax2  = get(h2,'Position');

cb.cb2 = colorbar; 
clab_label = get(cb.cb2,'ylabel') ;      % labeling the color bar
set(clab_label ,'String','V_{needle} [m s^{-1}]', 'FontSize', 12) ;    
pos_clab.cb2 = get(cb.cb2, 'Position');
pos_clab.cb2(4) = 0.15;
pos_clab.cb2(3) = 0.015;
set(cb.cb2 , 'Position', pos_clab.cb2);


ax22 = axes;
%%Link them together
linkaxes([ax21, ax22])
temp = data_needle_total.T;
 
% contour(ax12,  output.time_avg, output.range+ 12.5/unit_trans_height, temp , ...
%     [ 0,  0.065 ] , '-.' ,  'color',  'k' , 'LineWidth', 2)    
% hold onax22, 
[C,h] =contour(ax22,  data_needle_total.time_model ,  data_needle_total.range , temp , ...
    [ 0    -8] ,'-', 'color',   'k'  , 'LineWidth',2) 
clabel(C,h);
hold on
[C,h] =contour(ax22,  data_needle_total.time_model ,  data_needle_total.range , temp , ...
    [ 0   -5] ,'-', 'color',   [0.4 0.4 0.4]  , 'LineWidth',2) 
clabel(C,h);
hold on
[C,h] =contour(ax22,  data_needle_total.time_model ,  data_needle_total.range , temp , ...
    [ -80  0] ,'-', 'color',   [0.6 0.6 0.6]  , 'LineWidth',2) 
clabel(C,h);

ax22.Visible = 'off';
ax22.XTick = [];
ax22.YTick = [];  
ylim(ylim_value);
xlim(xlim_value);

set( ax22 ,'Position', p2 );



h3 = subplot(4,  1, 3);

pcolor( data_needle_total.time , data_needle_total.range, data_needle_total.Z_total)
shading flat
caxis( crange_Z_total )    
colormap( colorscale  )

yticks( height_text ) 
ylim(ylim_value);
xlim(xlim_value);
set(gca,'xtick', xticknum)
datetick('x' ,'HH:MM' , 'keepticks' , 'keeplimits')
ylabel('Height [km]')
xlabel('Time [UTC]')
xticklabels([])

set(h3, 'position', p3);
pos.ax3 = get(h3,'Position');

cb.cb3 = colorbar; 
clab_label = get(cb.cb3,'ylabel') ;      % labeling the color bar
set(clab_label ,'String','Z_{total} [dB]', 'FontSize', 12) ;    
pos_clab.cb3 = get(cb.cb3, 'Position');
pos_clab.cb3(4) = 0.15;
pos_clab.cb3(3) = 0.015;
pos_clab.cb3(1) = pos_clab.cb1(1);

set(cb.cb3 , 'Position', pos_clab.cb3);

h4 = subplot(4,  1, 4);

pcolor( data_needle_total.time , data_needle_total.range, data_needle_total.v_total)
shading flat
caxis( crange_v_total  )    
colormap( colorscale  )
colorbar

yticks( height_text ) 
ylim(ylim_value);
xlim(xlim_value);
set(gca,'xtick', xticknum)
datetick('x' ,'HH' , 'keepticks' , 'keeplimits')
ylabel('Height [km]')
xlabel('Time [UTC]')
% xticklabels([])

set(h4, 'position', p4);
pos.ax4 = get(h4,'Position'); 

cb.cb4 = colorbar; 
clab_label = get(cb.cb4,'ylabel') ;      % labeling the color bar
set(clab_label ,'String','V_{total} [m s^{-1}]', 'FontSize', 12) ;    
pos_clab.cb4 = get(cb.cb4, 'Position');
pos_clab.cb4(4) = 0.15;
pos_clab.cb4(3) = 0.015;
set(cb.cb4 , 'Position', pos_clab.cb4);

set(gca ,'fontsize', 12)
 

% print( gcf, 'ff.png','-dpng','-r300');  



