%The function that constructs the table of L-values to find the length of the
%longest common subsequence.
function lengthOfLongestSubsequence = LongestSubsequence(a,b)
    %       ___ ___ ___
    %  b(n)|___|___|___|
    %  ... |___|___|___|
    %  b(1)|___|___|___|
    %      a(1) ... a(m)
    %  A match contains a 1; a 0 otherwise.
    
    m = length(a);
    n = length(b);
    %Construct grid of matches - uses true and false to save memory
    matchGrid = false(m,n);
    for x = (1:m)
        for y = (1:n)
            if a(x) == b(y)
                matchGrid(x,y) = true;
            end
        end
    end
    %Construct grid of L-values
    LGrid = zeros(m,n,'uint16');
    %Initialise the first row
    for x = (1:m)
        if a(x)==b(1)
            LGrid(x,1) = 1;
            break;
        end
    end
    if x < m
        for k = (x:m)
            LGrid(k,1) = 1;
        end
    end
    %Initialise the first column
    for x = (1:n)
        if b(x)==a(1)
            LGrid(1,x) = 1;
            break; %THIS WAS MISSING!
        end
    end
    if x < n
        for k = (x:n)
            LGrid(1,k) = 1;
        end
    end
    %Construct the rest of the grid row-by-row by recursion
    %NOTE - this could work just by calling L(m,n) and ensuring each square
    %is filled in the function?  However, for large grids the program may
    %crash due to many recursive calls.
    for y = (2:n)
        for x = (2:m)
            LGrid(x,y) = L(x,y,matchGrid,LGrid);
        end
    end
    %disp(LGrid);
    lengthOfLongestSubsequence = LGrid(m,n);
    %
end
    