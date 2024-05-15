clear all; %#ok<*CLALL>
warning('off'); %#ok<*CLALL>
% Hankun Li, Lighting Research Laboratory, University of Kansas
% Feb 28, 2021

%% load sorted data file
[rssi, sensors] = tableRead;

%% visualize raw rssi data
x = rssi(:,1); 
y1 = rssi(:,2); 
y2 = rssi(:,3); 
y3 = rssi(:,4);
figure(3); title ('RSSI-raw'); plot(x, y1, '--b'); 
xlabel('time (seconds)'); ylabel('signal strength (RSSI)'); 
grid on; 
% ylim([min(min(y1),min(y2))-5 max(max(y1), max(y2))+10]);
ylim([min([min(y1),min(y2),min(y3)])-5 max([max(y1),max(y2),max(y3)])+10]);
hold on; 
plot(x, y2, '-m'); 
plot(x, y3, '-.g');
hold off;
legend(char(sensors(1,1)),...
    char(sensors(1,2)),...
    char(sensors(1,3)));
legend('Location','northeast');

%{
legend(char(sensors(1,1)),...
    char(sensors(1,2)));
legend('Location','northeast');
%}

%% fourier transformation
%
scode = 2; %change here.
%
if scode == 1
    rd = y1;
elseif scode == 2
    rd = y2;
elseif scode ==3
    rd = y3;
end
%
f1 = fftshift(fft(rd));
f = (0:length(f1)-1)*50/length(f1);
plot(f,abs(f1));
xlabel('Frequency(HZ)'); ylabel('Magnitude'); 
title('RSSI-DFFT-SHIFTED'); grid on;

%% design a simple bandpass filter
lo = 24.85; hi = 25.15;
%
bpf = ((lo < abs(f)) & (abs(f) < hi));
spe = f1.*transpose(bpf); sig = real(ifft(ifftshift(spe)));
plot(x, sig, '-r'); title ('RSSI-filted');
xlabel('time (seconds)'); ylabel('signal strength (RSSI)');
grid on; ylim([min(sig)-5 max(sig)+5]);
legend(char(sensors(1,scode))); legend('Location','northeast');
% legend('Location','northeast');
fprintf('signal strength, filted %.1f (rssi)\n', round(mean(sig)));
