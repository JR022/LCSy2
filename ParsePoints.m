function ParsePoints()
format long;
    myFile = fopen('SimulateWords--24-Jul-2020_17-09-03_+0100.txt','r');
    data = string(split(fscanf(myFile,'%s'),','));
    gammas = zeros;
    words = strings(500);
    for i = 6:105
        text = char(data(i));
        words(i-5) = text(2:101);
        gammas(i-5) = str2double(text(103:114));
    end
    maximum = max(gammas);
    minimum = min(gammas);
    mean = sum(gammas)/length(gammas);
end