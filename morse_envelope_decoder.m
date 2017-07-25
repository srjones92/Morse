%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   morse_envelope_decoder
%
%   takes a morse sequence encoded on a CW carrier, does envelope detection
%   with a Hilbert transform and low pass filters 
%
%   Inputs:      
%       envelope: envelope signal, calculated by morse_envelope_detection
%       Fs: samping frequency (Hz)
%
%   Returns:
%       seqn: N x 1, {-1 0 1} sequence of dashes/spaces/dots
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [seqn] = morse_envelope_decoder(envelope,Fs)

[pw, icross, fcross] = pulsewidth(envelope,'Tolerance',20.0);

% . = 1
% - = -1
% EOC & space = 0


% Currently divides pulses as the mean - some analysis on frequency of dots
% and dashes in english morse code or a bit of higher order statistics
% could improve this.

u = mean(pw);
seqn = [];
for j=1:length(pw)   
    if pw(j) < u
        seqn = [seqn, 1];
    else
        seqn = [seqn, -1];
    end
    
    if ( j > 1 ) && ( j < length(pw) )
        if abs( fcross(j) - icross(j+1) ) > u
            seqn = [seqn 0];
        end
    end
    
end

seqn = [seqn 0];





end