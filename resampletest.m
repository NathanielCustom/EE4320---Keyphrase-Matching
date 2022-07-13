##Test
clear
close all
pkg load signal;

[audio_file1, audio_path1] = uigetfile;
audio_fullpath1 = strcat(audio_path1, audio_file1);
[sig1, sig_fs1] = audioread(audio_fullpath1);

target_length = 48000
scale = target_length/length(sig1)


sig1_resamp = resample(sig1, floor(scale*100) , 100);

figure(1)
subplot(2,1,1)
specgram(sig1)
subplot(2,1,2)
specgram(sig1_resamp)