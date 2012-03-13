d1_raw = read_data(f_lead);
d2_raw = read_data(f_follow);

[di1, di2] = preprocess_data(d1_raw, d2_raw);

d_au = align_audio(f_lead_audio, f_follow_audio, f_camera_audio, 'noCorr', ...
                   nthx2);

if d_au.delay2 < 0
    di2 = align_data(di2, d_au.ms_delay_x2);
elseif d_au.delay2 > 0
    di1 = align_data(di1, d_au.ms_delay_x2);
end