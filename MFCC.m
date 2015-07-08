clear;
addpath('./voice_tool/voicebox');
p = './mydata/';
subdir = dir(p);
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
    %re = audioplayer(x,8000);
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
   fre_amp = zer.*amp1;
   local = find(fre_amp>0.05); 
   start = local(1);
   last = local(end);
   %re = audioplayer(original_x(start:last),8000);
   %re.play;
   save(strcat('./normdata/',subdir(i).name),'x');
end