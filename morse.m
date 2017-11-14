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

ntrials = 1000;
str = 'LAUREN BROUGHT ANNIE TO GWC TODAY';
seqn = morse_encode(str);


% User A - 'Fast' User
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


%User B - 'Slower' User (Increased Mean and Variance)
scale = 1.5;

pdashB = makedist('Normal'); 
pdashB.mu = pdashA.mu*scale;
pdashB.sigma = pdashA.sigma*scale;
pdashB = truncate(pdashB, scale*0.154, scale*0.1756);


pdotB = makedist('Normal');
pdotB.mu = pdotA.mu*scale;
pdotB.sigma = pdotA.sigma*scale;
pdotB = truncate(pdotB,scale*0.0492,scale*0.0702);

pspaceB = makedist('Normal');
pspaceB.mu = pspaceA.mu*scale;
pspaceB.sigma = pspaceA.sigma*scale;
pspaceB = truncate(pspaceB,scale*0.185,scale*0.2107);
 

psepB = pdotB;

userB = struct;
userB.fs = Fs;
userB.fc = Fs/2.5;
userB.tdash = @() random(pdashB,1,1);
userB.tdot = @() random(pdotB,1,1);
userB.tspace = @() random(pspaceB,1,1);
userB.tsep = @() random(psepB,1,1);
userB.amp = 5;




%Run user A tests
pwA_dot = [];
pwA_dash = [];
pwA_space = [];
pwA_sep = [];

[Ys] = morse_mod_rand( seqn, userA, [] );


[env] = morse_envelope_detection(Ys,Fs,[]);
[seqn_env, outA ] = morse_envelope_decoder(env,Fs);

pwA_dot = [pwA_dot, outA.pw(outA.pw < mean(outA.pw))];
pwA_dash = [pwA_dash, outA.pw(outA.pw > mean(outA.pw))];
%[str_env] = morse_decode(seqn_env)




