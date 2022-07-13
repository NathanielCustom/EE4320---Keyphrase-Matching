# DistanceCalc (x)
#   x: 2D Vector of Values
#    : Rows = frequency
#    : Columns = time
#    : Value = Amplitude
#  nn: number of nearest neighbhors
#
# Generates a unique signature based on a vector of peaks found with KeepPeaks.m
#
# Nathaniel Hurley

function x = DistanceCalc(x, nn)
  # Signature Algorithm
  # A variation of the euclidean distance is measured from a "reference"
  # amplitude peak (ref_a) to N-nearest "target" amplitude peaks (tar_a) where
  # time of target peak (tar_t) is less than the reference peak time
  # (ref_t).
  #
  # Higher amplitude reference peaks have greater weight and similar amplitudes
  # have greater weight - ref_a / delta_a where delta_a minimum is 1.
  #     Where ref_a = tar_a = 100, 100 / 1 = 100
  #     Where ref_a = tar_a =  10,  10 / 1 =  10
  #
  # The further the frequencies, the greater the weight per euclidean formula.
  #
  # Change in time doesn't matter, but order does. Calculate to previous peaks.
  # Two peaks at the same time of different frequencies are averaged to produce
  # one value for the signature.

  DELTA_MIN = 1;

  ## Testing Values ##
  #x = [1 0 0 0 ; 0 0 0 1 ; 0 1 0 0 ; 0 0 0 1]
  #nn = 3;

  ## Extract All Peaks ##
  # Generate a list of all peaks from input vector. Ignore all zero values.
  # Lastly, flip vector to put in descending order of time (columns).
  #   | "time" | "freq" |  "amp"  |
  #   | col_n-0, row_n-0, amp_n-0 |
  #   | col_n-1, row_n-1, amp_n-1 |
  #   |   ...  ,   ...  ,   ...   |
  #   |  col_1 ,  row_1 ,  amp_1  |

  peaks = [];
  for i = 1:columns(x)
    for j = 1:rows(x)
      if x(j,i) != 0
        peaks = [peaks; i, j, x(j,i)];
      endif
    endfor
  endfor
  peaks = flip(peaks,1);


  # Determine N-nearest peaks by euclidean distance of time and frequency and
  # calculate a signature value.
  signature = [];
  distancesOfTimeT = [];
  for i = 1:rows(peaks)
    # Reference Peak
    ref_t = peaks(i,1);
    ref_f = peaks(i,2);
    ref_a = peaks(i,3);


    ## Find N-Nearest Neighbors ##
    # Cycle through all possible target peaks. Add value to list if N-smallest
    # (closest) peaks.
    #   |  "time"    |   "freq"    |  "amp"   |  "dist"   |
    #   |  time_nn   ,   freq_nn   , amp_nn   , dist_nn   |
    #   |  time_nn-1 ,   freq_nn-1 , amp_nn-1 , dist_nn-1 |
    #   |     ...    ,     ...     ,    ...    ,    ...    |
    #   |  time_1    ,   freq_1    , amp_1    , dist_1    |

    closest = [];
    for j = i+1:rows(peaks)
      tar_t = peaks(j,1);
      tar_f = peaks(j,2);
      tar_a = peaks(j,3);
      distance = sqrt( (ref_t-tar_t)^2 + (ref_f-tar_f)^2 );

      # Find largest distance and replace if new distance is smaller.
      if rows(closest) < nn # When closest vector has not reach N-nearest.
        closest(rows(closest)+1,:) = [tar_t, tar_f, tar_a, distance];
      else
        [a, ia] = max(closest);
        if a(4) > distance
          closest(ia(4),:) = [tar_t, tar_f, tar_a, distance];
        endif
      endif
    endfor


    ## Calculate Signature Value ##
    sigValue = 0;
    for j = 1:rows(closest)
      tar_t = closest(j,1);
      tar_f = closest(j,2);
      tar_a = closest(j,3);

      # Avoid Dividing By Zero
      if ref_a-tar_a == 0
        delta_a = DELTA_MIN;
      else
        delta_a = ref_a-tar_a;
      endif

      # Calculate Signature
      sigValue = sigValue + sqrt( (ref_t-tar_t)^2 + (ref_f-tar_f)^2 ...
                                                  + (ref_a-tar_a)^2);
      %sigValue = sigValue + sqrt( (ref_f-tar_f)^2 + (ref_a-tar_a)^2 );                                            
    endfor
    distancesOfTimeT = [distancesOfTimeT, sigValue];

    ## Average signatures for peaks of same time bin. ##
    if i+1 > rows(peaks) || peaks(i+1,1) ~= peaks(i,1)
      # Store Signature
      signature = [signature, mean(distancesOfTimeT)];
      distancesOfTimeT = [];
    endif

  endfor

# Flip signature to put in ascending time order.
x = flip(signature(1:columns(signature)-1));
endfunction
