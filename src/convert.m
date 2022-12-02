eegData = cat(3, trailData.filtdeeg);
eegData = eegData(:, 1:28, :);
labels = cat(1, trailData.emotions);
save("../data/preprocessed/benny-cnn", "eegData", "labels")