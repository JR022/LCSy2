%Takes:
%a word W as an array of integers,
%the size of the alphabet,
%the array of frog speeds (must be alphabetSize many),
%intervalCount - the number of points to compute for each speed interval,
%lenR - the length of the word R used to estimate gamma_W,
%simCount - the number of trials used to edtimate gamma_W at a point.
function PlotGamma_W(W,alphabetSize,speeds,intervalCount,lenR,simCount)
    if length(speeds) ~= alphabetSize
        disp("Error!");
        return
    end
    gammaGraph = zeros; %Array of gamma values.
    xAxis = zeros; %Array of x values (rho).
    xAxis(1)=0;
    gammaGraph(1)=0; %First point of graph.
    %First part, from 0 to speeds(1)
    step = speeds(1)/intervalCount;
    for i = 1:intervalCount
        xAxis(i+1) = i*step;
        gammaGraph(i+1) = EstimateGamma_W(W,alphabetSize,i*step,lenR,simCount);
    end
    %Other parts of the graph
    for i = 1:(alphabetSize-1)
        step = (speeds(i+1)-speeds(i))/intervalCount;
        a = speeds(i);
        for j = 1:intervalCount
            xAxis(i*intervalCount+j+1) = a + j*step;
            gammaGraph(i*intervalCount+j+1) = EstimateGamma_W(W,alphabetSize,a+j*step,lenR,simCount);
        end
    end
    %After the final speed for a bit
    a = speeds(alphabetSize);
    step = speeds(alphabetSize)/intervalCount/10;
    for j = 1:intervalCount
        xAxis(alphabetSize*intervalCount+j+1) = a + j*step;
        gammaGraph(alphabetSize*intervalCount+j+1) = EstimateGamma_W(W,alphabetSize,a+j*step,lenR,simCount);
    end
    plot(xAxis,gammaGraph);
    ylim([0 gammaGraph(alphabetSize*intervalCount+j+1)*1.1]);
    %String output so that the values can be stored.
    output = "";
    for i = 1:length(xAxis)
        output = output + sprintf("(%.10f:%.10f),",xAxis(i),gammaGraph(i));
    end
end
        
        