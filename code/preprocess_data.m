function [di1, di2] = preprocess_data(d1, d2)

ms_reg = linspace(min(d1.ms(1), d2.ms(1)), max(d1.ms(end), d2.ms(end)), ...
                  max(length(d1.ms), length(d2.ms)));

di1 = get_interp(d1);
di1.ms_reg = ms_reg;
di2 = get_interp(d2);
di2.ms_reg = ms_reg;

function di = get_interp(d)
    di.havegyro = d.havegyro;
    di.a = interp1(d.ms_a, d.a(:,2:end), ms_reg);
    di.a(isnan(di.a)) = 0;
    if d.havegyro
        di.g = interp1(d.ms_g, d.g(:,2:end), ms_reg);
        di.g(isnan(di.g)) = 0;
    end 
% note: this makes us oversample by a factor of 2 - 3 since we are using
% the total # of samples (the sum of the # of samples from the two
% sensors).  It might be worth exploring sampling each ms array
% independently

end

end