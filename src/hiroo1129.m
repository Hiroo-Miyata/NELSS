close all
clear all

load("../data/raw/recordingHiroo221129.mat")
fs = 128;
eeg = table2array(HirooTrial4_extractedFeature);
emotion = HirooTrial4_extractedActual;
Electrodes = HirooTrial4_extractedFeature.Properties.VariableNames;
metadata = table2array(trial4HirooSongLabelEmotionLevel);


tw = 10;
ntrial = 132/6 + 2;

eachlabels = zeros(fs*tw*5, ntrial);
eegData = zeros(fs*tw*5, 29, ntrial);
for i=(1:(132/6))
    eegData(:, :, i) = bandpass(eeg(1+(i-1)*fs*tw*6+fs*tw:i*fs*tw*6, :),[4 45],fs);
    eachlabels(:, i) = emotion(1+(i-1)*fs*tw*6+fs*tw:i*fs*tw*6);
end
for i=23:24
    eegData(:, :, i) = bandpass(eeg(1+(i-1)*fs*tw*6+2*tw*fs:i*fs*tw*6+tw*fs , :),[4 45],fs);
    eachlabels(:, i) = emotion(1+(i-1)*fs*tw*6+2*fs*tw:i*fs*tw*6+fs*tw);
end

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
for i=1:2
    if i == 1
        data = featureData(1:12,:,:,:);
        labels = eachlabels(:, 1:12);
    else
        data = featureData(13:end,:,:,:);
        labels = eachlabels(:, 13:end);
    end
    save("50sResNet"+num2str(i)+".mat", "data", "labels")
end
clear all








