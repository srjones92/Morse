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


str = 'MORE TEST STRING'

seqn = morse_encode(str)
Ys = morse_modulation( seqn, param);
env = morse_envelope_detection( Ys, param.fs, 0);
seqn_hat = morse_envelope_decoder(env, param.fs)
str_hat = morse_decode(seqn_hat)