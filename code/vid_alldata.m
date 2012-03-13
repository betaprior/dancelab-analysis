assert(exist('fname_vid','var')==1)

assert(length(di1.ms_reg) == length(di2.ms_reg));
ms_reg = di1.ms_reg;


%%%  Video export
n = length(ms_reg);
fps = 23.417;
max_idx = n;
% max_idx = 5000;

sr = 1/((max(ms_reg)-min(ms_reg))/length(ms_reg));
ms_total_duration = max(ms_reg);
nframes = round(ms_total_duration * fps / 1000);

frame_idx = round(linspace(1, nframes+1, n+1));
frame_idx = frame_idx(1:(end-1));
win = 8000 % milliseconds per window
t0_offset = win * .95;
win_samp = round(win * sr)
active_samples = round(t0_offset * sr)
padding_samples = win_samp - active_samples

acol = 4;
bpm_lim = 400;
xfm_all = fft(di2.a(:,acol));
xfm_all(1:15) = 0; % kill DC
xfm_all(end-15:end) = 0; % kill DC
max_ylim = 0;
win_ylim = 3000;
ylims_xfm = abs([min(xfm_all), max(xfm_all)]);

ylims_a = [-20, 20];
ylims_g = [-15, 25];
ylims_amag = [0, 30];

h_fig = figure();
set(h_fig, 'Visible', 'on')
% set(h_fig, 'Position', [300,0,1277,1024]);
set(h_fig, 'Position', [300,200,898,720]);
% set(h_fig, 'Position', [300,00,898,720]); % for windows
h_axs = axes('Parent', h_fig);
set(h_axs,'nextplot','replacechildren');

vidObj = VideoWriter(fname_vid);
vidObj.FrameRate = fps;
open(vidObj);
assert(n == length(frame_idx));
burned_in = 0;
fi_last = 0;
ylim_max = 0;
for i = 1:max_idx
    if frame_idx(i) ~= fi_last
        frange_active = (i - win_samp + 1):i;
        frange_active(frange_active < 1) = 1;
        frange_tot = [frange_active, ...
                      (i + 1):(i + padding_samples)];
        frange_tot(frange_tot > n) = n;
        x = ms_reg(frange_tot)/1000;
        a_mag_lead = [di1.a(frange_active, 1:3);  zeros(padding_samples, 3)];
        a_mag_follow = [di2.a(frange_active, 1:3);  zeros(padding_samples, 3)];
        if di2.havegyro
            omega2_follow = [di2.g(frange_active, 1:3);  zeros(padding_samples, 3)];
        end
        if di1.havegyro
            omega2_lead = [di1.g(frange_active, 1:3);  zeros(padding_samples, 3)];
        end
        

        if length(unique(frange_active)) ~= length(frange_active)
            frange_active = 1:length(frange_active);
        else
            burned_in = 1;
        end
        
        freq_lead = di1.a(frange_active, 4);
        freq_follow = di2.a(frange_active, 4);
        ms_freq = ms_reg(frange_active);
 
        xdat = get_xfm_data(ms_freq);
        range_pos = xdat.zero_idx:xdat.nn;
        xfm_lead = fftshift(fft(freq_lead));
        xfm_lead = xfm_lead(range_pos);
        xfm_follow = fftshift(fft(freq_follow));
        xfm_follow = xfm_follow(range_pos);
        kscale_bpm_pos = xdat.kscale_bpm(range_pos);

        if burned_in
            ms_running = ms_reg(1:i);
            xdat_r = get_xfm_data(ms_running);
            range_pos_r = xdat_r.zero_idx:xdat_r.nn;
            xfm_pos_r_lead = fftshift(fft(di1.a(1:i, 4)));
            xfm_pos_r_lead = xfm_pos_r_lead(range_pos_r);
            xfm_pos_r_follow = fftshift(fft(di2.a(1:i, 4)));
            xfm_pos_r_follow = xfm_pos_r_follow(range_pos_r);
            kscale_bpm_pos_r = xdat_r.kscale_bpm(range_pos_r);
        end

        h_axs_a = subplot(4,1,1);
        plot(h_axs_a, x, a_mag_lead(:,1),'b', x, a_mag_lead(:,2),'r', x, a_mag_lead(:,3),'g');
        axis(h_axs_a, [x([1,end]), ylims_a]);

        h_axs_xf1 = subplot(4,1,2);
        plot(h_axs_xf1, x, a_mag_follow(:,1),'b', x, a_mag_follow(:,2),'r',x, a_mag_follow(:,3),'g');
        axis(h_axs_xf1, [x([1,end]), ylims_a]);
        
        
 
        h_axs_b = subplot(4,1,3);
        if di1.havegyro
            plot(h_axs_b, x, omega2_lead(:,1),'b', x, omega2_lead(:,2)+5,'r',x, omega2_lead(:,3)+10,'g',x,sqrt(omega2_lead(:,2).^2+omega2_lead(:,1).^2),'k');
        end
        hline(0, 'k-');
        axis(h_axs_b, [x([1,end]), ylims_g]);
        h_axs_c = subplot(4,1,4);
        if di2.havegyro
            plot(h_axs_c, x, omega2_follow(:,1),'b', x, omega2_follow(:,2)+5,'r',x, omega2_follow(:,3)+10,'g');
        end
        hline(0, 'k-');
        axis(h_axs_c, [x([1,end]), ylims_g]);


        writeVideo(vidObj, getframe(gcf))
    end
    fi_last = frame_idx(i);
end
close(vidObj)
% clear('fname_vid');
