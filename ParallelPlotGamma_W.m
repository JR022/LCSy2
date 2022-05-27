%Parallel version of PlotGamma
%Takes:
%a word W as an array of integers (the alphabet starts at 0),
%the size of the alphabet,
%the array of frog speeds (must be length(W) many),
%intervalCount - the number of points to compute for each speed interval,
%lenR - the length of the word R used to estimate gamma_W,
%simCount - the number of trials used to estimate gamma_W at a point.
function ParallelPlotGamma_W(W,alphabetSize,speeds,intervalCount,lenR,simCount)
    %Initialise text file
    fileName = strcat("PlotGamma_W--",string(datetime('now','TimeZone','local','Format','d-MMM-y_HH-mm-ss_Z')));
    myFile = fopen(strcat(fileName,".txt"),'w');
    
    if length(speeds) ~= length(W)
        disp("Error!");
        return
    end
    %Axis labels
    xlabel('\rho'); ylabel('\gamma_W(\rho)');
    gammaGraph = zeros; %Array of gamma values.
    xAxis = zeros; %Array of x values (rho).
    xAxis(1)=0; gammaGraph(1)=0; %First point of graph.
    %First part, from 0 to speeds(1)
    step = speeds(1)/intervalCount;
    tic;
    for i = 1:intervalCount
        xAxis(i+1) = i*step;
        gammaGraph(i+1) = ParallelEstimateGamma_W(W,alphabetSize,i*step,lenR,simCount);
    end
    %Other parts of the graph
    for i = 1:(length(W)-1)
        step = (speeds(i+1)-speeds(i))/intervalCount;
        a = speeds(i);
        for j = 1:intervalCount
            xAxis(i*intervalCount+j+1) = a + j*step;
            gammaGraph(i*intervalCount+j+1) = ParallelEstimateGamma_W(W,alphabetSize,a+j*step,lenR,simCount);
            fprintf(myFile,"(%.10f:%.10f),\n",xAxis(i*intervalCount+j+1),gammaGraph(i*intervalCount+j+1));
        end
    end
    %After the final speed for a bit
    a = speeds(length(W));
    step = speeds(length(W))/intervalCount/5;
    for j = 1:intervalCount
        xAxis(length(W)*intervalCount+j+1) = a + j*step;
        gammaGraph(length(W)*intervalCount+j+1) = ParallelEstimateGamma_W(W,alphabetSize,a+j*step,lenR,simCount);
        fprintf(myFile,"(%.10f:%.10f),\n",xAxis(length(W)*intervalCount+j+1),gammaGraph(length(W)*intervalCount+j+1));
    end
    time = toc;
    hold on %Plot onto same axis
    plot(xAxis,gammaGraph);
    ylim([0 gammaGraph(length(W)*intervalCount+j+1)*1.1]);
    %Plot vertical ticks from x-axis to graph and horizontal ticks from
    %graph to y-axis.  The y-values at the speeds are at gammaGraph(k*intervalCount+1)
    %for each k=1:alphabetSize.
    for k = 1:length(W)
        plot([speeds(k),speeds(k),0],[0,gammaGraph(k*intervalCount+1),gammaGraph(k*intervalCount+1)],':','Color','#D95319');
    end
    fprintf(myFile,"Time taken: %f seconds\n", time); %Write time of execution to file.
    savefig(strcat(fileName,".fig"));
    fclose('all');
    hold off %Stop plotting on same axis.
    sprintf("Time: %f seconds.",time);
end
        
        