clear all; %#ok<*CLALL>

%{
x = [50,55,56,59,61,62,65];
y = [1.5,3,4.5,6,7.5,9,10.5];
%}
x = [53,56,60,61,62,63,65];
y = [1.5,3,4.5,6,7.5,9,10.5];
x = x';y = y';

%% curve fitting
p = polyfit(x,y,3); %polynomial!

%% 
xlo = min(x); xhi = max(max(x)+5,65);
X = linspace(xlo,xhi,xhi-xlo+1);
% Y = p(1).*X.^(2)+p(2).*X + p(3); %deg 2
Y = p(1).*X.^(3)+p(2).*X.^(2)+p(3).*X+p(4); %deg 3
% Y = p(1).*X.^(4) + p(2).*X.^(3) + p(3).*X.^(2)+p(4).*X + p(5); %deg 4
% Y = p(1).*X.^(5) + p(2).*X.^(4) + p(3).*X.^(3) + p(4).*X.^(2) + p(5).*X + p(6); %deg 5

%% visualization
figure; 
plot(X,Y,'--r'); hold on; scatter(x,y); hold off;
grid on; title('BLE distance curve');
ylabel('Distance (m)'); xlabel('Signal strength (rssi)');
xlim([min(X)-5 max(X)+5]); ylim([0 max(Y)+5]); axis tight;
legend('RSSI-DIST curve','Source Data Point','Location','southeast')

%% R2 verification
peval = polyval(p,x);
SStot = sum((y - mean(y)).^2);
SSres = sum((y - peval).^2);
r2 = 1 - SSres/SStot;