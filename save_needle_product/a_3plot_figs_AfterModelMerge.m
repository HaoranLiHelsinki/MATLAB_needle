clc
clear
close all

folder_LV0 = 'F:\data_needle\mat_needle\';
list_mat = dir([folder_LV0 '*.mat']);
for indx_mat = 1 : length(list_mat)
    date_num_mat( indx_mat) = datenum( [ '20' list_mat(indx_mat).name(1:9) ], 'yyyymmdd_hh'  );
end


day_start = datetime(2018,2,1); day_start = datenum(day_start);
day_end = datetime(2018,2,4); day_end = datenum(day_end);
num_fig_day = 4;

day_plot = day_start : 1/num_fig_day : day_end;

for indx_plot = 1 : length(day_plot)
    
%     temp = abs( date_num_mat - day_plot(indx_plot)  )  ;  num_st = find(temp < 1/24/10 );
%     temp = abs( date_num_mat - (day_plot(indx_plot)+1/num_fig_day-1/24 )   )  ; num_ed = find(temp < 1/24/10  );

    num_figs = find( date_num_mat >=day_plot(indx_plot) & date_num_mat < day_plot(indx_plot)+1/num_fig_day  );

    if length(num_figs ) < 2 
        fprintf('%s' , 'Data missing !')
          fprintf('%s \n' ,  datestr(day_plot(indx_plot) , 'yyyymmdd_hh' ) )
        continue;
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

    for indx_mat = num_figs
        path_file = fullfile( list_mat( indx_mat ).folder , list_mat( indx_mat ).name );
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
data_needle_total.Z_total( data_needle_total.Z_total < -80) = nan;
data_needle_total.range =data_needle_total.range /1000;

close all
 plot_needle_product(data_needle_total)

print( gcf,['F:\data_needle\figs_needle_product\'  datestr(day_plot(indx_plot),'yyyymmdd_hh') 'ff.png'] ,'-dpng' ,'-r300');  


    
end



