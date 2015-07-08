clear;
addpath('./zzd');%%测试谁加谁的程序文件夹
p = './data/';%%每个人录的20个语音存在这里
subdir = dir(p);
fs = 8000;
count = 0;
data = [];
truth=[];
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
        data = cat(2,data,x);
        truth = add_label(truth,file( j ).name);
        count = count+1;
    end
end
truth = truth';
your_label =speech(data,fs);%%speech is your function
disp('finish feature');
%-----------show result
result = sum(find(your_label==truth)>0);

fprintf('%f(%d/%d)\n',result/count,result,count);
