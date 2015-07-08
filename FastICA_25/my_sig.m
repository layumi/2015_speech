sig=[];
sig1=load('1.mat');
sig(1,:)=sig1.x;
sig2=load('2.mat');
sig(2,:)=sig2.x;
sig3=load('3.mat'); 
sig(3,:)=sig3.x;
sig4=load('4.mat');
sig(4,:)=sig4.x;
sig5=load('5.mat');
sig(5,:)=sig5.x;

for t=1:5
sig(t,:)=sig(t,:)/std(sig(t,:));
end