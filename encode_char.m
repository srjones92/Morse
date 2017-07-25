function dd = encode_char(ch)
S = {morse_tree};
D = {0}; %{''}
while ~isempty(S)
N = S{1};
dd = D{1};
S = S(2:end);
D = D(2:end);
if ~isempty(N)
if N{1} == ch
    dd = dd(2:end);
    return
else
S = {N{2} N{3} S{:}};
D = {[dd, 1], [dd, -1], D{:}};
end
end
end
dd = 0;
end