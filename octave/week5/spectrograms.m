rng(3)
% generate mean evoked potential

N=50;

xr = -.5:1/1024:2;
f=80;

% make covariance matrices

Cov = toeplitz(exp(-xr))/36;

CovExp = (Cov*20).^5;

SineStat = sin(xr*2*pi*f);
CosineStat = cos(xr*2*pi*f);
CovStat = CovExp.*(SineStat'*SineStat + CosineStat'*CosineStat);

SineNonstat = (xr>0).*sin(xr*2*pi*f).*exp(-xr);
CosineNonstat = (xr>0).*cos(xr*2*pi*f).*exp(-xr);
CovNonstat = CovExp.*(SineNonstat'*SineNonstat + CosineNonstat'*CosineNonstat);


mu = (xr>0).*xr.^.25.*exp(-xr*3).*cos(10* xr.^.25);

SumNoise = zeros(size(mu));
SumEvoked = SumNoise;
SumInduced = SumNoise;


for i=1:N
    figure(1); clf


    yNoise = mu + mvnrnd(0*mu,CovExp)*.1;
    yEvoked = mu + mvnrnd(0*mu,CovExp)*.1 + SineNonstat*.03;
    yInduced = mu + mvnrnd(0*mu,CovExp)*.1 + mvnrnd(mu*0, CovNonstat)*.03;
    
    SumNoise = SumNoise + yNoise;
    SumEvoked = SumEvoked + yEvoked;
    SumInduced = SumInduced + yInduced;
    

    [sNoise fo to] = mtpsg(yNoise, 1024, 1024, 256, 224);    
    [sEvoked fo to] = mtpsg(yEvoked, 1024, 1024, 256, 224);
    [sInduced fo to] = mtpsg(yInduced, 1024, 1024, 256, 224);

    if i==1
        SumSpecNoise = sNoise;
        SumSpecEvoked = sEvoked;
        SumSpecInduced = sInduced;
    else
        SumSpecNoise = SumSpecNoise+sNoise;
        SumSpecEvoked = SumSpecEvoked+sEvoked;
        SumSpecInduced = SumSpecInduced+sInduced;
    end    
    
    subplot(2,3,1);
    plot(xr, yNoise);
    xlim([-.5 2]);
    colorbar;
    title('single waveform')
    ylim([-.5 .5]);

    subplot(2,3,2);
    plot(xr, yEvoked);
    xlim([-.5 2]);
    colorbar;
    title('single waveform')
    ylim([-.5 .5]);

    subplot(2,3,3);
    plot(xr, yInduced);
    xlim([-.5 2]);
    colorbar;
    title('single waveform')
    ylim([-.5 .5]);

    subplot(2,3,4);
    imagesc(to-.5, fo, 20*log10(sNoise));
    set(gca, 'ydir', 'normal');
    ylim([0 200])
    colorbar;
    title('single spectrogram')
    caxis([-120 0]);

    subplot(2,3,5);
    imagesc(to-.5, fo, 20*log10(sEvoked));
    set(gca, 'ydir', 'normal');
    ylim([0 200])
    colorbar;
    title('single spectrogram')
    caxis([-120 0]);
    
    subplot(2,3,6);
    imagesc(to-.5, fo, 20*log10(sInduced));
    set(gca, 'ydir', 'normal');
    ylim([0 200])
    colorbar;
    title('single spectrogram')
    caxis([-120 0]);
    
    drawnow;
    pause
end

figure(2)

subplot(3,3,1);
plot(xr, SumNoise/N);
xlim([-.5 2]);
colorbar;
title('average of waveforms')
ylim([-.5 .5]);

subplot(3,3,2);
plot(xr, SumEvoked/N);
xlim([-.5 2]);
colorbar;
title('average of waveforms')
ylim([-.5 .5]);

subplot(3,3,3);
plot(xr, SumInduced/N);
xlim([-.5 2]);
colorbar;
title('average of waveforms')
ylim([-.5 .5]);


subplot(3,3,4);
imagesc(to-.5, fo, 20*log10(SumSpecNoise/N));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('average of spectrograms')
caxis([-120 0]);

subplot(3,3,5);
imagesc(to-.5, fo, 20*log10(SumSpecEvoked/N));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('average of spectrograms')
caxis([-120 0]);

subplot(3,3,6);
imagesc(to-.5, fo, 20*log10(SumSpecInduced/N));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('average of spectrograms')
caxis([-120 0]);

[smNoise fo to] = mtpsg(SumNoise/N, 1024, 1024, 256, 224);    
[smEvoked fo to] = mtpsg(SumEvoked/N, 1024, 1024, 256, 224);
[smInduced fo to] = mtpsg(SumInduced/N, 1024, 1024, 256, 224);

subplot(3,3,7);
imagesc(to-.5, fo, 20*log10(smNoise));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('spectrogram of average')
caxis([-120 0]);

subplot(3,3,8);
imagesc(to-.5, fo, 20*log10(smEvoked));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('spectrogram of average')
caxis([-120 0]);

subplot(3,3,9);
imagesc(to-.5, fo, 20*log10(smInduced));
set(gca, 'ydir', 'normal');
ylim([0 200])
colorbar;
title('spectrogram of average')
caxis([-120 0]);

drawnow;