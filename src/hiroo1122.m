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

eachlabels = zeros(fs*tw*5, ntrial);
eegData = zeros(fs*tw*5, 29, ntrial);
for i=(1:10)
    eegData(:, :, i) = bandpass(eeg(1+(i-1)*fs*tw*5:i*fs*tw*5, :),[4 45],fs);
    eachlabels(:, i) = emotion(1+(i-1)*fs*tw*5:i*fs*tw*5);
end
% for i=23:24
%     eegData(:, :, i) = filteredeeg(1+(i-1)*fs*tw+10*fs:i*fs*tw+10*fs , :);
%     for c=1:6
%         labels(:, c, i) = emotion(1+(i-1)*fs*tw+10*fs+(c-1)*fs*10:(i-1)*fs*tw+10*fs+c*fs*10);
%     end
% end

%% feature extraction and data augmentation
twsize = 10*fs;
stride = 2*fs;
imgsize = 224;
nepoch = (size(eegData, 1) - twsize) / stride + 1;
featureData = zeros(ntrial, nepoch, 3, imgsize, imgsize);
labels = zeros(ntrial, nepoch);
frontElectrode = [2,3,28];
for tr=1:ntrial
    disp(tr)
        %% data augmentation
    for i=1:nepoch
        eachEEG = eegData((i-1)*stride+1:(i-1)*stride+twsize, :,tr);
        for c=1:3
            ch = frontElectrode(c);
            [d,f,t] = wvd(eachEEG(:, ch),fs, 'smoothedPseudo', NumFrequencyPoints=imgsize,NumTimePoints=imgsize*2);
            featureData(tr, i, c, :, :) = d(:, 1:2:end);
            labels(tr, i) = round(mean(eachlabels((i-1)*stride+1:(i-1)*stride+twsize, tr)));
        end
    end
end
data = featureData;
save("../data/preprocessed/50sResNet2.mat", "data", "labels")








