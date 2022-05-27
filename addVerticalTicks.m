%fileName - including extension.
%speeds - array of speeds.
function addVerticalTicks(fileName,speeds,heights)
    %openfig(fileName);
    hold on
    for i = 1:length(speeds)
        plot([speeds(i),speeds(i)],[0,heights(i)],'Color','#D95319');
    end
end