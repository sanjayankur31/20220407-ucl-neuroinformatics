if ~exist('MySpikes')
    FileBase ='\\zserver.ioo.ucl.ac.uk\Data\multichanspikes\M140528_NS1\20141202\20141202_all';

    KwikFile = [FileBase '.kwik'];
    DatFile = '\\zserver.ioo.ucl.ac.uk\Data\multichanspikes\M140528_NS1\20141202\20141202_1.dat';

    Clu = h5read(KwikFile, '/channel_groups/1/spikes/clusters/main');
    Res = h5read(KwikFile, '/channel_groups/1/spikes/time_samples');
    ResFrac = h5read(KwikFile, '/channel_groups/1/spikes/time_fractional');

    % MeanWaveform = h5read(KwikFile,'/channel_groups/1/clusters/main/1099/mean_waveform_raw');

    MyTimes = Res(find(Clu==1099));
    MyChans = [ 22    23    27    28    54    55    59    60];
    nChans = length(MyChans);

    n2Load = 512;
    nBefore = 10;
    nAfter = 50;
    MySpikes = SpikeExtract(DatFile, MyTimes(1:n2Load), 129, MyChans, nBefore, nAfter);
    nT = nBefore+nAfter+1;;

end

% done loading

MySpikes0 = bsxfun(@minus, MySpikes, MySpikes(:,1,:));

% detrended spikes
dMySpikes = MySpikes0 - bsxfun(@times, MySpikes0(:,end,:), (0:nT-1)/(nT-1));

% diff of detrended
ddMySpikes = diff(dMySpikes, 1, 2);

%MeanSpike = mean(dMySpikes,3);
%imagesc(MeanSpike);

ddFlatSpikes = reshape(ddMySpikes, [nChans*(nT-1), n2Load]);

[ddu dds ddv]=svd(ddFlatSpikes,0);

nSVDs = 10;

ddFlatReconSpikes = ddu(:,1:nSVDs)*dds(1:nSVDs, 1:nSVDs)*ddv(:,1:nSVDs)';
ddReconSpikes = [zeros(nChans, 1, n2Load), cumsum(reshape(ddFlatReconSpikes, [nChans, nT-1, n2Load]),2)];

% now do it for non-diffed

dFlatSpikes = reshape(dMySpikes, [nChans*(nT), n2Load]);

[du ds dv]=svd(dFlatSpikes,0);

dFlatReconSpikes = du(:,1:nSVDs)*ds(1:nSVDs, 1:nSVDs)*dv(:,1:nSVDs)';
dReconSpikes = reshape(dFlatReconSpikes, [nChans, nT, n2Load]);

% sReconSpikes = real(fft_circshift(ReconSpikes,rand(

Offsets =  repmat(400*(1:nChans)',[1 nT]);
for i=14
    clf; 
    subplot(1,2,1); hold on
    h1 = plot(dMySpikes(:,:,i)'+Offsets', 'k');   
    h2 = plot(dReconSpikes(:,:,i)'+Offsets', 'r');
    ylim([-500 4000]);
    title('Reconstructed on full vector') 
    
    subplot(1,2,2); hold on
    plot(dMySpikes(:,:,i)'+Offsets', 'k');   
    plot(ddReconSpikes(:,:,i)'+Offsets', 'r');
    ylim([-500 4000]);
    legend([h1(1) h2(1)], 'Original', '10 SVs');
    title('Reconstructed on first difference')
    pause

end
