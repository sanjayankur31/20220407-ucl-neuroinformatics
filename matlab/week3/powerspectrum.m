rng(1);

fs = 1000;
N = fs*1;

[b, a] = butter(5, [3 20]/(fs/2));

x = filter(b,a, randn(N,1));
% x = x-mean(x);
xt = fft(x);
f = fs*(0:N-1)/N;

fr = find(f<150);


figure(1);

subplot(1,3,1);
plot((1:N)/fs, x);
title('raw signal');
xlabel('time (s)');

subplot(1,3,2);
semilogy(f(fr), abs(xt(fr)).^2);
title('|FFT|^2');
xlabel('Frequency (Hz)');
grid on

subplot(1,3,3);
pwelch(x, 1000, 2^9, 2^13, fs);
xlim([0 150])

figure(3);


subplot(1,3,1);
plot((1:N)/fs, x);
title('raw signal');
xlabel('time (s)');

subplot(1,3,2);
semilogy(f(fr), abs(xt(fr)).^2);
title('|FFT|^2');
xlabel('Frequency (Hz)');
grid on

subplot(1,3,3);
pmtm(x, 5, 2^10, fs);
xlim([0 150])



figure(2);
T = 500;
A = xcov(x, T, 'unbiased');
plot((-T:T)/fs, A);
xlabel('\Delta t');
title('Autocovariance');