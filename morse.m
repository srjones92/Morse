%% MORSE MASTER SCRIPT
%
% This script is used to set parameters and call the other functions
%
%
%
%
%






%% Decode from Audio File
file = 'websdr_14036.5kHz.wav';

[Y, Fs] = audioread(file);

envelope = morse_envelope_detection(Y,Fs,1);

seqn = morse_envelope_decoder(envelope, Fs);

mesg = morse_decode(seqn);

disp(mesg);