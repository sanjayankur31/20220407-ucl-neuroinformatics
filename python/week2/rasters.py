#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy


dt = 1e-3
nTrials = 100
fRate = 3*dt

StimTime = 0.1/dt
EarliestResponse = 0.3/dt
ResponseRange = 0.1/dt
TrialEnd = int(3.0/dt)
tau = 300  # decay timecourse

ResponseTime = EarliestResponse + numpy.random.random(size=[nTrials, 1]) * ResponseRange

t = numpy.array([x for x in numpy.arange(0.0, TrialEnd)])

Rates = numpy.zeros(shape=[nTrials, TrialEnd])
Spikes = numpy.zeros(shape=[nTrials, TrialEnd])


def Alpha(x): return fRate * numpy.exp(-x/tau) * x * (x > 0)


for i in range(1, nTrials + 1):
    Rates[i - 1, :] = Alpha(t - StimTime) - Alpha(t - ResponseTime[i - 1])

Spikes = (Rates > numpy.random.random(size=Rates.shape))

# plots
fig, axs = plt.subplots(3, 1)

# plot spikes
axs[0].imshow(Spikes, aspect="auto", cmap="Greys")
axs[0].set_title(label="")
axs[0].set_ylabel(ylabel="Trial #")
axs[0].set_xlabel("Time (ms)")

# plot sorted spikes
sortedResponses = numpy.sort(ResponseTime, axis=None)
order = numpy.argsort(ResponseTime, axis=None)
axs[1].imshow(Spikes[order, :], aspect="auto", cmap="Greys")
axs[1].scatter(sortedResponses, [x for x in range(1, nTrials + 1)], marker=".")
axs[1].set_title(label="")
axs[1].set_ylabel(ylabel="Trial # (sorted)")
axs[1].set_xlabel("Time (ms)")


# plot mean number of spikes
meanSpikes = numpy.mean(Spikes, axis=0)
print(meanSpikes)
axs[2].plot(meanSpikes)
axs[2].set_xlim([0, 3000])

# Another set
Rates2 = numpy.zeros(shape=[nTrials, TrialEnd])
for i in range(1, nTrials + 1):
    Rates2[i - 1, :] = Alpha(t - StimTime + ResponseTime[i - 1] - 1000) - Alpha(t - 1000)
Spikes2 = (Rates2 > numpy.random.random(size=Rates2.shape))

fig, axs = plt.subplots(2, 1)

# plot spikes
axs[0].imshow(Spikes2, aspect="auto", cmap="Greys")
axs[0].set_title(label="")
axs[0].set_ylabel(ylabel="Trial #")
axs[0].set_xlabel("Time (ms)")

# plot mean number of spikes
meanSpikes2 = numpy.mean(Spikes2, axis=0)
print(meanSpikes2)
axs[1].plot(meanSpikes2)
axs[1].set_xlim([0, 3000])

plt.show()
