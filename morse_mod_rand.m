%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   morse_mod_rand
%
%   Modulates a given sequence onto a sinusoid using random draws
%   for signal parameters. Uses anonymous functions with no
%   arguments in the param structure to determine the distributions.
%
%   Inputs:      
%       seqn: N x 1 in {-1, 0, 1} morse sequence of dash, space, dot
%       param: data structure holding physical parameters of the signal
%           fc: Carrier frequencey (Hz)
%           fs: Sampling frequency (Hz)
%           tdash: length of dash (s)
%           tdot: length of dot (s) - anonymous function
%           tsep: length of symbol separation (s) - anonymous function
%           tspace: length of space (s) - anonymous function
%           amp: relative amplitude (unitless)
%       noise: structure for adding noise
%           f: @(n) anonymous function, generator
%           SNR: signal to noise ratio (dB)
%
%   Returns:
%       Ys: Modulated sinusoid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Ys] = morse_mod_rand( seqn, param, noise )

if nargin < 2
    error('Not enough arguments');    
    return  
elseif nargin < 3
    noise = [];
end

% vector of randomized lengths of each individual symbol
t_k = zeros(length(seqn),1);
t_k_sep = t_k;
for k = 1:length(seqn)
    if seqn(k) == -1
        t_k(k) = param.tdash();
    elseif seqn(k) == 1
        t_k(k) = param.tdot();
    elseif seqn(k) == 0
        t_k(k) = param.tspace();
    else
        error('unknown sequence value');
        return
    end
    
    t_k_sep(k) = param.tsep();
end


Y_len = param.fs * sum(t_k) + param.fs * sum(t_k_sep);

%Y_len = param.fs * ( (length(seqn)+2)*param.tsep + length(seqn(seqn == -1))*param.tdash + ...
%        length(seqn(seqn == 1))*param.tdot + length(seqn(seqn == 0))*param.tspace);

    
t = linspace( 0, Y_len/param.fs, Y_len);
Ys = sin( 2*pi*param.fc*t );

ind = 1;

for k = 1:length(seqn)
    % always add a separation
    ind = floor(ind + param.fs*t_k_sep(k));
    
    if seqn(k) == -1
        Ys(ind:(ind + floor(t_k(k)*param.fs) - 1)) = param.amp * Ys(ind:(ind + floor(t_k(k)*param.fs) - 1));
        
    elseif seqn(k) == 1
        Ys(ind:(ind + floor(t_k(k)*param.fs) -1)) = param.amp * Ys(ind:(ind + floor(t_k(k)*param.fs) - 1));
    elseif seqn(k) == 0
        %Ys(ind:(ind + floor(t_k(k)*param.fs) -1)) = param.amp * Ys(ind:(ind + floor(t_k(k)*param.fs) - 1));
    else
        error('unknown sequence value');
        return
    end
    
    ind = floor(ind + t_k(k)*param.fs);
    
    
end


%plot(Ys(1:1000))



if ~isempty(noise)
    n = f(size(Ys));
    
    
    
    
end





end