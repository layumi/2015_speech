addpath(genpath('./HMMall'));
hhh = load('data.mat');
data = hhh.I;
label = hhh.label;
[LL, prior2, transmat2, obsmat2] = dhmm_em(data, prior1, transmat1, obsmat1, 'max_iter', 5);
testHMM;