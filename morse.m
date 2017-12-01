%% MORSE MASTER SCRIPT
%
% This script is used to set parameters and call the other functions
%
%
%
%
%






%% Decode from Audio File
file = 'data/websdr_14036.5kHz.wav';

[Y, Fs] = audioread(file);

envelope = morse_envelope_detection(Y,Fs,1);

seqn = morse_envelope_decoder(envelope, Fs);

mesg = morse_decode(seqn);

disp(mesg);





%% Testing encoding a string


str = 'MORSE TEST STRING'

seqn = morse_encode(str)
Ys = morse_modulation( seqn, param);
env = morse_envelope_detection( Ys, param.fs, 0);
seqn_hat = morse_envelope_decoder(env, param.fs)
str_hat = morse_decode(seqn_hat)


%% Testing Randomized Lengths 

% these numbers are based on the data pulled from from the .wav file in the

pdashA = makedist('Normal'); 
pdashA.mu = 0.165;
pdashA.sigma = 0.0519;
pdashA = truncate(pdashA, 0.154, 0.1756);

pdotA = makedist('Normal'); 
pdotA.mu = 0.0526;
pdotA.sigma = 0.0519;
pdotA = truncate(pdotA,0.0492,0.0702);

pspaceA = makedist('Normal');
pspaceA.mu = 1.2*pdashA.mu;
pspaceA.sigma = 0.0519;
pspaceA = truncate(pspaceA,0.185,0.2107);

psepA = pdotA;

userA = struct;
userA.fs = Fs;
userA.fc = Fs/2.5;
userA.tdash = @() random(pdashA,1,1);
userA.tdot = @() random(pdotA,1,1);
userA.tspace = @() random(pspaceA,1,1);
userA.tsep = @() random(psepA,1,1);
userA.amp = 5;


str = 'LAUREN BROUGHT ANNIE TO GWC TODAY';
seqn = morse_encode(str);

[Ys] = morse_mod_rand( seqn, userA, [] );


[env] = morse_envelope_detection(Ys,Fs,[]);
[seqn_env] = morse_envelope_decoder(env,Fs);
[str_env] = morse_decode(seqn_env)






%% Compare Two Users w/ Different Statistics
hold off; 
close all;


ntrials = 500;
str = 'LAUREN BROUGHT ANNIE TO GWC TODAY';
seqn = morse_encode(str);


% Note that for a gamma dist:
% mu = a/b
% sigma^2 = a*b^2
% a = mu^2/sigma^2
% b = sigma^2/mu

% User A - 'Fast' User
pdashA = makedist('Gamma');
pdashA.a = 0.165^2/(0.0519/10)^2;
pdashA.b = (0.0519/10)^2/0.165;

% pdashA = makedist('Normal'); 
% pdashA.mu = 0.165;
% pdashA.sigma = 0.0519/10;
% pdashA = truncate(pdashA, 0.154, 0.1756);

pdotA = makedist('Gamma');
pdotA.a = (0.0526)^2/0.0173^2;
pdotA.b = 0.0173^2/(0.0526);

% pdotA = makedist('Normal'); 
% pdotA.mu = 0.0526;
% pdotA.sigma = 0.0519/10;
% pdotA = truncate(pdotA,0.0492,0.0702);

pspaceA = makedist('Gamma');
pspaceA.a = (1.2*0.165)^2/(0.0519/10)^2;
pspaceA.b = (0.0519/10)^2/(1.2*0.165);

% pspaceA = makedist('Normal');
% pspaceA.mu = 1.2*pdashA.mu;
% pspaceA.sigma = 0.0519;
% pspaceA = truncate(pspaceA,0.185,0.2107);

psepA = pdotA;

userA = struct;
userA.fs = Fs;
userA.fc = Fs/2.5;
userA.tdash = @() random(pdashA,1,1);
userA.tdot = @() random(pdotA,1,1);
userA.tspace = @() random(pspaceA,1,1);
userA.tsep = @() random(psepA,1,1);
userA.amp = 5;


%User B - 'Slower' User (Increased Mean and Variance)
scale = 1.5;


