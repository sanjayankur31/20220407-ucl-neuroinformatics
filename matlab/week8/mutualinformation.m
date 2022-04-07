rng(1);
N = 500;

x = (rand(N,1)>.5);
y = (rand(N,1)>.5);

x2 = (rand(N,1)>.5);
y2 = (rand(N,1)>.5);


I = zeros(N,1);
I2 = zeros(N,1);

h = zeros(2);
h2 = zeros(2);
for i=1:N
    h(x(i)+1,y(i)+1) = h(x(i)+1,y(i)+1)+1;
    h2(x2(i)+1,y2(i)+1) = h2(x2(i)+1,y2(i)+1)+1;
    
    p = h/i;
    p2 = h2/i;
    
    p0 = sum(p,2)*sum(p,1);
    
    I(i) = p(:)'*(log2(p(:)) - log2(p0(:)));
    I2(i) = p2(:)'*(log2(p(:)) - log2(p0(:)));

end


plot(1:N,I, 1:N,I2);
xlabel('Sample size');
ylabel('Estimated information');
legend('Plug-in', 'Cross-validated')