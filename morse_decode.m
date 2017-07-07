function str = morse_decode( seqn )

M = morse_tree;

str=[];
for n = 1:length(seqn)
    if seqn(n) == 1
        M = M{2};
    elseif seqn(n) == -1
        M = M{3};
    elseif seqn(n) == 0
        str = [str,M{1}];
        M = morse_tree;
    end
end



end