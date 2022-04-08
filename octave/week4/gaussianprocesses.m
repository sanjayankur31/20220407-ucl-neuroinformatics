rng(3)
% generate mean evoked potential

xr = -.5:.01:1;

mu = (xr>0).*exp(-xr*3).*sin(10* xr.^.25);

figure(1);

subplot(2,3,1);
plot(xr, mu);
ylim([-1 1]);
title('Mean');
xlabel('Time')

% add stationary noise
Cov = toeplitz(exp(-xr))/36;

subplot(2,3,4);
imagesc(xr,xr,Cov);
title('Covariance matrix');
xlabel('Time')
ylabel('Time')
caxis([-.05 .05])

n1 = mvnrnd(mu*0, Cov);
n2 = mvnrnd(mu*0, Cov);

subplot(2,3,2);
plot(xr, n1);
ylim([-1 1]);
title('Noise 1');
xlabel('Time')

subplot(2,3,5);
plot(xr, n2);
ylim([-1 1]);
title('Noise 2');
xlabel('Time')


subplot(2,3,3);
plot(xr, mu+n1);
ylim([-1 1]);
title('Total 1');
xlabel('Time')

subplot(2,3,6);
plot(xr, mu+n2);
ylim([-1 1]);
title('Total 2');
xlabel('Time')

% compare some different covariance matrices

figure(2);

CovExp = (Cov*20).^5;

SineStat = sin(xr*2*pi*12);
CosineStat = cos(xr*2*pi*12);
CovStat = CovExp.*(SineStat'*SineStat + CosineStat'*CosineStat);

SineNonstat = (xr>0).*xr.^.5.*sin(xr*2*pi*12);
CosineNonstat = (xr>0).*xr.^.5.*cos(xr*2*pi*12);
CovNonstat = CovExp.*(SineNonstat'*SineNonstat + CosineNonstat'*CosineNonstat);

subplot(1,3,1)
imagesc(CovExp);
title('Toeplitz');
colorbar
caxis([-1 1])

subplot(1,3,2)
imagesc(CovStat);
title('Toeplitz');
caxis([-1 1])
colorbar

subplot(1,3,3)
imagesc(CovNonstat);
title('Not Toeplitz');
caxis([-1 1])
colorbar

figure(3);

for c=1:3;
    subplot(3,3,1+(c-1)*3)
    y = mvnrnd(mu*0, CovExp);
    plot(xr,y);
    ylim([-2.5 2.5]);
    
    subplot(3,3,2+(c-1)*3)
    y = mvnrnd(mu*0, CovStat);
    plot(xr,y);
    ylim([-2.5 2.5]);
    
    subplot(3,3,3+(c-1)*3)
    y = mvnrnd(mu*0, CovNonstat);
    plot(xr,y);
    ylim([-2.5 2.5]);
end    


