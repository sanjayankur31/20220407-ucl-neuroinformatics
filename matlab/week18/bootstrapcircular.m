% generate random sample from uniform distribution
rng(0);

n = 10;
nBoot = 10000;

theta = rand(n,1)*2*pi;
x = exp(j*theta);

% bootstrap resamples of circular mean
bootstat = bootstrp(nBoot,@mean, x);

figure(1); 
clf; hold on
plot(x, 'b.');
plot(bootstat, 'g.');
plot(mean(x), 'bx');
grid on

figure(2); clf; hold on
edges = 0:0.02:1
hist(abs(bootstat), edges);
ConfInt = prctile(abs(bootstat), [2.5, 97.5]);
plot(ConfInt(1)*[1 1], ylim, 'r');
plot(ConfInt(2)*[1 1], ylim, 'r');
xlim([0 1]);
xlabel('Vector strength');
ylabel('Frequency');


% now compute null distribution

xx = exp(j*rand(n, nBoot)*2*pi);
nullstat = mean(xx);

figure(3); clf; hold on
hist(abs(nullstat), edges);
plot(abs(mean(x))*[1 1], ylim, 'c');
xlabel('Vector strength');
ylabel('Frequency');
xlim([0 1])

ConfInt = prctile(abs(nullstat), [2.5, 97.5]);
plot(ConfInt(1)*[1 1], ylim, 'r');
plot(ConfInt(2)*[1 1], ylim, 'r');
