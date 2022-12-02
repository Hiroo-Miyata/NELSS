close all
clear all

save = true;
load("../data/raw/recordingHiroo221129.mat")
fs = 128;
eeg = table2array(HirooTrial4_extractedFeature);
emotion = HirooTrial4_extractedActual;
Electrodes = HirooTrial4_extractedFeature.Properties.VariableNames;
metadata = table2array(trial4HirooSongLabelEmotionLevel);


w0 = 60/(fs/2);
bw = w0/35;
[b,a] = iirnotch(w0, bw);

filteredeeg = filter(b,a,eeg);
filteredeeg = bandpass(filteredeeg,[4 45],fs);


tw = 10;
ntrial = size(metadata, 1);

labels = zeros(fs*tw, ntrial);
eegData = zeros(fs*tw, 29, ntrial);
for i=(1:ntrial)
    eegData(:, :, i) = filteredeeg(1+(i-1)*fs*tw:i*fs*tw, :);
    labels(:, i) = emotion(1+(i-1)*fs*tw:i*fs*tw);
end
meanlabels = round(mean(labels, 1)).';

twsize = 224;
featureData = zeros(ntrial, 29, twsize, twsize);
for tr=1:ntrial
    disp(tr)
    for ch=1:29
        [d,f,t] = wvd(eegData(:, ch,tr),fs, 'smoothedPseudo', NumFrequencyPoints=twsize,NumTimePoints=twsize*2);
        featureData(tr, ch, :, :) = d(:,1:2:end);
    end
end

frontElectrode = [2,3,28];
preprocessedData = featureData(:, frontElectrode, :, :);