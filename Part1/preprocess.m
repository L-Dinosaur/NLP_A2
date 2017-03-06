function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  % TODO: your code here
  %    e.g., outSentence = regexprep( outSentence, 'TODO', 'TODO');
  
  
  
   % separating end of sentence marks
   outSentence = regexprep( outSentence, '(\.+ |!+ |?+ |; )(SENTEND)', ' $1 $2');
   
   % separating commas
   outSentence = regexprep( outSentence, ',', ' ,');
   
   % separating colons
   outSentence = regexprep( outSentence, ':', ' :');
   
   % separating parentheses
   outSentence = regexprep( outSentence, '(', ' ( ');
   outSentence = regexprep( outSentence, ')', ' ) ');
   
   % separating mathematical operators
   outSentence = regexprep( outSentence, '(+|-|<|>|=)', ' $1 ');
   
   % separating quotation marks
   outSentence = regexprep( outSentence, '"', ' " ');
   
   
   
  switch language
   case 'e'
    % TODO: your code here
    
   % separating possesive quotes and clitics  
    outSentence = regexprep( outSentence, '''', ' ''');

   
   case 'f'
    % TODO: your code here
    % separating consonant apostrophe form, l' form and qu' forms
    outSentence = regexprep( outSentence, '(j|d|c|m|l|n|qu|s|t)''', '$1'' ');
    outSentence = regexprep( outSentence, '(J|D|C|M|L|N|Qu|S|T)''', '$1'' ');
   
    % separating 'on form and 'il form
    outSentence = regexprep( outSentence, '''(on|il)', ''' $1');
    
    % recover the separated words that were not supposed to be separated
    outSentence = regexprep( outSentence, 'd'' (accord|abord|ailleurs|habitude)', 'd''$1');

  end
  outSentence = regexprep( outSentence, '\s+', ' '); 

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

