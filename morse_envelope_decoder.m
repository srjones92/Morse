function [seqn] = morse_envelope_decoder(envelope,Fs)

[pw, icross, fcross] = pulsewidth(envelope,'Tolerance',20.0);


% . = 1
% - = -1
% EOC & space = 0

u = mean(pw);
seqn = [];
for j=1:length(pw);    
    if pw(j) < u
        seqn = [seqn, 1];
    else
        seqn = [seqn, -1];
    end
    
    if ( j > 1 ) && ( j < length(pw) )
        if abs( fcross(j) - icross(j+1) ) > u;
            seqn = [seqn 0];
        end
    end
    
end

seqn = [seqn 0];





end