function M = morse_tree

% Level 5
five	= {'5' {} {} };
four	= {'4' {} {} };
three	= {'3' {} {} };
two	= {'2' {} {} };
plus	= {'+' {} {} };
one	= {'1' {} {} };
six	= {'6' {} {} };
equals	= {'=' {} {} };
slash	= {'/' {} {} };
seven	= {'7' {} {} };
eight	= {'8' {} {} };
nine	= {'9' {} {} };
zero	= {'0' {} {} };


% Level 4
h = {'H' five four};
v = {'V' {} three};
f = {'F' {} {}};
udash = {' ' {} two };
l = {'L' {} {}};
rdash = {' ' plus {} };
p = {'P' {} {}};
j = {'J' {} one};
b = {'B' six equals};
x = {'X' slash {}};
c = {'C' {} {}};
y = {'Y' {} {}};
z = {'Z' seven {}};
q = {'Q' {} {}};
odot = {' ' eight {} };
odash = {' ' nine zero };

% Level 3
s = {'S' h v};
u = {'U' f udash};
r = {'R' l rdash};
w = {'W' p j};
d = {'D' b x};
k = {'K' c y};
g = {'G' z q};
o = {'O' odot odash};

% Level 2
i = {'I' s u};
a = {'A' r w};
n = {'N' d k};
m = {'M' g o};

% Level 1
e = {'E' i a};
t = {'T' n m};

% Root Node
M = {' ' e t};

end