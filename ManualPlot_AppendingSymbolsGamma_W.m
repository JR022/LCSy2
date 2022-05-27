%A function that parses a text file produced by AppendingSymbolsGamma_W and plots the graph, with any desired
%modificatiions (all options are present in code).
function ManualPlot_AppendingSymbolsGamma_W()
    myFile = fopen('AppendingSymbolsGamma_W--5-Aug-2020_16-46-08_+0100.txt','r');
    xAxis = zeros; yAxis = zeros;
    %{
    data = textscan(myFile);
    
    points = split(data,',');
    for i = 1:length(points)
        point = split(points(i),':');
        xAxis(i) = erase(point(1),'(');
        yAxis(i) = erase(points(2),')');
    end
    %}
    points = fscanf(myFile,'(%f,%f),\n');
    %xAxis is stored at indices 1,3,5,...
    %yAxis is stored at indices 2,4,6,...
    for i = 1:length(points)/2 %The length is always even.
        xAxis(i) = points(2*i-1);
        yAxis(i) = points(2*i);
    end
    plot(xAxis,yAxis);
    fclose(myFile);
end