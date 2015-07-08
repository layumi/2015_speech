load('data/data_11300240013_wangweiyi/data/beijing_2.mat');
re = audioplayer(x,8000);
y = fft(x,length(x));
plot(abs(y))
re.play;