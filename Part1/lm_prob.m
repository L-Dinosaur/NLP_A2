function logProb = lm_prob(sentence, LM, type, delta, vocabSize)
%
%  lm_prob
% 
%  This function computes the LOG probability of a sentence, given a 
%  language model and whether or not to apply add-delta smoothing
%
%  INPUTS:
%
%       sentence  : (string) The sentence whose probability we wish
%                            to compute
%       LM        : (variable) the LM structure (not the filename)
%       type      : (string) either '' (default) or 'smooth' for add-delta smoothing
%       delta     : (float) smoothing parameter where 0<delta<=1 
%       vocabSize : (integer) the number of words in the vocabulary
%
% Template (c) 2011 Frank Rudzicz

  logProb = -Inf;

  % some rudimentary parameter checking
  if (nargin < 2)
    disp( 'lm_prob takes at least 2 parameters');
    return;
  elseif nargin == 2
    type = '';
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  end
  if (isempty(type))
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  elseif strcmp(type, 'smooth')
    if (nargin < 5)  
      disp( 'lm_prob: if you specify smoothing, you need all 5 parameters');
      return;
    end
    if (delta <= 0) or (delta > 1.0)
      disp( 'lm_prob: you must specify 0 < delta <= 1.0');
      return;
    end
  else
    disp( 'type must be either '''' or ''smooth''' );
    return;
  end

  words = strsplit(' ', sentence);
  if(isfield(LM.uni, words{1}) == 0)
      countuni = 0;
      countbi = 0;
  else
      countuni = LM.uni.(words{1});
      if(isfield(LM.bi.(words{1}), words{2}) == 0)
          countbi = 0;
      else
          countbi = LM.bi.(words{1}).(words{2});
      end
  end
  
  nume = countbi + delta;
  denom = countuni + delta * vocabSize;
  if(denom == 0)
      Prob = 0;
  else
      Prob = nume/denom;
  end
  logProb = log2(Prob);
  % TODO: the student implements the following
  for i=2:length(words)-1
      if(isfield(LM.uni, words{i}) == 0)
          countuni = 0;
          countbi = 0;
      else
          countuni = LM.uni.(words{i});
          if(isfield(LM.bi.(words{i}), words{i+1}) == 0)
              countbi = 0;
          else
              countbi = LM.bi.(words{i}).(words{i+1});
          end
      end

      nume = countbi + delta;
      denom = countuni + delta * vocabSize;
      if(denom == 0)
          Prob = 0;
      else
          Prob = nume/denom;
      end
      logProb = logProb + log2(Prob);
  end
  
  
  
  
  
  % TODO: once upon a time there was a curmudgeonly orangutan named Jub-Jub.
return