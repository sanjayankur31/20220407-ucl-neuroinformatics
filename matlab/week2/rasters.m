% simulate raster plots for a stimulus - behavior task
% stimulus comes on at 1s, response between 1.2 and 2 s

dt = 1e-3;
nTrials = 100;
fRate = 3*dt;

StimTime = 0.1/dt;
EarliestResponse = 0.3/dt;
ResponseRange = 0.1/dt;
TrialEnd = 3.0/dt;
tau = 300; % decay timecourse

ResponseTime = EarliestResponse + rand(nTrials,1)*ResponseRange;

t = 1:TrialEnd;

Rates = zeros(nTrials, TrialEnd);
Spikes = zeros(nTrials, TrialEnd);


Alpha = @(x) fRate*exp(-x/tau).*x.*(x>0);

for i=1:nTrials
    Rates(i,:) = Alpha(t-StimTime) - Alpha(t-ResponseTime(i));
end

Spikes = (Rates>rand(size(Rates)));

figure(1)
subplot(3,1,1);
imagesc(Spikes);
xlabel('Time (ms)')
ylabel('Trial #');

subplot(3,1,2); cla; hold on
[sorted,order] = sort(ResponseTime);
imagesc(Spikes(order,:))
plot(sorted, 1:nTrials, 'r.');
set(gca, 'ydir', 'reverse');
axis tight
xlabel('Time (ms)')
ylabel('Trial # (sorted)');

subplot(3,1,3);
plot(mean(Spikes,1));

colormap(1-gray);

Rates2 = zeros(nTrials, TrialEnd);
figure(2);
for i=1:nTrials
    Rates2(i,:) = Alpha(t-StimTime+ResponseTime(i)-1000) - Alpha(t-1000);
end
Spikes2 = (Rates2>rand(size(Rates2)));

subplot(3,1,1);
imagesc(Spikes2);
xlabel('Time (ms)')
ylabel('Trial #');

colormap(1-gray)

    subplot(3,1,2);
plot(mean(Spikes2,1));


    