clear;
addpath('./voice_tool/voicebox');
addpath('./libsvm-3.20/matlab');
M = load('Model.mat');
M = M.M;
%model = M.model;
C = M.C;%%kmeans
p = './data_test/';
%p = './data_linzejun/';
subdir = dir(p);
fs = 8000;
data = [];
label = [];
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
        %-------------delete noise
        %x = filter([1 -0.98],1,x);
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
        try
            start = local(1);
        catch
            continue;
        end
        last = local(end);
        if(last-start<200)  % error input
            continue;
        end
        %re = audioplayer(original_x(start:last),8000);
        %re.play;
        x = original_x(start:last);
        [c,tc] = melcepst(x,fs);
        size_c = size(c);
        if(size_c(1)>200)  % error input
            continue;
        end
        %for jj = 1:16
         %   cc = cat(2,cc,imresize(c(:,jj),[64,1],'bilinear'));
        %end
        c = imresize(c,[64,16],'bilinear');
       % disp(sum(sum(cc==c)));
        c = reshape(c,1,[]);
        %cc = reshape(cc,1,[]);
        data = [data;c];
        label = add_label(label,file(j).name);
    end
end
sample_size =size(data);
disp('finish feature');
for i=1:sample_size(1) %
    for j =1:256  %cluster
        I(i,j)= sum((data(i,:)-C(j,:)).*(data(i,:)-C(j,:)));
    end
end
label = label';
%-----------LDA
w = M.w;
L = [ones(sample_size(1),1) I] * w';
[M,index]=max(L,[],2);
result = 0;
for i = 1:sample_size(1)
    if index(i)==label(i)
        result = result+1;
    end
end
fprintf('%f(%d/%d)\n',result/sample_size(1),result,sample_size(1));
%-----------svm


%{
for i = 1:8
    result = 0;
    filename = sprintf('svm-s0-t1-g%d.mat',i);
    svm = load(filename);
    model =svm.model;
    [predict_label, accuracy, dec_values] = svmpredict(label, I, model,'-q');
    for j = 1:sample_size(1)
        if predict_label(j)==label(j)
            result = result+1;
        end
    end
    fprintf('%d::%f(%d/%d)\n',i,result/sample_size(1),result,sample_size(1));
end
%}