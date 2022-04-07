rng(1);
N = 30;
eps = .1;
xr = (0:.01:1)';


x = sort(rand(N,1));
X1 = [ones(size(x)), x];
X2 = [ones(size(x)), x, x.^2, x.^3, x.^4, x.^5];

Xr1 = [ones(size(xr)), xr];
Xr2 = [ones(size(xr)), xr, xr.^2, xr.^3, xr.^4, xr.^5];

y = x + randn(N,1)*eps;

b1 = regress(y, X1);
b2 = regress(y, X2);

yrhat1 = Xr1*b1;
yrhat2 = Xr2*b2;

figure(1); clf
subplot(2,2,1); plot(x, y, '.', xr, yrhat1, 'r');
title(sprintf('Training set error %f', sum((y-X1*b1).^2)));
axis([0 1 0 1])

subplot(2,2,2); plot(x, y, '.', xr, yrhat2, 'r');
title(sprintf('Training set error %f', sum((y-X2*b2).^2)));
axis([0 1 0 1])


xt = sort(rand(N,1));

Xt1 = [ones(size(xt)), xt];
Xt2 = [ones(size(xt)), xt, xt.^2, xt.^3, xt.^4, xt.^5];

yt = xt + randn(N,1)*eps;


subplot(2,2,3); plot(xt, yt, '.', xr, yrhat1, 'r');
title(sprintf('Test set error %f', sum((yt-Xt1*b1).^2)));
axis([0 1 0 1])

subplot(2,2,4); plot(xt, yt, '.', xr, yrhat2, 'r');
title(sprintf('Test set error %f', sum((yt-Xt2*b2).^2)));
axis([0 1 0 1])
