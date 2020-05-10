function [icon] = read_ICON(file_name)
% clc
% clear
% file_name = 'F:\data_needle\20180418.nc';

% file_name =path_ICON;


ncinfodata = ncinfo(file_name);
icon.u =  ncread(file_name  , 'uwind');
icon.v =  ncread(file_name  , 'vwind');
icon.height=  ncread(file_name  , 'height');
icon.time =  ncread(file_name  , 'time');
icon.Ftime =  ncread(file_name  , 'forecast_time');
icon.T = ncread(file_name  , 'temperature');
icon.RH = ncread(file_name  , 'rh');
icon.p = ncread(file_name  , 'pressure');