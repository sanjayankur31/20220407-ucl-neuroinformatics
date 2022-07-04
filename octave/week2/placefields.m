randn("seed", 3)
rand("seed", 3)

N = 100;

[x,y] = meshgrid(1:N, 1:N);

% make true place field

f = exp(-((x-N/2).^2 + (y-N/2).^2)/50);

%imagesc(f);

%make trajectory

% first random walk
v = .01;
T = 1e4;
x0 = cumsum(randn(T,2) + v*10)*v;

% now fold it so rat bounces off edges
Traj = abs(mod(x0,2)-1)*N;

subplot(3,3,1);
imagesc(f);
title('Actual f(x)');

subplot(3,3,2);
plot(Traj(:,1), Traj(:,2), 'r');
title('trajectory');
set(gca, 'ydir', 'reverse')

subplot(3,3,4);
% make occupancy map
xi = ceil(Traj);

OccMap = accumarray(xi,1);
imagesc(OccMap')
title('Occupancy map')

subplot(3,3,5);
SpkCntMap = accumarray(xi, f(sub2ind([N,N], xi(:,1), xi(:,2))));
imagesc(SpkCntMap');
title('Spike count map');

subplot(3,3,6)
imagesc(SpkCntMap'./OccMap');
title('Spike Count / Occupancy');

MeanRate = mean(SpkCntMap)/mean(OccMap);

Filt =  exp(-((x-N/2).^2 + (y-N/2).^2)/15);
eps = 1;
SmSpkCnt = conv2(SpkCntMap, Filt, 'same');
SmOcc = conv2(OccMap, Filt, 'same');

PlaceField = (SmSpkCnt + MeanRate*eps) ./ (SmOcc+eps);

subplot(3,3,7)
imagesc(SmSpkCnt);
title('Smoothed Spike Count');

subplot(3,3,8)
imagesc(SmOcc);
title('Smoothed Occupancy');

subplot(3,3,9)
imagesc(PlaceField);
title('Ratio');


