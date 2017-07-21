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
%           tdash: length of dash (S)
%           tdot: length of dot (S)
%           tsep: length of symbol separation (S)
%           tspace: length of space (S)
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
    
    
    return;
    
elseif nargin < 3
    noise = [];
end




if ~isempty(noise)
    
    
    
end





end