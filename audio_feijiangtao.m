clear;
addpath('./voice_tool/voicebox');
addpath('./libsvm-3.20/matlab');
p = './data/data_12302010026_feijiangtao/';
subdir = dir(p);
fs = 8000;
data = [];
label = [];
fs = 8000;
for i=1:length(subdir)
    if( isempty( strfind(subdir( i ).name,'.mat') ) ) 
        continue;
    end
    audio = load(strcat(p,subdir(i).name)); 
    x = audio.x;
    x = [zeros(2000,1);x(2001:end)];
    %re = audioplayer(x,fs);
    %re.play;
    save(strcat('./normdata_feijiangtao/',subdir(i).name),'x');
end