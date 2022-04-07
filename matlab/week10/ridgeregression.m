rng(1);
N = 400;
p = 399;
noise = .1;

X = randn(N,p);
y = X(:,1) + noise * randn(N,1);

Xtest = randn(N,p);
ytest = Xtest(:,1) + noise * randn(N,1);


lambda = 100;

w = (X'*X + lambda*eye(p)) \ X'*y;

yhat = X*w;

figure(1); 
subplot(2,2,1); cla; hold on
plot(X(:,1), y, '.');
xlabel('x_1');
ylabel('y');
title('Training set');
axis([-3 3 -3 3]);
plot([-3 3], [-3 3]);


subplot(2,2,2); cla; hold on
plot(y, yhat, '.');
xlabel('y');
ylabel('y^');
title('Training set');
axis([-3 3 -3 3]);
plot([-3 3], [-3 3]);

subplot(2,2,3); cla; hold on
bar(w);
title('weights')
axis([0 p+1 -1 2])

subplot(2,2,4); cla; hold on
plot(ytest, Xtest*w, '.');
xlabel('y');
ylabel('y^');
title('Test set');
axis([-3 3 -3 3]);
plot([-3 3], [-3 3]);
