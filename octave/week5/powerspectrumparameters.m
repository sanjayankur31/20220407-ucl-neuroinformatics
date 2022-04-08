rng(1);

fs = 1000;
N = fs*8;

[b, a] = butter(5, [3 20]/(fs/2));
t = 0:N-1;
x = filter(b,a, randn(N,1)) + .01*(sin(50*t'*2*pi/fs)).^.1;

% x = x-mean(x);
xt = fft(x);
f = fs*(0:N-1)/N;

fr = find(f<250);

figure(1);

for i=1:8

    
    Window = 16 * 2^i;
    
    subplot(2,4,i);
    pwelch(x, Window, 0, 2^13, fs);
    xlim([0 160])
    ylim([-110 -20]);
    
    title(sprintf('Window size %d', Window));
end


figure(2);

for i=1:8

    
    NW = 1+i/2;
    
    subplot(2,4,i);
    pmtm(x(1:fs), NW, 2^13, fs);
    xlim([0 160])
    ylim([-150 -20]);
    
    title(sprintf('NW = %.1f', NW));
end

