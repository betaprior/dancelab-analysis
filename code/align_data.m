function d = align_data(d1, ms_delay_x2)

d = d1;
assert(d1.ms_reg(1) == 0);

[tmp, ms_delay_idx] = min(abs(d1.ms_reg - abs(ms_delay_x2)));

s = sign(ms_delay_x2);
if s > 0
    rng_zero_a = 1:(ms_delay_idx - 1);
    rng_zero_g = 1:(ms_delay_idx - 1);
else
    rng_zero_a = (1:(ms_delay_idx - 1)) + size(d.a, 1);
    if d1.havegyro
        rng_zero_g = (1:(ms_delay_idx - 1)) + size(d.g, 1);
    end
end

d.a(rng_zero_a) = 0;
d.a = circshift(d.a, -s * (ms_delay_idx - 1)); % equivalent to the old d.a(ms_delay_idx:end,:)
if d1.havegyro
    d.g(rng_zero_g) = 0;
    d.g = circshift(d.g, -s * (ms_delay_idx - 1));
end 

end