function d = align_audio(fname1, fname2, fname3, varargin)

numvarargs = length(varargin);
optargs = {'noCorr', 1, 'noCorr', 1};
optargs(1:numvarargs) = varargin;
[return_corrs_flag_x2, nth_highest_x2, return_corrs_flag_x3, nth_highest_x3] = optargs{:};


w1 = audio_context(fname1);
w2 = audio_context(fname2);
w3 = audio_context(fname3);

assert(w1.sr == w2.sr && w1.sr == w3.sr);
X2 = xcorr(w1.w, w2.w);
% return the correlations if the user requested
if strcmpi(return_corrs_flag_x2, 'returnCorr')
    d.X2 = X2;
end

if nth_highest_x2 > 1
    [X2_srt, X2_srt_idx] = sort(X2, 'descend');
    xcorr2_d = X2_srt_idx(nth_highest_x2);
else
    [xcorr2_m, xcorr2_d] = max(X2);
end
delay2 = xcorr2_d - max(length(w1.w),length(w2.w));
d.delay2 = delay2;
d.ms_delay_x2 = 1000*abs(delay2)/w2.sr;

if delay2 == 0
    wavwrite(w1.w, w1.sr, [fname1, '_aligned.wav']);
    wavwrite(w2.w, w2.sr, [fname2, '_aligned.wav']);
elseif delay2 < 0
    wavwrite(w2.w(abs(delay2):end), w2.sr, [fname2, '_aligned.wav']);
    wavwrite(w1.w, w1.sr, [fname1, '_aligned.wav']);
    w2 = audio_context([fname1, '_aligned']);
    sprintf('skipping %g ms of %s\n', d.ms_delay_x2, fname2)
else    
    wavwrite(w1.w(abs(delay2):end), w1.sr, [fname1, '_aligned.wav']);
    wavwrite(w2.w, w2.sr, [fname2, '_aligned.wav']);
    w1 = audio_context([fname2, '_aligned']);
    sprintf('skipping %g ms of %s\n', d.ms_delay_x2, fname1)
end


X3 = xcorr(w2.w, w3.w);
% return the correlations if the user requested
if strcmpi(return_corrs_flag_x3, 'returnCorr')
    d.X3 = X3;
end

if nth_highest_x3 > 1
    [X3_srt, X3_srt_idx] = sort(X3, 'descend');
    xcorr3_d = X3_srt_idx(nth_highest_x3);
else
    [xcorr3_m, xcorr3_d] = max(X3);
end
delay3 = xcorr3_d - max(length(w2.w), length(w3.w));

d.delay3 = delay3;
d.ms_delay_x3 = 1000*abs(delay3)/w3.sr;


if delay3 == 0 
    wavwrite(w3.w, w3.sr, [fname3, '_aligned.wav']);
elseif delay3 < 0 
    wavwrite(w3.w(abs(delay3):end), w3.sr, [fname3, '_aligned.wav']);
    sprintf('skipping %g ms of %s\n', d.ms_delay_x3, fname3)
else
   w3_p = [zeros(abs(delay3), 1) ; w3.w];
   wavwrite(w3_p, w3.sr, [fname3, '_aligned.wav']);
   sprintf('padding %g ms of %s\n', d.ms_delay_x3, fname3)
end


end