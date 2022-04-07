% first make fluctuating signal

rng(1)

fs = 1024;

N = fs*2;

f = 8;

t = (1:N) + cumsum(randn(1,N));

a = 5+ filter(1, [1, -.999], randn(1,N))/10;

y = filter(1, [1 -.9], randn(1,N))/5 + sin(2*pi*f*t/fs).*a;

h = hilbert(y);

figure (1)
plot((1:N)/fs, [y; angle(h); abs(h)]');
legend('Original signal', 'Hilbert phase', 'Hilbert amplitude');
xlabel('Time (s)');
xlim([0 2]);

figure (2)
plot((1:N)/fs, [y; imag(h)]');
legend('Original signal', 'Imaginary part');
xlabel('Time (s)');
xlim([0 2]);

figure(3);
t2 = (1:N) + cumsum(randn(1,N))*3;

a2 =3 + filter(1, [1, -.999], randn(1,N))/20;
y2 = filter(1, [1 -.9], randn(1,N))/5 + sin(2*pi*f*t2/fs).*a2;
h2 = hilbert(y2);
plot((1:N)/fs, [y2; angle(h2); abs(h2)]');
legend('Original signal', 'Hilbert phase', 'Hilbert amplitude');
xlabel('Time (s)');
xlim([0 2]);



