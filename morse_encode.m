function seqn = morse_encode( str )
% 1 is dot
% -1 is dash
seqn = [];
for n = 1:length(str)
   ch = encode_char(str(n));
   seqn = [seqn ch 0];
end



end