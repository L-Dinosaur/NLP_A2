%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 
disp('Setting Parameters...')
% some of your definitions
% general
trainDir     = '/u/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing';

% task 2
fn_LME       = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/LM_e.mat';
fn_LMF       = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/LM_f.mat';

% task 3
lm_type      = 'smooth';
delta        = 0.1;
vocabSize    = 30122; 

% task 4
numSentences = 1000;
maxIter = 5;
fn_AMEF_1k = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/AMEF_1k.mat';
fn_AMEF_10k = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/AMEF_10k.mat';
fn_AMEF_15k = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/AMEF_15k.mat';
fn_AMEF_30k = '/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/AMEF_30k.mat';


disp('Parameters set');

disp('Loading language model');
% Train your language models. This is task 2 which makes use of task 1
load('/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/LM_e.mat', 'LME');
load('/h/u15/c7/00/liuhao17/Desktop/401/A2_SMT/Models/LM_f.mat', 'LMF');

disp('Language model loaded');
disp('Training alignment model');

% Train your alignment model of French, given English 
AMFE_1k = align_ibm1( trainDir, 1000 , maxIter, fn_AMEF_1k );
disp('1k model trained');
AMFE_10k = align_ibm1( trainDir, 10000 , maxIter, fn_AMEF_10k );
disp('10k model trained');
AMFE_15k = align_ibm1( trainDir, 15000 , maxIter, fn_AMEF_15k );
disp('15k model trained');
AMFE_30k = align_ibm1( trainDir, 30000 , maxIter, fn_AMEF_30k );
disp('30k model trained');

% ... TODO: more 
disp('Alignment model all trained');
% TODO: a bit more work to grab the English and French sentences. 
%       You can probably reuse your previous code for this  
disp('Grabbing French sentences');
french_lines = textread('/u/cs401/A2_SMT/data/Hansard/Testing/Task5.f', '%s', 'delimiter', '\n');
disp('French senteces grabbed');
% Decode the test sentence 'fre'
disp('Translating sentences');
translation_1k = {};
translation_10k = {};
translation_15k = {};
translation_30k = {};


i = 1:1:25;
translation_1k{i} = decode2( french_lines{i}, LME, AMFE_1k, lm_type, delta, vocabSize);
translation_10k{i} = decode2( french_lines{i}, LME, AMFE_10k, lm_type, delta, vocabSize);
translation_15k{i} = decode2( french_lines{i}, LME, AMFE_15k, lm_type, delta, vocabSize);
translation_30k{i} = decode2( french_lines{i}, LME, AMFE_30k, lm_type, delta, vocabSize);
disp('Done translation, check results!');

% looping for the 4 Alignment models

% TODO: perform some analysis
% add BlueMix code here 



[status, result] = unix('');