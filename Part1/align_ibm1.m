function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
%
%  This function implements the training of the IBM-1 word alignment algorithm.
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider.
%       maxIter      : (integer) The maximum number of iterations of the EM
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
%
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz

global CSC401_A2_DEFNS

AM = struct();

% Read in the training data
[eng, fre] = read_hansard(trainDir, numSentences);

% Initialize AM uniformly
AM = initialize(eng, fre);

% Iterate between E and M steps
for iter=1:maxIter,
    AM = em_step(AM, eng, fre);
end

% Save the alignment model
save( fn_AM, 'AM', '-mat');

end





% --------------------------------------------------------------------------------
%
%  Support functions
%
% --------------------------------------------------------------------------------

function [eng, fre] = read_hansard(mydir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
%eng = {};
%fre = {};

% TODO: your code goes here.
DDE = dir( [ mydir, filesep, '*', 'e'] );
DDF = dir( [ mydir, filesep, '*', 'f'] );
ind = 1;
for i = 1:length(DDE)
    Elines = textread([mydir, filesep, DDE(i).name], '%s', 'delimiter','\n');
    Flines = textread([mydir, filesep, DDF(i).name], '%s', 'delimiter','\n');
    
    for l=1:length(Elines)
        preprocessedLine = preprocess(Elines{l}, 'e');
        eng{ind} = strsplit(' ', preprocessedLine);
        preprocessedLine = preprocess(Flines{l}, 'f');
        fre{ind} = strsplit(' ', preprocessedLine);
        ind = ind + 1;
        if(ind > numSentences)
            break;
        end
    end
    if(ind > numSentences)
        break
    end
end
end


function AM = initialize(eng, fre)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
AM = {}; % AM.(english_word).(foreign_word)

% TODO: your code goes here
for i=1:length(eng)           %| These two layers of for loop
    for j=1:length(eng{i})    %| loops through each english word
        ew = eng{i}{j};       %| ew for English Word
        if(strcmp(ew, 'SENTSTART') || strcmp(ew, 'SENTEND'))
            continue;
        end
        if(isfield(AM, ew) == 0)
            AM.(ew) = {};
        end
        for k=1:length(fre{i})
            fw = fre{i}{k};
            if(strcmp(fw, 'SENTSTART') || strcmp(fw, 'SENTEND'))
                continue;
            end
            AM.(ew).(fw) = 1;
            
        end
    end
end
fields = fieldnames(AM);
for i=1:length(fields)
    freFields = fieldnames(AM.(fields{i}));
    len = length(freFields);
    for j=1:len
        AM.(fields{i}).(freFields{j}) = AM.(fields{i}).(freFields{j}) / len;
    end
    
end

AM.SENTSTART.SENTSTART = 1;
AM.SENTEND.SENTEND = 1;
end









function t = em_step(t, eng, fre)
%
% One step in the EM algorithm.
%
% TODO: your code goes here
tcount = {};
total = {};

for i=1:length(eng)
    E = eng{i};
    F = fre{i};
    E_set = unique(E, 'stable');
    F_set = unique(F, 'stable');
    
    for l=1:length(F_set) % unique french words
        denom_c = 0;
        f = F_set{l};
        fcount = sum(strcmp(F,f));
        if(strcmp(f, 'SENTSTART') || strcmp(f, 'SENTEND'))
            continue;
        end        
        for j=1:length(E_set)
            e = E_set{j};
            
            if(strcmp(e, 'SENTSTART') || strcmp(e, 'SENTEND'))
                continue;
            end
            
            denom_c = denom_c + t.(e).(f) * fcount;
        end
        
        for k=1:length(E_set)
            e = E_set{k};
            ecount = sum(strcmp(E,e));
            if(strcmp(e, 'SENTSTART') || strcmp(e, 'SENTEND'))
                continue;
            end            
            
            if(isfield(tcount, f) == 0)
                tcount.(f).(e) = t.(e).(f) * fcount * ecount / denom_c;
            elseif(isfield(tcount.(f), e) == 0)
                tcount.(f).(e) = t.(e).(f) * fcount * ecount / denom_c;
            else
                tcount.(f).(e) = tcount.(f).(e) + t.(e).(f) * fcount * ecount / denom_c;
            end
            
            if(isfield(total, e) == 0)
                total.(e) = t.(e).(f) * fcount * ecount / denom_c;
            else
                total.(e) = total.(e) + t.(e).(f) * fcount * ecount / denom_c;
            end
        end
        
        
    end   
end


total_fields = fieldnames(total);
for k=1:length(total_fields)
    tcount_fields = fieldnames(tcount);
    e = total_fields{k};
    
    if(strcmp(e, 'SENTSTART') || strcmp(e, 'SENTEND'))
        continue;
    end
    
    for j=1:length(tcount_fields)
        f = tcount_fields{j};
        if(strcmp(f, 'SENTSTART') || strcmp(f, 'SENTEND'))
            continue;
        end
        if(isfield(tcount.(f),e) == 0)
            t1 = 0;
        else
            t1 = tcount.(f).(e);
        end
        t2 = total.(e);
        t.(e).(f) = t1/t2;
    end
end



end


