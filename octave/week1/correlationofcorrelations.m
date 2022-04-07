rand('state', 1);
N = 100;
Nr = 1000;

Offdiags = setdiff(1:N^2, 1:N+1:N^2);

M1 = toeplitz(N:-1:1)/N ;
size(M1)

%G1 = [ones(N,1); zeros(N,1)];

p = zeros(Nr,1);
r = zeros(Nr,1);

for i=1:Nr
    rp = randperm(N);
    M2 = M1(rp,rp);

%     M1 = double(bsxfun(@eq, G1, G1'));
%     M2 = double(bsxfun(@eq, G2, G2'));

    % TODO: needs checking, Octave implementation returns 2x2 matrix for both r and n
    [rn, pn] = corrcoef(M1(Offdiags)', M2(Offdiags)');
    r(i) = rn(2);
    p(i) = pn(2);


end

fprintf('Significant at p<.05 in %f percent of cases\n', 100*sum(p<.05)/Nr);

clf
subplot(1,3,1)
imagesc(M1)
title('Correlation matrix 1')

subplot(1,3,2)
imagesc(M2);
title('Correlation matrix 2');

subplot(1,3,3)
plot(M1(Offdiags),M2(Offdiags), '.');
title(sprintf('Correlation of correlations: p=%f', p(end)));

subplot(1,3,3); cla; hold on
hist(r,20);
plot([1 1]*r(end), ylim, 'r');
title('Pearson correlation')
