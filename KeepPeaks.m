# KeepPeaks (sig, peakDistance)
#   x: 2D Vector of Values
#   thresholdPercent: Minimum Distance Between Peaks
#
# Finds peaks and zeros out all other results.
#
# Nathaniel Hurley

function x = KeepPeaks(x, peakDistance, direction)
  # Process Rows
  for r = 1:rows(x)
    [timePeaks, indexPeaks, extra] = findpeaks(x(r,:), "DoubleSided", "MinPeakDistance",peakDistance);
    empty = zeros(1,columns(x));  # Create "Canceling" Vector
    for ind = indexPeaks
      empty(ind) = 1;             # If index is a peak, then make a one.
    endfor
    x(r,:) = x(r,:) .* empty;     # Multiply Vectors - zeros clear out amplitude.
  endfor

  # Process Columns
  x = x'; # Transpose since findpeaks() will only work with rows.
  for r = 1:rows(x)
    [timePeaks, indexPeaks, extra] = findpeaks(x(r,:), "DoubleSided", "MinPeakDistance",peakDistance);
    empty = zeros(1,columns(x));  # Create "Canceling" Vector
    for ind = indexPeaks
      empty(ind) = 1;             # If index is a peak, then make a one.
    endfor
    x(r,:) = x(r,:) .* empty;     # Multiply Vectors - zeros clear out amplitude.
  endfor
  x = x'; # Transpose back.
endfunction
