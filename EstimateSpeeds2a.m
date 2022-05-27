%Uses simulations to determine frog speeds.  Arguments:
%alphabetSize - the size of the alphabet,
%word - the word that the lily pads are labelled according to,
%R - the word to be applied to the system.
%The probability of each letter is assumed to be uniform.
function speeds = EstimateSpeeds2a(word,R)
    frogDistances = zeros; %The distance travelled by frog i is stored at index i.
    for i = 1:length(word) %Initialise the lilypads and frogs.
        frogDistances(i) = 0;
        %Lilypad i is stored at index i (starting at 1).
        lilyLabels(i) = word(i); lilyOccupants(i) = i; %Frog i starts at lilypad i.
            %lilyOccupants stores the frog *that has settled* on the
            %lilypad.  -1 indicates that the lilypad is empty.
        %The frog with nastiness i is stored at index i (starting from 1).
        frogAgitated(i) = false; frogPositions(i) = i; %Frog i starts at lilypad i.
            %frogPositions stores the current position of the frog, which may
            %not be 'settled'.
    end
    %Now simulate the word.
    for i = 1:length(R)
        letter = R(i);
        for lilyIndex = 1:length(word) %Agitate all frogs on a lilypad with label matching 'letter'.
            if lilyLabels(lilyIndex) == letter
                frogAgitated(lilyOccupants(lilyIndex)) = 1;
            end
        end %End of agitation loop.
        
        %Iterate through the frogs.
        for frogIndex = 1:length(word)
            if frogAgitated(frogIndex) == 1
                startIndex = frogPositions(frogIndex);
                if lilyOccupants(startIndex) == frogIndex %If the frog was not displaced (it was the settled frog).
                    lilyOccupants(startIndex) = -1; %The frog is not 'settled' here.
                end
                while true
                    newLilyIndex = mod(frogPositions(frogIndex)+1,length(word));
                    frogDistances(frogIndex) = frogDistances(frogIndex) + 1;
                    if newLilyIndex == 0 %If index is 'length(word)', 'newLilyIndex'=0 which is not desired.
                        newLilyIndex = length(word);
                    end
                    frogPositions(frogIndex) = newLilyIndex; %This frog is only 'visiting' for now.
                    if lilyOccupants(newLilyIndex) == -1 %Empty.
                        lilyOccupants(newLilyIndex) = frogIndex; %The 'visiting' frog 'settles'.
                        break;
                    end
                    if lilyOccupants(newLilyIndex) < frogIndex %The frog on this lilypad is nastier.
                        continue; %Try the next lilypad.
                    else %Displaces the frog.
                        frogAgitated(lilyOccupants(newLilyIndex)) = true; %The displaced frog is now agitated.
                        lilyOccupants(newLilyIndex) = frogIndex; %The 'visiting' frog 'settles'.
                        frogAgitated(frogIndex) = false; %The moving frog is no longer agitated.
                        break; %The displaced frog will move later.
                    end
                end %End of while-loop.
            end %End of agitated if-statement.
        end %End of frog loop.
    end %End of word dynamics.
    speeds = frogDistances/length(R);
end