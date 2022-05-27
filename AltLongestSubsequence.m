%The function that constructs the table of L-values to find the length of the
%longest common subsequence - more efficient design which only stores
%two rows of the L-table at once and does not store the match table.
function lengthOfLongestSubsequence = AltLongestSubsequence(a,b)
    %       ___ ___ ___
    %  b(n)|___|___|___|
    %  ... |___|___|___|
    %  b(1)|___|___|___|
    %      a(1) ... a(m)
    %  A match contains a 1; a 0 otherwise.
    
    m = length(a);
    n = length(b);
    %Matches are calculated 'in place' so the whole grid is not stored
    %Initialise the two arrays: previous and current
    previous = zeros;
    current = zeros;
    %Initialise the first row (previous)
    for x = (1:m)
        previous(x)=0; %Has to be set or crashes occur
        if a(x)==b(1)
            previous(x) = 1;
            break; %If L-value is 1, all others after it are also 1
        end
    end
    if x < m
        for k = (x:m)
            previous(k) = 1;
        end
    end
    %Construct the rest of the grid row-by-row by "recursion"
    for y = (2:n)
        %Set current(1)
        if a(1)==b(y)
            omega=1;
        else
            omega=0;
        end
        current(1) = max([previous(1),omega]);
        for x = (2:m)
            if a(x)==b(y)
                omega=1;
            else
                omega=0;
            end
            current(x) = max([previous(x-1)+omega,current(x-1),previous(x)]);
        end
        %Row complete: change current to previous
        previous = current;
        current = zeros;
    end
    %Return the length - note that the last row is now previous
    lengthOfLongestSubsequence = previous(m);
end
    