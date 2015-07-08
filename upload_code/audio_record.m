%2015_Fundamentals_of_Speech_Recognition
%Please use matlab 2012b or any latest version such as 2014b.
%It might go wrong in early version.
%{
beijing   1
close     2
computer  3
daikai    4
delete    5
file      6      
guanbi    7
hebei     8
henan     9
image     10
jisuanji  11
open      12
shanchu   13
shanghai  14
signal    15
speech    16
tuxiang   17
wenjian   18
xinhao    19
yuyin     20
%}

for i =1:20
    ar = audiorecorder(8000,16,1);
    %record 3 seconds
    disp('Start speaking');
    recordblocking(ar,3.0);
    disp('End of Recording.');
    ar.pause;
    %get data
    x = getaudiodata(ar);
    plot(x);
    ar.play;
    try
         path='data/zzd/';
         save(strcat(path,int2str(i)),'x');
    catch
         mkdir('data/zzd');
         path='data/zzd/'; %一个人改一次名字
         save(strcat(path,int2str(i)),'x');
    end
%这里设置断点
end