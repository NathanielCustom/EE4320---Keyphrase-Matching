##Test
clear
close all
pkg load signal;

[audio_file1, audio_path1] = uigetfile;
audio_fullpath1 = strcat(audio_path1, audio_file1);
[sig1, sig_fs1] = audioread(audio_fullpath1);

[audio_file2, audio_path2] = uigetfile;
audio_fullpath2 = strcat(audio_path2, audio_file2);
[sig2, sig_fs2] = audioread(audio_fullpath2);

[audio_file3, audio_path3] = uigetfile;
audio_fullpath3 = strcat(audio_path3, audio_file3);
[sig3, sig_fs3] = audioread(audio_fullpath3);

[audio_file4, audio_path4] = uigetfile;
audio_fullpath4 = strcat(audio_path4, audio_file4);
[sig4, sig_fs4] = audioread(audio_fullpath4);

[audio_file5, audio_path5] = uigetfile;
audio_fullpath5 = strcat(audio_path5, audio_file5);
[sig5, sig_fs5] = audioread(audio_fullpath5);


target_length = 32000;
scale1 = target_length/length(sig1);
scale2 = target_length/length(sig2);
scale3 = target_length/length(sig3);
scale4 = target_length/length(sig4);
scale5 = target_length/length(sig5);


sig1 = resample(sig1, floor(scale1*100) , 100);
sig2 = resample(sig2, floor(scale2*100) , 100);
sig3 = resample(sig3, floor(scale3*100) , 100);
sig4 = resample(sig4, floor(scale4*100) , 100);
sig5 = resample(sig5, floor(scale5*100) , 100);
#{
figure(1)
subplot(3,1,1)
specgram(sig1)
subplot(3,1,2)
specgram(sig2)
subplot(3,1,3)
specgram(sig3)
#}

input1=CreateSignature(sig1,sig_fs1);
input2=CreateSignature(sig2,sig_fs2);
input3=CreateSignature(sig3,sig_fs3);
input4=CreateSignature(sig4,sig_fs4);
input5=CreateSignature(sig5,sig_fs5);

input1=input1./(max(abs(input1)));
input2=input2./(max(abs(input2)));
input3=input3./(max(abs(input3)));
input4=input4./(max(abs(input4)));
input5=input5./(max(abs(input5)));

figure(2)
subplot(5,1,1)
plot(input1);
subplot(5,1,2)
plot(input2);
subplot(5,1,3)
plot(input3);
subplot(5,1,4)
plot(input4);
subplot(5,1,5)
plot(input5);


minLength=min([length(input1),length(input2),length(input3),length(input4),length(input5)]);
input1=input1(1:minLength);
input2=input2(1:minLength);
input3=input3(1:minLength);
input4=input4(1:minLength);
input5=input5(1:minLength);

corr1=xcorr(input1, input1, minLength,'coeff');
corr2=xcorr(input1, input2, minLength,'coeff');
corr3=xcorr(input1, input3, minLength,'coeff');
corr4=xcorr(input1, input4, minLength,'coeff');
corr5=xcorr(input1, input5, minLength,'coeff'); 

figure(3)
subplot(5,1,1)
plot(corr1);
subplot(5,1,2)
plot(corr2)
subplot(5,1,3)
plot(corr3)
subplot(5,1,4)
plot(corr4);
subplot(5,1,5)
plot(corr5)


max1=max(corr1)
max2=max(corr2)
max3=max(corr3)
max4=max(corr4)
max5=max(corr5)



#{
corr_val1(1)=max(xcorr(input1,input1))
corr_val2(1)=max(xcorr(input1,input2))
corr_val3(1)=max(xcorr(input1,input3))
corr_sum1(1)=sum(xcorr(input1,input1));
corr_sum2(1)=sum(xcorr(input1,input2));
corr_sum3(1)=sum(xcorr(input1,input3));
#}



