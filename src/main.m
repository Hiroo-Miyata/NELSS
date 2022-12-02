close all
clear all

load("../data/raw/benny.mat");

timestamps = table2array(signal(:, 1));
eeg = table2array(signal(:, 5:end));
fs = round(1/(timestamps(2) - timestamps(1)));
save = true;

musics = cell(round(size(sessionInfo, 1)/6), 1);
toneOnsets = zeros(round(size(sessionInfo, 1)/6), 6);
emotions = zeros(round(size(sessionInfo, 1)/6), 6);
for i=(1:size(sessionInfo, 1))
    metadata = sessionInfo(i, :);
    if rem(i,6) == 1
        musics{ceil(i/6)} = metadata.(1);
    end
    toneOnsets(ceil(i/6), rem(i-1, 6)+1) = metadata.(3);
    emotions(ceil(i/6), rem(i-1, 6)+1) = metadata.(2);
end

trailData = struct.empty(0);
for i=(1:size(toneOnsets, 1))
    trailData(i).music = musics{i};
    trailData(i).emotions = emotions(i, :);
    trailData(i).toneOnsets = toneOnsets(i, :);
    trailData(i).eeg = eeg(toneOnsets(i, 1):toneOnsets(i, 6)+10*fs, :);
end


%% raw data plot
% for i=(1:length(trailData))
%     trail = trailData(i);
% 
%     figure
%     plot(trail.eeg); hold on
%     xline([10 20 30 40 50 60]*fs, Color='r', LineWidth=2); hold off
%     emotionTrajectory = sprintf("%d", trail.emotions);
%     title(num2str(trail.music) + " : " + emotionTrajectory);
%     saveas(gcf, "../results/benny/raw/"+num2str(i)+"-"...
%             +num2str(trail.music)+".jpg");
%     close all
% end

%% filteted plot
filteredeeg = bandpass(eeg,[2 50],fs);
for i=(1:size(toneOnsets, 1))
    trailData(i).filtdeeg = filteredeeg(toneOnsets(i, 1):toneOnsets(i, 6)+10*fs, :);
end

% for i=(1:length(trailData))
%     trail = trailData(i);
% 
%     figure
%     plot(trail.filtdeeg); hold on
%     xline([10 20 30 40 50 60]*fs, Color='r', LineWidth=2); hold off
%     emotionTrajectory = sprintf("%d", trail.emotions);
%     title(num2str(trail.music) + " : " + emotionTrajectory);
%     saveas(gcf, "../results/benny/filtered/"+num2str(i)+"-"...
%             +num2str(trail.music)+".jpg");
%         close all
% end

if save==true
    save("../data/preprocessed/benny.mat", "trailData")
end