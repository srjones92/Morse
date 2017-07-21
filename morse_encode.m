%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   morse_encode
%
%   encodes a character string with the mapping 
%   -1: -
%   0:  SPACE
%   1:  .
%   traverses the morse_tree function to produce a morse sequence
%
%   Inputs:      
%       str: character string
%
%   Returns:
%       seqn: morse sequence
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function seqn = morse_encode( str )
% 1 is dot
% -1 is dash
seqn = [];
for n = 1:length(str)
   ch = encode_char(str(n));
   seqn = [seqn ch 0];
end



end