%A function to generate random words W and then estimate gamma_W for them.
%Each word and gamma_W is output into a text file.
function SimulateWords(lenW,lenR,alphabetSize,simCount,WCount)
    myFile = fopen(strcat("SimulateWords--",string(datetime('now','TimeZone','local','Format','d-MMM-y_HH-mm-ss_Z')),".txt"),'w');
    fprintf(myFile,"SimulateWords(%d,%d,%d,%d,%d)\n",lenW,lenR,alphabetSize,simCount,WCount); %Start file with function call
    W = randi([0,alphabetSize-1],1,lenW);
    tic;
    for i = 1:WCount
        out = "(";
        gamma_W = ParallelEstimateGamma_W(W,alphabetSize,1,lenR,simCount);
        for j = 1:lenW
            out = strcat(out,num2str(W(j)));
        end %'out' contains W as a string.
        out = sprintf("%s:%.10f),",out,gamma_W); %Add a separating colon and gamma_W.
        fprintf(myFile,"%s\n",out);
    end
    executionTime = toc;
    fprintf(myFile,"Execution time: %f seconds.\n",executionTime);
    sprintf("Time: %.5f seconds",executionTime); %Displays time for convenience.
    fclose(myFile);
end