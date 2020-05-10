clc
clear
close all

%after .mat being saved

folder_LV0 = 'F:\data_needle\mat_needle\';
list_mat = dir([folder_LV0 '*.mat']);
 
folder_ICON = 'F:\data_needle\ICON\';
 
for indx_mat = 1     :  length(list_mat)
    path_file = fullfile( list_mat( indx_mat ).folder , list_mat( indx_mat ).name )
    load(path_file)     
    
    date_mat = double(fix( data_needle.time(1)));
    date_str = datestr(date_mat , 'yyyymmdd');
    date_hour = str2num( datestr(data_needle.time(1) , 'hh') );
    
    path_ICON = fullfile( folder_ICON , [date_str '.nc'] );
    
    [icon] = read_ICON( path_ICON );
    
    temp = abs(date_hour - icon.time ); hour_num = find(temp == min(temp)); hour_num = hour_num(1) ;
 
    data_needle.time(1);
    
    data_needle.RH = double( interp1(icon.height(:,hour_num)  ,  icon.RH(:,hour_num), data_needle.range )  );
    data_needle.T = double( interp1( icon.height(:,hour_num) , icon.T(:,hour_num) , data_needle.range  ) );
        
    save(path_file , 'data_needle')
end
 

 