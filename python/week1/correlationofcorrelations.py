#!/usr/bin/env python3

import numpy
from numpy.random import default_rng
from scipy.linalg import toeplitz
from scipy.stats import mstats
import matplotlib.pyplot as plt

# Set/change the random number generator seed
rng = default_rng(seed=32453245)

N = 100
Nr = 1000

# Iterating over ranges:
# Matlab: [start, step, end]
# Python: numpy.arange(start, end, step)
# Matlab: array indices start from 1
# Python: array indices start from 0
Offdiags = (numpy.setdiff1d(numpy.arange(0, N**2), numpy.arange(0, N**2, N+1)))

M1 = (toeplitz(numpy.arange(N-1, -1, -1))/N)

# To see the dimensions of a matrix:
# Matlab: size(M)
# Python: M.shape
# print(M1.shape)

p = numpy.zeros([Nr, 1])
r = numpy.zeros([Nr, 1])

for i in range(0, Nr):
    rp = rng.permutation(N)
    M2 = M1[numpy.ix_(rp, rp)]

    # Matlab: a' (conjugate transpose)
    # Python: a.conj().transpose()
    [r[i], p[i]] = mstats.pearsonr(
        M1.reshape(N**2, 1)[numpy.ix_(Offdiags)].conj().transpose(),
        M2.reshape(N**2, 1)[numpy.ix_(Offdiags)].conj().transpose())

print(f"Significant at p<.05 in {(100*sum(p<.05)/Nr)[0]} percent of cases")


# Plots using matplotlib
fig = plt.figure()
m1, m2, ax1 = fig.subplots(1, 3)
# Correlation matrix 1
m1.matshow(M1)
m1.set_title("Correlation matrix 1")
# Correlation matrix 2
m2.matshow(M2)
m2.set_title("Correlation matrix 2")
# Pearson correlation
ax1.set_title("Pearson correlation")
ax1.hist(r, bins=20)
ax1.plot([r[-1], r[-1]], ax1.get_ylim())
plt.show()
