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

pdash = makedist('Normal'); 
pdash.mu = 0.165;
pdash.sigma = 0.0519;
pdash = truncate(pdash, 0.154, 0.1756);

pdot = makedist('Normal'); 
pdot.mu = 0.0526;
pdot.sigma = 0.0519;
pdot = truncate(pdot,0.0492,0.0702);

pspace = makedist('Normal');
pspace.mu = 1.2*pdash.mu;
pspace.sigma = 0.0519;
pspace = truncate(pspace,0.185,0.2107);

psep = pdot;

user = struct;
user.fs = Fs;
user.fc = Fs/2.5;
user.tdash = @() random(pdash,1,1);
user.tdot = @() random(pdot,1,1);
user.tspace = @() random(pspace,1,1);
user.tsep = @() random(psep,1,1);
user.amp = 5;


str = 'LAUREN BROUGHT ANNIE TO GWC TODAY';
seqn = morse_encode(str);

[Ys] = morse_mod_rand( seqn, user, [] );


[env] = morse_envelope_detection(Ys,Fs,[]);
[seqn_env] = morse_envelope_decoder(env,Fs);
[str_env] = morse_decode(seqn_env)



