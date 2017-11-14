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


function [seqn,varargout] = morse_envelope_decoder(envelope,Fs)

    nout = max(nargout,1) - 1;


[pw, icross, fcross] = pulsewidth(envelope,'Tolerance',20.0);

% . = 1
% - = -1
% EOC & space = 0


% Currently divides pulses as the mean - some analysis on frequency of dots
% and dashes in english morse code or a bit of higher order statistics
% could improve this.

u = mean(pw);
seqn = [];

spacing = abs(fcross(1:end-1) - icross(2:end));
[N, X] = hist(spacing,7);

lm = local_max(N);

% thresholds
t_char = (X(lm(2)) + X(lm(1)))/2;
t_space = (X(lm(3)) + X(lm(2)))/2;

for j=1:length(pw)   
    if pw(j) < u
        seqn = [seqn, 1];
    else
        seqn = [seqn, -1];
    end
    
    if ( j > 1 ) && ( j < length(pw) )
        if (spacing(j) > t_char) && (spacing(j) < t_space)
            seqn = [seqn 0];
        elseif spacing(j) > t_space
            seqn = [seqn 0 0];
        end
    end
    
end

seqn = [seqn 0];

out = struct;
out.seqn = seqn;
out.pw = pw;
out.spacing = spacing;
out.t_char = t_char;
out.t_space = t_space;


for k=1:nout
   varargout{k} = out;
end



end