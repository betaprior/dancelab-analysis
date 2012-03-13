function d = read_data(fname)
idx_arr = num2cell(1:10);
TYPE_A = 1;
TYPE_G = 4;
[COL_IDX, COL_TYPE, COL_TS, COL_AX, COL_AY, COL_AZ, COL_AM, COL_GX, COL_GY, ...
 COL_GZ] = deal(idx_arr{:});

d1 = csvread(fname);
d.ms = (d1(:,COL_TS) - d1(1,COL_TS))/1e6;
a1 = d1(d1(:,COL_TYPE) == TYPE_A, [COL_TS, COL_AX:COL_AM]);
a1(:,1) = (a1(:,1) - a1(1,1)) / 1e6;
d.a = a1;
d.ms_a = a1(:,1);

g1 = d1(d1(:,COL_TYPE) == TYPE_G, [COL_TS, COL_GX:COL_GZ]);
if size(g1,1) > 0
    d.havegyro = 1;
    g1(:,1) = (g1(:,1) - g1(1,1)) / 1e6;
else    
    d.havegyro = 0;
end
d.g = g1;
d.ms_g = g1(:,1);

end