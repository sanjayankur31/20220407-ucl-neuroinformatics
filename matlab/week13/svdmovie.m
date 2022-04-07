if ~exist('u')
    loadVRStacks;  Mov = S.Values;
    % replace this line with whatever loads in your movie

    nT = 6000;
    tStart = 10;
    Size = [320 351];

    FlatMov = reshape(Mov(:,:,tStart:tStart+nT-1),[prod(Size),nT]);
    [u, s, v] = svd(FlatMov, 'econ');
end

Ims = reshape(u, [Size,nT]);
for i=[1:10 50 100 150 200 250 500 1000 5000]
    figure(1); clf
    subplot(1,5,1);
    plot(v(:,i),(0:nT-1)/100);
    xlim([-.05 .05]);
    set(gca, 'ydir', 'reverse');
    xlabel('u_t');
    ylabel('Time (s)')

    subplot(1,5,2:5)
    TopVal = .01;
    imagesc(-Ims(:,:,i)); caxis([-1 1]*TopVal); colorbar
    colormap(BlueWhiteRed)
    colorbar
    axis off
    title(sprintf('Component %d: s = %e', i, s(i,i)));
    
    pause;
end
    


return
%%%
%%%
%%%
%%%
nSVDs = 12;

[icasig A w] = fastica(v(:,1:nSVDs)');

% compute skewness
clear sk
for i=1:size(A,2)
    sk(i) = skewness(icasig(i,:));
end

[~, order] = sort(abs(sk), 'descend');

for i=order
    figure(1);
    pic= reshape(u(:,1:nSVDs)*A(:,i),Size);
%     [~, MaxPixel] = max(abs(pic(:)));
    Flip = sign(sk(i));
    imagesc(pic*Flip)
    set(gca, 'ydir', 'normal');
    caxis([-2e-4 2e-4]);
    colorbar;
    
    figure(2);
    plot(icasig(i,:)*Flip);
    
    pause;
end

return
% NON-NEGATIVE MATRIX FACTORIZATION
nF = 15;
[w h] = nnmf(Mov,nF);
for i =1:nF
    figure(1);
    imagesc(reshape(w(:,i),Size));
    colorbar;
    
    figure(2);
    plot(h(i,:));
    pause;
end

return
% LOOK IN FREQUENCY DOMAIN
fMov = fft(Mov,[],2);

for i=1:10:nT
    ComplexImage(reshape(fMov(:,i), Size)./fMov(150,i));
    title(sprintf('Frequency %f', (i-1)*100/nT));
    
    pause;
end

return

% make movies of original and reconstructed data
nShow = 200;


% now make reconstructed movie
for nSVDs = [1 2 3 5 10 100 200 1000];
   
    rMov = u(:,1:nSVDs)*s(1:nSVDs,1:nSVDs)*v(1:nShow,1:nSVDs)';

    % now make movie object
    mn = -.05;
    mx = .1;
    BothMovies = [FlatMov(:,1:nShow) ; rMov(:,1:nShow)];
    indMov = 1+floor(255*(BothMovies-mn)/(mx-mn));
    indMov = min(max(indMov,1),255);

    mmm = immovie(reshape(indMov,[320 351*2 1 nShow]), jet(256));
    % movie(mmm)

    vidObj = VideoWriter(sprintf('Recon_%f', nSVDs));
    vidObj.FrameRate = 10;
    %vidObj.Quality = 100;
    open(vidObj);
    writeVideo(vidObj, mmm);
    close(vidObj);
end

% make original movie
% make original movie 
indMov = 1+floor(255*reshape(FlatMov(:,1:nShow), [320 351 1 nShow])/(mx-mn));
indMov = min(max(indMov,1),255);
mmm = immovie(indMov, jet(256));
    % movie(mmm)

vidObj = VideoWriter(sprintf('Origf', nSVDs));
vidObj.FrameRate = 10;
%vidObj.Quality = 100;
open(vidObj);
writeVideo(vidObj, mmm);
close(vidObj);


return
% cross-spectrum
nSVDs = 16;
[yo fo] = mtcsd(v(:,1:nSVDs), 2^10, 100, nT, [], 40);
for i=1:length(fo)
    
    nEigs = 4;
    [vv dd] = eigs(sq(yo(i,:,:)), nEigs);
    
    for j=1:nEigs
        subplot(2,2,j)
            Pic = reshape(u(:,1:nSVDs)*vv(:,j), Size);
            ComplexImage(Pic ./ Pic(150) * abs(Pic(150)));
            title(sprintf('PC %d, sv %e', j, dd(j,j)));
    end
    
    set(gcf, 'name', sprintf('Frequency %f Hz', fo(i)));
    pause
end
    