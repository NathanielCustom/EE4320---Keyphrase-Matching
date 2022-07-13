# NoiseGate (sig, thresholdPercent)
#   x: 2D Vector of Values
#   thresholdPercent: Percent Quantile split point
#
# Calculates the specified percent quantile and any values below that threshold
# are set to zero.
#
# Nathaniel Hurley

function x = NoiseGate(x, thresholdPercent)
  # Flatten the vector, find the quantile, and then reshape to original
  # dimensions.
  thresholdPercent = [thresholdPercent];
  r = rows(x);
  c = columns(x);
  x = reshape(x,1,[]);
  thresholdMagnitude = quantile(x, thresholdPercent);
  x(x < thresholdMagnitude) = 0;
  x = reshape(x, r, c);
endfunction
