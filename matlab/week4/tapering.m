T=100;

x = 1:T;
x= x-mean(x);

subplot(3,1,1);
plot(x,x);
grid on
title('Original signal');

subplot(3,1,2);
plot(x,hamming(T));
grid on
title('Hamming taper')


subplot(3,1,3);
plot(x,x.*hamming(T)');
grid on
title('Tapered signal');


figure(2);
x = randn(1,1e4) + sin((1:1e4)/30);
pmtm(x,3,2^15);
xlim([0 .03]);

