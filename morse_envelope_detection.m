%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   morse_envelope_detection
%
%   takes a morse sequence encoded on a CW carrier, does envelope detection
%   with a Hilbert transform and low pass filters 
%
%   Inputs:      
%       Y: Raw data on a carrier
%       Fs: samping frequency (Hz)
%       filterData: flag to pass through a low pass filter
%
%   Returns:
%       envelope: signal envelope
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [envelope] = morse_envelope_detection( Y,Fs, filterData )


% Recommended: generalize the filter parameters a bit more, change
% filterData from a flag to a structure containing filter parameters or a
% precomputed set of coefficients


YH = hilbert(Y);

envelope = sqrt(Y.^2 + YH.*conj(YH));


plot_data = 1;


if filterData
    Fn  = Fs/2;                                 % Nyquist Frequency
    Fco =   Fs/400;                                 % Passband (Cutoff) Frequency
    Fsb =   Fs/256;                                 % Stopband Frequency
    Rp  =    5;                                 % Passband Ripple (dB)
    Rs  =   8;                                % Stopband Ripple (dB)
    [n,Wn]  = buttord(Fco/Fn, Fsb/Fn, Rp, Rs);  % Filter Order & Wco
    [b,a]   = butter(n,Wn);                     % Lowpass Is Default Design
    eF = filter(b,a,envelope);
    %[sos,g] = tf2sos(b,a);                      % Second-Order-Section For STability

   envelope = eF;
   
   if plot_data
 %   figure(1); plot(envelope(1:1.5*10^4)); title('Envelope');
    figure(1); plot(eF(1:1.5*10^4)); title('Filtered Envelope');
    end

end

end

