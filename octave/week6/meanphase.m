rng(1);
N = 400;

% generate data from von Mises dist
z = randn(N,1) + i*randn(N,1) + 1+i/3;
z0 = z./abs(z);
 
th = mod(angle(z)*180/pi, 360);

LinearMean = mean(th);

figure(1); clf; hold on
hist(th,20);
xlim([0 360]);
plot(LinearMean*[1 1], ylim, 'r--');
xlabel('angle (degrees)');
ylabel('count');
legend('histogram', 'linear mean');

figure(2); clf; hold on

plot(z0, '.');
zm = mean(z0);
plot([0 zm]);
plot(zm, 'o');
