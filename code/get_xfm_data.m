function data = get_xfm_data(x)

nn = length(x);

data.nn = nn;
data.ms_per_sample = (x(end)-x(1))/length(x);

sr = 1/((x(end)-x(1))/length(x));
data.sr = sr;

fmax = 1000 * 0.5 * sr;
data.fmax = fmax;
f0 = fmax * 2 / nn;
data.f0 = f0;

kmin = floor(-nn/2) * f0;
kmax = floor(nn/2 - 1) * f0;
kscale = linspace(kmin, kmax, nn);
kscale_bpm = 60 * kscale;
zero_idx = 1 + ceil(nn / 2); % a.k.a 1 + (-floor(-nn / 2))
                                  % in Matlab, kmin index is always at
                                  % (floor(-N/2) * f0); e.g. for N = 5 we
                                  % have [-3, -2, -1, 0, ...]

[data.kmin, data.kmax, data.kscale, data.kscale_bpm, data.zero_idx] = ...
    deal(kmin, kmax, kscale, kscale_bpm, zero_idx);
end