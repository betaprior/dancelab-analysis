function c = audio_context(fname_base)

w = wavread([fname_base '.wav']);

[exit_code, result] = system(['export LD_LIBRARY_PATH=/usr/local/lib; mplayer ' ...
                    '-identify -frames 0 ' fname_base '.wav 2>/dev/null|grep AUDIO_RATE'...
                    '|tail -n1']);
sr = sscanf(result,'%*[^=]=%d');

duration = 1000 * size(w,1) / sr;
ms = linspace(0, duration, size(w,1));

[c.w, c.sr, c.duration, c.ms] = deal(w, sr, duration, ms);
end