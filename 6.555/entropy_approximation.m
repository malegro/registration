function [approx] = entropy_approximation(samples1, samples2)

%
%
%

%alpha1 = 1.5;

samples1 = samples1(:);
samples2 = samples2(:);

A = cosh([samples1 samples2]);
B = A(:,1).^2 + A(:,2).^2;

approx = sum(log(B));



%approx = sum(-exp(-[samples1.^2+samples2.^2]/2)); 
