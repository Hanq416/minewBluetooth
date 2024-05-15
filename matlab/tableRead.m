% get spectrum
function [rssi, ssname] = tableRead
%% read raw data
[fn,pn] = uigetfile('*.txt','load a rssi data');
fname = [pn,fn]; raw = tdfread(fname); raw = struct2table(raw);
%% formatting data
[v w] = size(raw); %#ok<*NCOMMA>
ssname = table(); rssi(:, 1) = 1:1:v; i = 1;
while i < ((w+1)/2)
    ssname(1, i) = raw(1, i*2);
    tmp = raw(:, i*2+1);
    rssi(:, i+1) = tmp{:,:};
    i = i + 1;
end
ssname = table2cell(ssname);
end