pdashB = makedist('Gamma');
pdashB.a = (scale*pdashA.mean)^2/(scale*pdashA.std)^2;
pdashB.b = (scale*pdashA.std)^2/(scale*pdashA.mean);

% pdashB = makedist('Normal'); 
% pdashB.mu = pdashA.mu*scale;
% pdashB.sigma = pdashA.sigma*scale;
% pdashB = truncate(pdashB, scale*0.154, scale*0.1756);
% 

pdotB = makedist('Gamma');
pdotB.a = (scale*pdotA.mean)^2/(scale*pdotA.std)^2;
pdotB.b = (scale*pdotA.std)^2/(scale*pdotA.mean);

% pdotB = makedist('Normal');
% pdotB.mu = pdotA.mu*scale;
% pdotB.sigma = pdotA.sigma*scale;
% pdotB = truncate(pdotB,scale*0.0492,scale*0.0702);


pspaceB = makedist('Gamma');
pspaceB.a = (scale*pspaceA.mean)^2/(scale*pspaceA.std)^2;
pspaceB.b = (scale*pspaceA.std)^2/(scale*pspaceA.mean);
% pspaceB = makedist('Normal');
% pspaceB.mu = pspaceA.mu*scale;
% pspaceB.sigma = pspaceA.sigma*scale;
% pspaceB = truncate(pspaceB,scale*0.185,scale*0.2107);
 
psepB = pdotB;

userB = struct;
userB.fs = Fs;
userB.fc = Fs/2.5;
userB.tdash = @() random(pdashB,1,1);
userB.tdot = @() random(pdotB,1,1);
userB.tspace = @() random(pspaceB,1,1);
userB.tsep = @() random(psepB,1,1);
userB.amp = 5;





pwA_dot = [];
pwA_dash = [];
pwA_space = [];
pwA_char = [];
pwA_sep = [];

pwB_dot = [];
pwB_dash = [];
pwB_space = [];
pwB_char = [];
pwB_sep = [];

userA.fs = userA.fs/32;
userB.fs = userB.fs/32;
userA.fc = userA.fc/32;
userB.fc = userB.fc/32;

for k = 1:ntrials


%Run user A tests    
[Ys_A] = morse_mod_rand( seqn, userA, [] );
[envA] = morse_envelope_detection(Ys_A,userA.fs,[]);
[seqn_envA, outA ] = morse_envelope_decoder(envA,userA.fs);


strA = morse_decode(seqn_envA)

%strerrorA(k) = norm(str(str~=' ') - strA(strA~=' '));


pwA_dot = [pwA_dot, outA.pw(outA.pw < mean(outA.pw))];
pwA_dash = [pwA_dash, outA.pw(outA.pw > mean(outA.pw))];
pwA_space = [pwA_space, outA.spacing( outA.t_space < outA.spacing ) ]; 
pwA_char = [pwA_char, outA.spacing( (outA.t_char < outA.spacing) & ( outA.spacing < outA.t_space) ) ];
pwA_sep = [pwA_sep, outA.spacing( outA.t_char > outA.spacing ) ];
%[str_env] = morse_decode(seqn_env)



%Run user B tests
[Ys_B] = morse_mod_rand( seqn, userB, [] );
[env] = morse_envelope_detection(Ys_B,userB.fs,[]);
[seqn_env, outB ] = morse_envelope_decoder(env,userB.fs);

strB = morse_decode(seqn_env)

%strerrorB(k) = norm(str(str~=' ') - strB(strB~=' '));

pwB_dot = [pwB_dot, outB.pw(outB.pw < mean(outB.pw))];
pwB_dash = [pwB_dash, outB.pw(outB.pw > mean(outB.pw))];
pwB_space = [pwB_space, outB.spacing( outB.t_space < outB.spacing ) ]; 
pwB_char = [pwB_char, outB.spacing( (outB.t_char < outB.spacing) & ( outB.spacing < outB.t_space) ) ];
pwB_sep = [pwB_sep, outB.spacing( outB.t_char > outB.spacing ) ];

end

% Some basic results
histogram(outA.pw,20,  'FaceColor','r');
hold on;
histogram(outB.pw,20,  'FaceColor','g');


