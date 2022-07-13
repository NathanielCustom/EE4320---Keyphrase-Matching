% sig_window = windowAnalysis_lab2(win_len, win_step, win_index, sig) 
% 
% win_len – window length in samples 
% win_step – window step in samples 
% win_index – window index 
% 2022  <Discrete Convolutionists> 
%
% Takes the input signal stored in vector "sig" and returns a portion of the
% signal that is captured by the analysis window.


# Nathaniel Hurley
function retval = windowAnalysis(win_len, win_step, win_index, sig)
  # Recall: Octave indexes vector entries from 1.
  
  start_index = win_index * win_step;
  end_index = start_index + ( win_len - 1 );
  retval = sig( start_index + 1 : end_index + 1 );
  
endfunction
