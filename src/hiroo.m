close all
clear all

save = true;
load("../data/raw/hiroo.mat");
fs = 128;
eeg = table2array(HirooTrial2_extractedFeature);
emotion = HirooTrial2_extractedActual;
% metadata = table2array(trial3HirooSongLabelEmotionLevel);


musics = cell(10, 1);
emotions = zeros(10, 5);

w0 = 60/(fs/2);
bw = w0/35;
[b,a] = iirnotch(w0, bw);

tw = 5*10;
ntrial = 10;

filteredeeg = filter(b,a,eeg);
filteredeeg = bandpass(filteredeeg,[12 60],fs);

labels = zeros(fs*tw, ntrial);
eegData = zeros(fs*tw, 29, ntrial);
for i=(1:ntrial)
    eegData(:, :, i) = filteredeeg(1+(i-1)*fs*tw:i*fs*tw, :);
    labels(:, i) = emotion(1+(i-1)*fs*tw:i*fs*tw);
end

save '../data/preprocessed/hiroo-cnn.mat' 'eegData' 'labels'