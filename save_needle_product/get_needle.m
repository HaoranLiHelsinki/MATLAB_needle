function [ data_get_needle] = get_needle(data_correct , range, specN,   range_offsets);

ldr_threshold = -17;

LDR = nan(size(range));
Z_needle= nan(size(range));
Z_total = nan(size(range));
v_total = nan(size(range));
v_needle = nan(size(range));

v_needle_boundary = [-2 2];

% spectra in chirp 1 
Num_chirp = 1 ;% chirp 1
temp = abs(v_needle_boundary(1) - data_correct.v1 );  num_start = find(temp == min(temp));  num_start = num_start(1);
temp = abs(v_needle_boundary(2) - data_correct.v1 ); num_ed = find(temp == min(temp)); num_ed = num_ed(1) ;

spectra_ldr = data_correct.current_spec_ldr(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );
spectra_V = data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );
spectra_HV = data_correct.current_spec_HV_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );

Z_total(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = ...
   log10( nansum( data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  : )'   )) *10;

v_total(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  1: specN(Num_chirp) )'.*data_correct.v1' ) ./ ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  1: specN(Num_chirp) )') ; 



spectra_ldr_copy = spectra_ldr;
spectra_ldr_copy(spectra_ldr<ldr_threshold ) = nan;
total_needle = sum(~isnan(spectra_ldr'));
spectra_ldr(total_needle < 5,:) = nan;
spectra_ldr( isnan(spectra_ldr_copy)) = nan;

spectra_V(isnan(spectra_ldr)) = nan;
spectra_HV(isnan(spectra_ldr)) = nan;

LDR(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = nan;
LDR(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  10 * log10(nansum(spectra_HV') ./  nansum(spectra_V') );
Z_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = nan;
Z_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  10 * log10(   nansum(spectra_V') );
v_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) )  =  nansum(spectra_V' .* data_correct.v1(num_start :num_ed )' ) ./ ...
     nansum(spectra_V');
 
Num_chirp = 2 ;% chirp 2 
temp = abs(v_needle_boundary(1) - data_correct.v2 );  num_start = find(temp == min(temp));  num_start = num_start(1);
temp = abs(v_needle_boundary(2) - data_correct.v2 ); num_ed = find(temp == min(temp)); num_ed = num_ed(1) ;

spectra_ldr = data_correct.current_spec_ldr(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );
spectra_V = data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );
spectra_HV = data_correct.current_spec_HV_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , num_start :num_ed );

Z_total(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = ...
   log10( nansum( data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  : )'   )) *10;

v_total(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  , 1: specN(Num_chirp) )'.*data_correct.v2' ) ./ ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,1: specN(Num_chirp) )') ; 

spectra_ldr_copy = spectra_ldr;
spectra_ldr_copy(spectra_ldr<ldr_threshold ) = nan;
total_needle = sum(~isnan(spectra_ldr'));
spectra_ldr(total_needle < 5,:) = nan;
spectra_ldr( isnan(spectra_ldr_copy)) = nan;

spectra_V(isnan(spectra_ldr)) = nan;
spectra_HV(isnan(spectra_ldr)) = nan;

LDR(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = nan;
LDR(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  10 * log10(nansum(spectra_HV') ./  nansum(spectra_V') );
Z_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) = nan;
Z_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) =  10 * log10(   nansum(spectra_V') );
v_needle(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) )  =  nansum(spectra_V' .* data_correct.v2(num_start :num_ed )' ) ./ ...
     nansum(spectra_V');
 

Num_chirp = 3 ;% chirp 2 
temp = abs(v_needle_boundary(1) - data_correct.v3 );  num_start = find(temp == min(temp));  num_start = num_start(1);
temp = abs(v_needle_boundary(2) - data_correct.v3 ); num_ed = find(temp == min(temp)); num_ed = num_ed(1) ;

spectra_ldr = data_correct.current_spec_ldr(range_offsets(Num_chirp)+1:length(range)  , num_start :num_ed );
spectra_V = data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1:length(range)   , num_start :num_ed );
spectra_HV = data_correct.current_spec_HV_lin(range_offsets(Num_chirp)+1:length(range)   , num_start :num_ed );
Z_total(range_offsets(Num_chirp)+1: length(range)  ) = ...
   log10( nansum( data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1: length(range)  ,  : )'   )) *10;

v_total(range_offsets(Num_chirp)+1: length(range) ) =  ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1: length(range)  ,  1: specN(Num_chirp) )'.*data_correct.v3') ./ ...
    nansum(data_correct.current_spec_V_lin(range_offsets(Num_chirp)+1: length(range)  , 1: specN(Num_chirp) )') ; 

spectra_ldr_copy = spectra_ldr;
spectra_ldr_copy(spectra_ldr<ldr_threshold ) = nan;
total_needle = sum(~isnan(spectra_ldr'));
spectra_ldr(total_needle < 5,:) = nan;
spectra_ldr( isnan(spectra_ldr_copy)) = nan;

spectra_V(isnan(spectra_ldr)) = nan;
spectra_HV(isnan(spectra_ldr)) = nan;

LDR(range_offsets(Num_chirp)+1: length(range)  ) = nan;
LDR(range_offsets(Num_chirp)+1: length(range)  ) =  10 * log10(nansum(spectra_HV') ./  nansum(spectra_V') );
Z_needle(range_offsets(Num_chirp)+1: length(range)  ) = nan;
Z_needle(range_offsets(Num_chirp)+1: length(range) ) =  10 * log10(   nansum(spectra_V') );
v_needle(range_offsets(Num_chirp)+1: length(range)  )  =  nansum(spectra_V' .* data_correct.v2(num_start :num_ed )' ) ./ ...
     nansum(spectra_V');
 
LDR_needle = LDR;
Z_needle(Z_needle < -100) = nan;

data_get_needle.LDR_needle  = LDR_needle ;
data_get_needle.Z_needle  = Z_needle ;
data_get_needle.Z_total = Z_total ;
data_get_needle.v_total  = v_total ;
data_get_needle.v_needle  = v_needle ;

 