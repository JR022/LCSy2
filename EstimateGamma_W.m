%This function takes a word W, the alphabet size, \rho and the length of R, then estimates \gamma_W by finding the
%expected length of the LCS computed with simCount words R.
%W should be input as an array of integers between 1 and alphabetSize.
function gamma_W = EstimateGamma_W(W,alphabetSize,rho,lenR,simCount)
    lenW = length(W);
    len_extendedW = max(floor(rho*lenR),1); %Max needed to prevent words of 0 length.
    if mod(rho*lenR,lenW) == 0 %If lenW divides rho*lenR
        extendedW = repmat(W,1,len_extendedW/lenW);
    else %If lenW does not divide rho*lenR
        Wa = repmat(W,1,floor(len_extendedW/lenW));
        Wb = W(1:mod(len_extendedW,lenW));
        extendedW = cat(2,Wa,Wb);
    end
    %ExtendedW is now a word of length len_extendedW formed by repeating W.
    LCStotal = 0;
    %tic;
    for i = 1:simCount
        R = randi([0 alphabetSize-1],1,lenR); %Generate a random R
        LCStotal = LCStotal + AltLongestSubsequence(extendedW,R);
    end
    %toc;
    gamma_W = LCStotal/simCount/lenR; %Division by lenR is needed to get \gamma_W
end
    