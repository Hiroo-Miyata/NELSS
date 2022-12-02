close all
clear all

load("../data/raw/hiroo.mat")
fs = 128;
eeg = table2array(HirooTrial2_extractedFeature);
emotion = HirooTrial2_extractedActual;
Electrodes = HirooTrial2_extractedFeature.Properties.VariableNames;
metadata = table2array(trial2HirooSongLabelEmotionLevel);

tw = 10;
ntrial = 10;

labels = zeros(fs*tw*5, ntrial);
eegData = zeros(fs*tw*5, 29, ntrial);
for i=(1:10)
    eegData(:, :, i) = bandpass(eeg(1+(i-1)*fs*tw*5:i*fs*tw*5, :),[4 45],fs);
    labels(:, i) = emotion(1+(i-1)*fs*tw*5:i*fs*tw*5);
end
% for i=23:24
%     eegData(:, :, i) = filteredeeg(1+(i-1)*fs*tw+10*fs:i*fs*tw+10*fs , :);
%     for c=1:6
%         labels(:, c, i) = emotion(1+(i-1)*fs*tw+10*fs+(c-1)*fs*10:(i-1)*fs*tw+10*fs+c*fs*10);
%     end
% end

twsize = 224*4;
featureData = zeros(ntrial, 3, twsize, twsize*5);
frontElectrode = [2,3,28];
for tr=1:ntrial
    disp(tr)
    for c=1:3
        ch = frontElectrode(c);
        [d,f,t] = wvd(eegData(:, ch,tr),fs, 'smoothedPseudo', NumFrequencyPoints=twsize,NumTimePoints=twsize*5);
        featureData(tr, c, :, :) = d;
    end
end
data = featureData;
save("50sResNet3.mat", "data", "labels")








