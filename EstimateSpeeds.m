%Uses simulations to determine frog speeds.  Arguments:
%alphabetSize - the size of the alphabet,
%word - the word that the lily pads are labelled according to,
%length - the length of the words being applied to the system.
%simCount - the number of simulations to average over (duplicates may
%occur).
%The probability of each letter is assumed to be uniform.
function speeds = EstimateSpeeds(alphabetSize,word,Rlength)
    frogDistances = zeros; %The distance travelled by frog i is stored at index i.
    for i = 1:length(word) %Initialise the lilypads and frogs.
        frogDistances(i) = 0;
        %Lilypad i is stored at index i (starting at 1).
        lilyLabels(i) = word(i); lilyOccupants(i) = i; %Frog i starts at lilypad i.
        %The frog with nastiness i is stored at index i (starting from 1).
        frogAgitated(i) = false; frogPositions(i) = i; %Frog i starts at lilypad i.
    end
    %Now simulate the word.
    R = randi([0,alphabetSize-1],1,Rlength);
    for i = 1:Rlength
        letter = R(i);
        for lilyIndex = 1:length(word) %Agitate all frogs on a lilypad with label matching 'letter'.
            if lilyLabels(lilyIndex) == letter
                frogAgitated(lilyOccupants(lilyIndex)) = 1;
            end
        end
        %Iterate through the array of frogs
        for frogIndex = 1:length(word) %All agitated frogs hop.
            if frogAgitated(frogIndex) == 1
                newLilyIndex = frogPositions(frogIndex);
                while true
                    newLilyIndex = mod(newLilyIndex+1,length(word));
                    if newLilyIndex == 0 %If index is 4, 4(mod 4)=0, which is not desired.
                        newLilyIndex = 4;
                    end
                    frogDistances(frogIndex) = frogDistances(frogIndex) + 1; %Add a unit of distance.
                    if lilyOccupants(newLilyIndex) == -1 %Empty: the frog will hop there.
                        frogAgitated(frogIndex) = 0;
                        frogPositions(frogIndex) = newLilyIndex;
                        lilyOccupants(newLilyIndex) = frogIndex;
                        break;
                    end %The next lilypad is now guaranteed to have an occupant.
                    if lilyOccupants(newLilyIndex) < frogIndex %Nastier frog: cannot jump there
                        continue; %This loop will execute again and the frog will try to go to the lilypad after.
                    else %This frog will jump and displace the frog which was there.
%                         if newLilyIndex == frogPositions(frogIndex) %If hopping all the way round.
%                             break;
%                         end
                        if lilyOccupants(frogPositions(frogIndex)) == frogIndex %If this frog was not displaced.
                            lilyOccupants(frogPositions(frogIndex)) = -1; %Old lilypad is now empty.
                        end
%                         if lilyOccupants(newLilyIndex) <= 0
%                             disp('a');
%                         end
                        frogAgitated(lilyOccupants(newLilyIndex)) = 1; %The frog that was there is now agitated.
                        frogAgitated(frogIndex) = 0; %The frog that hopped is no longer agitated.
                        frogPositions(frogIndex) = newLilyIndex;
                        lilyOccupants(newLilyIndex) = frogIndex;
                        break; %The displaced frog is less nasty, so it will hop later on in the for-loop.
                    end
                end %End of while-loop.
            end %End of agitated if-statement.
        end %End of frogIndex for-loop.
%         %Output lilypads array
%         output = "";
%         for k = 1:length(word)
%             tmp = sprintf("frog %d,",lilypads(k).occupant.nastiness);
%             strcat(output,tmp);
%         end
%         strcat(output,"\n");
%         disp(output)
    end %End of dynamics due to letter.
    %The total distance of each frog has been calculated.
    speeds = zeros;
    for i = 1:length(frogDistances)
        speeds(i) = frogDistances(i)/Rlength;
    end
end
