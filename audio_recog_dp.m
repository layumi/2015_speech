clear;
addpath('./voice_tool/voicebox');
addpath('./libsvm-3.20/matlab');
addpath('./matconvnet-1.0-beta12/matlab');
addpath('./matconvnet-1.0-beta12/examples');
p = './data/';
subdir = dir(p);
fs = 8000;
data = single([]);
label = [];
count = 1;
for i=1:length(subdir)
    if( strcmp(subdir( i ).name,'.') ||...
            strcmp(subdir( i ).name,'..')  )
        continue;
    end
    file = dir(strcat(p,subdir(i).name));
    for j=1:length(file)
        if( isempty( strfind(file( j ).name,'.mat') ) )
            continue;
        end
        audio = load(strcat(p,subdir(i).name,'/',file(j).name));
        x = audio.x;
        x = x(1001:end);
        %------------norm
        x = ssubmmsev(x,fs);
        x = x ./max(abs(x));
        %x = filter([1 -0.97],1,x);
        original_x = x;
        x = filter(ones(1,8)./8,1,x);
        x = x ./max(abs(x));
        %re = audioplayer(x,fs);
        %re.play;
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
        fre_amp = zer.*amp2;
        local = find(fre_amp>0.05);
        start = local(1);
        last = local(end);
         %re = audioplayer(original_x(start:last),8000);
         %re.play;
        x = original_x(start:last)';
        if(size(x,2)<100)  % error input
            continue;
        end
        [c,tc] = melcepst_12(x,fs);
        size_c = size(c);
        if(size_c(1)>200)  % error input
           continue;
        end
        c = imresize(c,[48,12],'bilinear');
        c = reshape(c,24,24);
        c = im2single(c);
        data(:,:,count) = c;
        count = count + 1;
        label = add_label(label,file(j).name);
    end
end
sample_size =size(data);
M.images.data = data;
M.images.label = label;
save('./matconvnet-1.0-beta12/audio_data_dp_new.mat','M');
%------- forward
result=0;
net = load('./matconvnet-1.0-beta12/data/24net-experiment-normB_new/f24net.mat');
data2 = reshape(data, 24, 24, 1, []);
data2 = 256*(data2 - net.imageMean) ;
%vl_compilenn();
res = vl_simplenn(net,data2) ;
DP = res(end).x;
DP = reshape(DP,[],sample_size(3))' ;
[~,index]=max(DP,[],2);
for i = 1:sample_size(3)
    if index(i)==label(i)
        result = result+1;
    end
end
fprintf('%f(%d/%d)\n',result/sample_size(3),result,sample_size(3));

%----------LDA
I = res(end-2).x;
I = reshape(I,[],sample_size(3))';
w = LDA(I,label);%LDA
L = [ones(sample_size(3),1) I] * w';
[~,index]=max(L,[],2);
result = 0;
for i = 1:sample_size(3)
    if index(i)==label(i)
        result = result+1;
    end
end
fprintf('%f(%d/%d)\n',result/sample_size(3),result,sample_size(3));
MD.w = w;
save('Model_dp.mat','MD');