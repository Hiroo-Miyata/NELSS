averagedFD = zeros(227, 227, 29, 5);

for e=1:5
    averagedFD(:,:,:,e) = mean(featureData(:, :, :, meanlabels==e), 4);
end

for c=1:29
    for e=1:5
        figure
        imagesc(averagedFD(:,:,c,e));axis xy; colorbar;
        title(Electrodes(c) + ": emotion: "+ num2str(e));
        saveas(gcf, "../results/hiroo/tfd/"+Electrodes(c)+"-"+num2str(e)+".jpg")
        close all
    end
end