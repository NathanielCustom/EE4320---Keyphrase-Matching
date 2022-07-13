#Ben Milkint
#Speech Filter for Final Project
#4/25/22
function [cmd_start_index,cmd_end_index,n]=FilterSpeech(cmd_list,cmd_list_fs)

pkg load signal; #load xcorr function
pkg load image;  #load bwareaopen function

#{
# Prompt user for command list audio file
[cmd_list_file, cmd_list_path] = uigetfile;
cmd_list_fullpath = strcat(cmd_list_path, cmd_list_file);

#Read command list file
[cmd_list, cmd_list_fs] = audioread(cmd_list_file);
#}
#normalize input?

#Calculate short term energy of entire function using windows, then zero out values below certain threshold,
#set other values to one, fill in holes, use start and end times to extract seperate audio samples

win_len=250; #set size of window length and step
win_step=win_len;
cmd_list_energy_spec = zeros(length(cmd_list),1);
for (i=1:floor(length(cmd_list)/win_len)-1)
  temp_window = windowAnalysis(win_len, win_step, i-1, cmd_list);
  window_amp_spec = abs(fft(temp_window));  #fft of window
  window_energy = window_amp_spec.*window_amp_spec;  #square fft to get energy
  cmd_list_energy_spec((i*win_len):((i+1)*win_len)-1)=window_energy(1:win_len);   
endfor
cmd_list_energy_spec = cmd_list_energy_spec/max(abs(cmd_list_energy_spec));  #normalize energy


#set values to either 1 or zero depending on if above or below threshold


energy_threshold = .015;   #arbitrary value; need to change to automatically detect % of energy above threshold
voice_detect = zeros(length(cmd_list_energy_spec),1);
voice_detect_filled = zeros(1,length(cmd_list_energy_spec));
gap_size=0;
prev=0;
min_gap=cmd_list_fs/3; #minimum gap size (span of 0's) allowed in samples; anything smaller set to 1's; fs/2=>assume commands are at least 1/2 second apart
for(i=1:length(cmd_list_energy_spec))
  if cmd_list_energy_spec(i)>energy_threshold;
    voice_detect(i-1000:i+1000)=1;
  endif
  
    
  #fill small holes of 0's (less than min_gap) with 1's 
  #{ 
  Found better method using bwareaopen() from image package; left in in case he doesn't want us using that
  
  if voice_detect(i)==0
    gap_size++;
    prev = 0;  
  elseif (voice_detect(i)==1 && prev==0)
    if gap_size<=min_gap
       voice_detect_filled(i-gap_size:i)=1;
    endif
    prev=1;
    gap_size=0;
  else
    voice_detect_filled(i)=1;
    prev=1;
    gap_size=0;
  endif
  #}
endfor

#fill small holes of 0's (less than min_gap) with 1's (better method)
voice_detect_flipped = ~voice_detect;
voice_detect_flipped_filled=bwareaopen(voice_detect_flipped, min_gap);
voice_detect_filled=~voice_detect_flipped_filled;


cmd_voice_only = cmd_list.*voice_detect_filled;


#find start and end of each command and store in strings cmd_start_index and cmd_end_index
currentval=0;
prevval=0;
index_count=1;  #start at first index
cmd_start_index=0;
cmd_end_index=0;
for(i=1:length(voice_detect_filled))
currentval=voice_detect_filled(i);
  if(currentval==1 && prevval==0)
    cmd_start_index(index_count)=i;
  endif
  if(currentval==0 && prevval==1)
    cmd_end_index(index_count)=i;
    index_count++;
  endif
prevval=currentval;
endfor

n=length(cmd_end_index);



##Use these plots to show how function works

#{
figure(1)
subplot(5,1,1)
plot(cmd_list)
subplot(5,1,2)
plot(cmd_list_energy_spec)
subplot(5,1,3)
plot(voice_detect)
subplot(5,1,4)
plot(voice_detect_filled)
subplot(5,1,5)
plot(cmd_voice_only)
#}

##sound(cmd_voice_only, cmd_list_fs);  #play sound to test



endfunction


