# Nathaniel Hurley
function retval = CreateSignature(sig,sig_fs)
#### Variables ####
GATE_THRESHOLD = 0.95;
PEAK_WIDTH = 5;
N_NEIGHBORS = 5;

###################################
######### Load Audio Data #########
###################################

#{
### Prompt User for Audio Files. ###
# First file should be of the clean sample. Second file of the noise sample.
[audio_file, audio_path] = uigetfile;
audio_fullpath = strcat(audio_path, audio_file);

### Declare Constants ###
[sig, sig_fs] = audioread(audio_fullpath);
#}

audio_length = length(sig);

###################################
########### Pre-Process ###########
###################################

### Normalize ###
sig_norm = sig./(max(abs(sig)));

### Spectrogram ###
# S: Amplitudes [R X C]
# f: Bin Frequency [1 X R]
# t: Bin Time [C X 1]
[S, f, t] = specgram(sig_norm);

### Noise Gate ###
S = abs(S);
S = NoiseGate(S, GATE_THRESHOLD);

### Prominent Peaks ###
S = KeepPeaks(S, PEAK_WIDTH);


###################################
####### Calculate Signature #######
###################################

### Generate Signature ###
Signature = DistanceCalc(S, N_NEIGHBORS);

### Export Signature as CSV ###
##filename = input("Input Filename: ", "s")
##csvwrite(filename, Signature)
retval=Signature;
endfunction

