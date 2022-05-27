%A function that calculates gamma_W  (averging over 'simCount' trials against a word R with length 'lenR') of 'startingWord'
%and does the same after appending symbols one at a time until 'endLength' is reached.
%W should be input as an array of integers between 0 and alphabetSize-1.  It
%can also be a character array (i.e. in SINGLE quotes).
%The result is plotted, with the points written to a text file.
function AppendingSymbolsGamma_W(startingWord,alphabetSize,endLength,lenR,simCount)
    xAxis = zeros; gamma = zeros;
    symbolTest = ones(1,length(alphabetSize)); %Used to store flags for the selectable symbols: 1 means selectable.
    if ischar(startingWord)
        tmp = zeros;
        for i = 1:length(startingWord)
            tmp(i) = str2double(startingWord(i));
        end
        startingWord = tmp;
        clearvars tmp;
    end
    timeString = string(datetime('now','TimeZone','local','Format','d-MMM-y_HH-mm-ss_Z'));
    myFile = fopen(strcat("AppendingSymbolsGamma_W--",timeString,".txt"),'w');
    wordString = strcat("'",sprintf("%d",startingWord),"'");
    fprintf(myFile,"AppendingSymbolsGamma_W(%s,%d,%d,%d,%d)\n",wordString,alphabetSize,endLength,lenR,simCount);
    fprintf(myFile,"--------------------------\n");
    tic;
    %Point from the original word
    xAxis(1) = length(startingWord); gamma(1) = ParallelEstimateGamma_W(startingWord,alphabetSize,1,lenR,simCount);
    fprintf(myFile,"(%s:%.10f:%.10f),\n",strcat("'",sprintf("%d",startingWord),"'"),xAxis(1),gamma(1));
    %Other points
    previousWord = startingWord;
    for i = 1:(endLength-length(startingWord))
        symbolTest = ones(1,alphabetSize); %An array of length 'alphabetSize' filled with 1's.
        while true %This loop is terminated manually
            exit = false; %Used to break the while loop if a non-periodic word is found.
            while true %Select an available symbol
                symbol = randi([0 alphabetSize-1],1,1); %Generate a random symbol.
                if symbolTest(symbol+1) == 1
                    break; %See if this produces a periodic word.
                else
                    continue; %Symbol already used, discard.
                end
            end %Available symbol selected.
            currentWord = cat(2,previousWord,symbol); %Append the symbol to W
            symbolTest(symbol+1) = 0; %Change array value to false to stop it being selected again in this trial.
            %Test if 'currentW' is periodic
            for j = 1:floor(length(currentWord)/2)
                if mod(length(currentWord),j) == 0 %If length divides into the length of 'startingWord'.
                    chunk = currentWord(1:j);
                    repeatedChunk = repmat(chunk,1,length(currentWord)/j); %Has the same length as 'currentWord'.
                    if repeatedChunk == currentWord %Word is periodic.
                        exit = false;
                        symbolTest(symbol+1) = 0; %Set to 0 to stop 'symbol' being chosen again.
                        break; %Do not terminate the while loop.  Exit the for loop and allow the while loop to go again.
                    else
                        exit = true; %Allow the while loop to terminate.
                        continue; %The testing may not be finished.
                    end
                end
            end %End of for loop.
            if exit
                break; %The for loop has completed and 'exit' is true, so the word is not periodic.
            end
        end %End of while loop.
        %The word with appended symbols ('currentWord') is not periodic.
        xAxis(i+1) = length(startingWord) + i;
        gamma(i+1) = ParallelEstimateGamma_W(currentWord,alphabetSize,1,lenR,simCount);
        fprintf(myFile,"(%s:%.10f:%.10f),\n",strcat("'",sprintf("%d",currentWord),"'"),xAxis(i+1),gamma(i+1));
        previousWord = currentWord;         
    end
    time = toc
    fprintf(myFile,"Time: %f seconds.",time);
    plot(xAxis,gamma);
    savefig(strcat("AppendingSymbolsGamma_W--",timeString,".fig"));
    fclose('all');
        