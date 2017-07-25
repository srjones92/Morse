%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   morse_modulation
%
%   Modulates a given sequence onto a sinusoid
%
%   Inputs:      
%       seqn: N x 1 in {-1, 0, 1} morse sequence of dash, space, dot
%       param: data structure holding physical parameters of the signal
%           fc: Carrier frequencey (Hz)
%           fs: Sampling frequency (Hz)
%           tdash: length of dash (s)
%           tdot: length of dot (s)
%           tsep: length of symbol separation (s)
%           tspace: length of space (s)
%           amp: relative amplitude (unitless)
%       noise: structure for adding noise
%           f: @(n) anonymous function, generator
%           SNR: signal to noise ratio (dB)
%
%   Returns:
%       Ys: Modulated sinusoid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Ys] = morse_modulation( seqn, param, noise )

if nargin < 2
    error('Not enough arguments');    
    return  
elseif nargin < 3
    noise = [];
end

Y_len = param.fs * ( (length(seqn)+2)*param.tsep + length(seqn(seqn == -1))*param.tdash + ...
        length(seqn(seqn == 1))*param.tdot + length(seqn(seqn == 0))*param.tspace);

    
t = linspace( 0, Y_len/param.fs, Y_len);
Ys = sin( 2*pi*param.fc*t );

ind = 1;

for k = 1:length(seqn)
    % always add a separation
    ind = ind + param.tsep*param.fs;
    
    if seqn(k) == -1
        Ys(ind:(ind + param.tdash*param.fs - 1)) = param.amp * Ys(ind:(ind + param.tdash*param.fs - 1));
        ind = ind + param.tdash*param.fs;
    elseif seqn(k) == 1
        Ys(ind:(ind + param.tdot*param.fs -1)) = param.amp * Ys(ind:(ind + param.tdot*param.fs - 1));
        ind = ind + param.tdot*param.fs;        
    elseif seqn(k) == 0
        %Ys(ind:(ind + param.tspace*param.fs -1)) = param.amp * Ys(ind:(ind + param.tspace*param.fs - 1));
        ind = ind + param.tspace*param.fs;                
    else
        error('unknown sequence value');
        return
    end
    
    
    
end


plot(Ys(1:1000))



if ~isempty(noise)
    n = f(size(Ys));
    
    
    
    
end





end