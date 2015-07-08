% % Generate example data: 2 groups, of 10 and 15, respectively
 X = [randn(10,2); randn(15,2) + 1.5];  Y = [zeros(10,1); ones(15,1)];
%
% % Calculate linear discriminant coefficients
 W = LDA(X,Y);
%
% % Calulcate linear scores for training data
 L = [ones(25,1) X] * W';
%
% % Calculate class probabilities
 P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);