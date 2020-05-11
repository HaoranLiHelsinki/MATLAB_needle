clc
clear
close all

% Proportion of points exceeding the Nyquist velocity
% e.g., N_FFT = 1024, V_max = 10.2494; 
% if  Vraindrop = 10.4294 > V_max, velocity folding happens
% 1 point will be folded to another side.
%  I set the ratio as 0.25, thus 0.25 * N_FFT points will be unfolded

Ratio_alias = 0.25; 

% Path of raw data 
folder_LV0 = 'F:\data_needle\test_nc\';
list_nc = dir([folder_LV0 '*.nc']);

foldder_save_mat = 'F:\data_needle\mat_needle\'  ;

error_flag = [];


for indx_nc =  1  : length(list_nc) 
        path_file = fullfile( list_nc(indx_nc).folder , list_nc(indx_nc).name );
        fprintf('%s  \n', list_nc(indx_nc).name)
     
    try
        range = ncread(path_file , 'range');
        time = double(ncread(path_file , 'time'));
        specN = single(ncread(path_file , 'SpecN'));
        maxVel = ncread(path_file ,'maxVel');

        spec_V = ncread(path_file , 'spec_V');  
        spec_HV = ncread(path_file , 'spec_HV');

        range_offsets = ncread(path_file , 'range_offsets');
        AliasMask = ncread(path_file ,'AliasMask');
        MinVel = ncread(path_file ,'MinVel');

        %% do time loop

        data_needle  = [];
        data_needle.time = [];
        data_needle.range = [];
        data_needle.LDR_needle =  [];
        data_needle.Z_needle  = [ ] ;
        data_needle.Z_total  = [ ] ;
        data_needle.v_total  = [ ] ;
        data_needle.v_needle = [];
        for indx_time  = 1 :  3  : length(time)
            current_spec_V_lin = [];
            current_spec_HV_lin = [];

            current_spec_V_lin(:,:) = nanmean( spec_V(indx_time:indx_time+2 , : ,:) );
            current_spec_HV_lin(:,:) = nanmean( spec_HV(indx_time:indx_time+2 , : ,:) );

%              current_spec_V_lin(:,:) = spec_V(indx_time  , : ,:);
%             current_spec_HV_lin(:,:) = spec_HV(indx_time  , : ,:);

            
            % unfolding velocity
            [current_spec_V_lin_new, velocity] = ...
                read_nc_LV0__VelocityFold(current_spec_V_lin, range_offsets, Ratio_alias, specN ,range  ,maxVel  );
            [current_spec_HV_lin_new, velocity] = ...
                read_nc_LV0__VelocityFold(current_spec_HV_lin, range_offsets, Ratio_alias, specN ,range  ,maxVel  );

            data_correct.current_spec_V_lin = current_spec_V_lin_new;
            data_correct.current_spec_HV_lin = current_spec_HV_lin_new;    
            data_correct.v1  = velocity.v1; data_correct.v2  = velocity.v2; data_correct.v3  = velocity.v3;
            data_correct. time = time(indx_time);
            data_correct. path = path_file;

            % do height loop 
            for indx_height = 1 : length(range)
                idx_chirp = int32(find(range_offsets(2:end) - indx_height+1 > 0,1,'first'));
                if isempty(idx_chirp) % then indx_height  is within last chirp
                    idx_chirp = length(range_offsets);
                end

                if isnan(MinVel(indx_time,indx_height)) || MinVel(indx_time,indx_height) == -maxVel(idx_chirp)
                    continue;
                else % if minimum velocity changes; This is not common, but RPG has such setting. 
                    dv =  maxVel(idx_chirp) +  MinVel(indx_time,indx_height);
                    d_v_resolution = maxVel(idx_chirp)*2/ specN(idx_chirp);
                    shift_pixel = single( int32(dv / d_v_resolution) );

                    data_correct.current_spec_V_lin(indx_height,:) = ...
                         read_nc_LV0__VelocityAlias(    data_correct.current_spec_V_lin , indx_height, shift_pixel, idx_chirp, specN   );
                    data_correct.current_spec_HV_lin(indx_height,:) = ...
                         read_nc_LV0__VelocityAlias(    data_correct.current_spec_HV_lin , indx_height, shift_pixel, idx_chirp, specN   );

                end

            end

            data_correct.current_spec_ldr  = 10*log10(data_correct.current_spec_HV_lin./data_correct.current_spec_V_lin);
            data_correct.current_spec_V_db  = 10*log10( data_correct.current_spec_V_lin);
            data_correct.current_spec_HV_db  = 10*log10( data_correct.current_spec_HV_lin);

            %   plot spectral Ze and LDR
%             ylim_range = [200 3500];
%             xlim_range = [-10 0.5];
%             plot_LV0_spectral_Ze_LDR(data_correct , range, specN,  range_offsets,ylim_range,xlim_range);

            % calculate needle LDR
            data_needle.time = [data_needle.time data_correct.time];
            data_needle.range = range;
            data_get_needle =  get_needle(data_correct , range, specN,   range_offsets);

            data_needle.LDR_needle =  [data_needle.LDR_needle data_get_needle.LDR_needle];
            data_needle.Z_needle  = [data_needle.Z_needle data_get_needle.Z_needle ] ;
            data_needle.Z_total  = [data_needle.Z_total  data_get_needle.Z_total ] ;
            data_needle.v_total  = [data_needle.v_total data_get_needle.v_total ] ;
            data_needle.v_needle  = [data_needle.v_needle data_get_needle.v_needle] ;
        
        end

        save( [ foldder_save_mat  list_nc(indx_nc).name(1:end-15) '.mat'] ,'data_needle' )

    catch
        error_flag = [error_flag  indx_nc];
    end
    
    
end

