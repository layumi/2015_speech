clear;
addpath('./voice_tool/voicebox');
addpath('./libsvm-3.20/matlab');
p = './mydata/';
subdir = dir(p);
fs = 8000;
data = [];
label = [];
for i=1:length(subdir)
    if( isempty( strfind(subdir( i ).name,'.mat') ) ) 
        continue;
    end
    audio = load(strcat(p,subdir(i).name)); 
    x = audio.x;
   %------------norm
    x = x ./max(abs(x));
   %-------------delete noise
    x = filter([1 -0.98],1,x);
    original_x = x;
    re = audioplayer(x,fs);
    re.play;
    %plot(original_x);figure;
    %plot(x);
   %-------------make frame
    n=160; %20ms
    tmp1 = enframe(x(1:end-1),hamming(n,'periodic'),n/4);
    tmp2 = enframe(x(2:end),hamming(n,'periodic'),n/4);
   %-------------calculate energy
    amp1 = sum(abs(x),2)';
    amp2 = sum(x.*x,2)';
   %-------------cross zero
   delta = 0.02;
   signs = (tmp1.*tmp2)<0 & (tmp1-tmp2)>delta;
   zer = sum(signs,2)';
   zer = repmat(zer,n/4,1);
   zer = reshape(zer,1,[]);
   zer2 = [zeros(1,40),zer,zeros(1,80)];
   zer3 = [zeros(1,80),zer,zeros(1,40)];
   zer4 = [zeros(1,120),zer];
   zer1 = [zer,zeros(1,120)];
   zer = (zer1+zer2+zer3+zer4)./4;
   zer = [zer,zeros(1,40)];
   zer = zer./max(abs(zer));
   %--------------put together
   fre_amp = zer.*amp1;
   local = find(fre_amp>0.05); 
   start = local(1);
   last = local(end);
   %re = audioplayer(original_x(start:last),8000);
   %re.play;
   x = original_x(start:last); 
   [c,tc] = melcepst(x,fs); 
   c = imresize(c,[40,12]);
   c = reshape(c,1,[]);
   data = [data;c];
   save(strcat('./normdata/',subdir(i).name),'x');
end
[idx,C] = kmeans(data,40);
for i=1:400 %400 is sample
    for j =1:40  %cluster
    I(i,j)= sum((data(i,:)-C(j,:)).*(data(i,:)-C(j,:)));
    end
end
label = [ones(1,20),2*ones(1,20),3*ones(1,20),4*ones(1,20),5*ones(1,20),6*ones(1,20),7*ones(1,20),8*ones(1,20),9*ones(1,20),10*ones(1,20),11*ones(1,20),12*ones(1,20),13*ones(1,20),14*ones(1,20),15*ones(1,20),16*ones(1,20),17*ones(1,20),18*ones(1,20),19*ones(1,20),20*ones(1,20)]';
model = svmtrain(label,I,'-c 1 -g 0.07 -b 1');
[predict_label, accuracy, dec_values] = svmpredict(label, I, model);