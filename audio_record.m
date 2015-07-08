%2015_Fundamentals_of_Speech_Recognition
%Please use matlab 2012b or any latest version such as 2014b.
%It might go wrong in early version.
for i =18:20
    ar = audiorecorder(8000,16,1);
    %record 4 seconds
    disp('Start speaking');
    recordblocking(ar,3.0);
    disp('End of Recording.');
    ar.pause;
    %get data
    x = getaudiodata(ar);
    plot(x);
    ar.play;
    path='data_zzd++/shanghai_';
    save(strcat(path,int2str(i)),'x');
end