function label = speech(audio,fs)
addpath('zzd/voicebox');
M = load('Model.mat');
M = M.M;
%model = M.model;
C = M.C;%%kmeans
data = [];
label = [];
audio = audio';
sample_size =size(audio);
for i = 1:sample_size(1)
        x = audio(i,:);
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
        start = local(1);
        last = local(end);
        %re = audioplayer(original_x(start:last),8000);
        %re.play;
        x = original_x(start:last);
        [c,tc] = melcepst(x,fs);
        size_c = size(c);
        %for jj = 1:16
         %   cc = cat(2,cc,imresize(c(:,jj),[64,1],'bilinear'));
        %end
        c = imresize(c,[64,16],'bilinear');
       % disp(sum(sum(cc==c)));
        c = reshape(c,1,[]);
        %cc = reshape(cc,1,[]);
        data = [data;c];
end

%disp('finish feature');
for i=1:sample_size(1) %
    for j =1:256  %cluster
        I(i,j)= sum((data(i,:)-C(j,:)).*(data(i,:)-C(j,:)));
    end
end
%-----------LDA
w = M.w;
L = [ones(sample_size(1),1) I] * w';
[M,index]=max(L,[],2);
label = index;