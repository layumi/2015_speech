hhh = load('data.mat');
I = hhh.I;
label = hhh.label;
for i = 1:8
    haha = power(2,i);
    str = sprintf('-s 0 -t 2 -g %d -c 0.52',haha);
    model = svmtrain(label,I,str); %-t 0
    [predict_label, accuracy, dec_values] = svmpredict(label, I, model);
    filename = sprintf('svm-s0-t2-g%d.mat',i);
    save(filename,'model');
end