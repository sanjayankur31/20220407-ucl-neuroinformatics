#!/usr/bin/env python3


import numpy
from sklearn import linear_model
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error


numpy.random.seed(1)


N = 30
eps = .1
xr = numpy.arange(0, 1, 0.01)[:, numpy.newaxis]

x = numpy.sort(numpy.random.uniform(size=[N, 1]))
X1 = numpy.hstack((numpy.ones(x.shape), x))
X2 = numpy.hstack((numpy.ones(x.shape), x, x**2, x**3, x**4, x**5))

Xr1 = numpy.hstack((numpy.ones(xr.shape), xr))
Xr2 = numpy.hstack((numpy.ones(xr.shape), xr, xr**2, xr**3, xr**4, xr**5))

y = x + numpy.random.normal(size=[N, 1]) * eps

reg1 = linear_model.LinearRegression()
reg1.fit(X1, y)

reg2 = linear_model.LinearRegression()
reg2.fit(X2, y)

yrhat1 = Xr1 @ reg1.coef_.transpose()
yrhat2 = Xr2 @ reg2.coef_.transpose()

e1 = numpy.sum((y - X1 @ reg1.coef_.transpose())**2)
e2 = numpy.sum((y - X2 @ reg2.coef_.transpose())**2)


# plots
fig, axs = plt.subplots(2, 2)

axs[0, 0].scatter(x, y, marker='.')
axs[0, 0].plot(xr, yrhat1)
axs[0, 0].set_title(label=f"Training set error {e1}")


axs[0, 1].scatter(x, y, marker='.')
axs[0, 1].plot(xr, yrhat2)
axs[0, 1].set_title(label=f"Training set error {e2}")

xt = numpy.sort(numpy.random.uniform(size=[N, 1]))
Xt1 = numpy.hstack((numpy.ones(xt.shape), xt))
Xt2 = numpy.hstack((numpy.ones(xt.shape), xt, xt**2, xt**3, xt**4, xt**5))

yt = xt + numpy.random.normal(size=[N, 1]) * eps

e3 = numpy.sum((yt - Xt1 @ reg1.coef_.transpose())**2)
e4 = numpy.sum((yt - Xt2 @ reg2.coef_.transpose())**2)

axs[1, 0].scatter(xt, yt, marker='.')
axs[1, 0].plot(xr, yrhat1)
axs[1, 0].set_title(label=f"Training set error {e3}")


axs[1, 1].scatter(xt, yt, marker='.')
axs[1, 1].plot(xr, yrhat2)
axs[1, 1].set_title(label=f"Training set error {e4}")

plt.show()
