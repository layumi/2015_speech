clear;
addpath('./voice_tool/voicebox');
addpath('./libsvm-3.20/matlab');
p = './data/';
subdir = dir(p);
fs = 8000;
data = [];
label = [];
for i=1:length(subdir)
    if( strcmp(subdir( i ).name,'.') ||...
            strcmp(subdir( i ).name,'..') )
        continue;
    end
    file = dir(strcat(p,subdir(i).name));
    for j=1:length(file)%%
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
        %-------------delete noise
        %x = filter([1 -0.98],1,x);
        x = filter(ones(1,8)./8,1,x);
        x = x ./max(abs(x));
        %re = audioplayer(x,fs);
        %re.play;
        % re = audioplayer(x,fs);
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
        %plot(fre_amp);
        start = local(1);
        last = local(end);
        %re = audioplayer(x(start:last),8000);
        %re.play;
        x = original_x(start:last)';
        if(size(x,2)<100)  % error input
            continue;
        end
        [c,tc] = melcepst(x,fs);
        size_c = size(c);
        if(size_c(1)>200)  % error input
            continue;
        end
        %plot(c);
        %figure;
        c = imresize(c,[64,16],'bilinear');
       % plot(c);
        c = reshape(c,1,[]);
        data = [data;c];
        label = add_label(label,file(j).name);
    end
end
sample_size =size(data);

[idx,C] = kmeans(data,256);
disp('finish cluster&&feature');
for i=1:sample_size(1) %
    for j =1:256  %cluster
        I(i,j)= sum((data(i,:)-C(j,:)).*(data(i,:)-C(j,:)));
    end
end
label = label';
%}
%%PCA
%{
[cof,score] = pca(data);
eigen_vertex = cof(:,1:256);
eigen_part = score(:,1:256);%%ǰ256
I = eigen_part;
%}
%label = [ones(1,20),2*ones(1,20),3*ones(1,20),4*ones(1,20),5*ones(1,20),6*ones(1,20),7*ones(1,20),8*ones(1,20),9*ones(1,20),10*ones(1,20),11*ones(1,20),12*ones(1,20),13*ones(1,20),14*ones(1,20),15*ones(1,20),16*ones(1,20),17*ones(1,20),18*ones(1,20),19*ones(1,20),20*ones(1,20)]';
%label = repmat(label,sample_size(1)/400,1);

%----------LDA
w = LDA(I,label);%LDA
L = [ones(sample_size(1),1) I] * w';
[~,index]=max(L,[],2);
result = 0;
for i = 1:sample_size(1)
    if index(i)==label(i)
        result = result+1;
    end
end
fprintf('%f(%d/%d)\n',result/sample_size(1),result,sample_size(1));
M.C = C;
M.w = w;
save('Model.mat','M');
%----------svm
%{
for i = 1:1
    haha = power(2,i);
    str = sprintf('-s 0 -t 1 -g %f',haha);
    model = svmtrain(label,I,str); %-t 0
    [predict_label, accuracy, dec_values] = svmpredict(label, I, model);
    filename = sprintf('svm-s0-t1-g%d.mat',i);
    save(filename,'model');
end
%}