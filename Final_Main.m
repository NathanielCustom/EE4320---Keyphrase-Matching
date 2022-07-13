##Test
clear
close all
pkg load signal;

##First open command bank, then each of 6 inputs


# Prompt user for command list audio file
[cmd_list_file, cmd_list_path] = uigetfile;
cmd_list_fullpath = strcat(cmd_list_path, cmd_list_file);

#Read command list file
[cmd_list, cmd_list_fs] = audioread(cmd_list_file);


# Prompt user for command input
[audio_file, audio_path] = uigetfile;
audio_fullpath = strcat(audio_path, audio_file);
### Declare Constants ###
[sig1, sig_fs1] = audioread(audio_fullpath);

[input_start,input_end,input_n]=FilterSpeech(sig1,sig_fs1);

if(input_n!=1)
  error("ERROR WITH COMMAND INPUT");
endif

if(input_end==0)
  sig1=sig1(input_start:length(sig1));
else
  sig1=sig1(input_start:input_end);
endif


#Filter individual commands
[cmd_start_index,cmd_end_index,bank_n]=FilterSpeech(cmd_list,cmd_list_fs);

bank_avg_length=0;

for(i=1:bank_n)
  bank_avg_length=bank_avg_length+(cmd_end_index(i)-cmd_start_index(i));
endfor
bank_avg_length=bank_avg_length/bank_n;

target_length = mean([length(sig1),bank_avg_length]);



for(i=1:bank_n)
  bank_scale(i)=target_length/(cmd_end_index(i)-cmd_start_index(i));
  bank{i}=resample(cmd_list(cmd_start_index(i):cmd_end_index(i)),floor(bank_scale(i)*100),100);
  bank_signature{i}=CreateSignature(bank{i},cmd_list_fs);
  bank_signature{i}=bank_signature{i}./max(abs(bank_signature{i})); #normalize signature
endfor
##bank(1,:) is bank item 1, bank(2,:) item 2, etc
##Bank_signature follows same format

scale1 = target_length/length(sig1);
sig1 = resample(sig1, floor(scale1*100) , 100);
input1=CreateSignature(sig1,sig_fs1);

#Normalize signature
input1=input1./(max(abs(input1)));


bank_sig_mean_length=0;
for(i=1:bank_n)
  bank_sig_mean_length=bank_sig_mean_length+length(bank_signature{i}); #normalize signature
endfor
bank_sig_mean_length=bank_sig_mean_length/bank_n;

##80 gets 5/6; try 100 if mean doesn't work well
target_sig_length=floor(mean([length(input1),bank_sig_mean_length]));

bank_sig_scale=0;
for(i=1:bank_n)
  bank_sig_scale(i)=target_sig_length/length(bank_signature{i});
  bank_signature{i}=resample(bank_signature{i},floor(bank_sig_scale(i)*100),100);
endfor

##refactor signature
sig_scale1 = target_sig_length/length(input1);
input1 = resample(input1, floor(sig_scale1*100) , 100);

figure(2)
subplot(bank_n+1,1,1)
plot(input1);
title("Signature of Input Command")
for(i=1:bank_n)
  subplot(bank_n+1,1,i+1);
  plot(bank_signature{i});
  title(strcat("Signature of Bank Item ",int2str(i)));
  corr_val(i)=max(xcorr(input1,bank_signature{i},target_sig_length,'coeff'));
endfor

disp('Correlation Value for Each Bank Item:')
disp(corr_val)
disp('Command Detected:')
disp(find(corr_val==max(corr_val)))





