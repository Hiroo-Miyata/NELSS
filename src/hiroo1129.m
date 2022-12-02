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
% for i=1:2
%     if i == 1
%         data = featureData(1:12,:,:,:);
%         labels = eachlabels(:, 1:12);
%     else
%         data = featureData(13:end,:,:,:);
%         labels = eachlabels(:, 13:end);
%     end
%     save("50sResNet"+num2str(i)+".mat", "data", "labels")
% end
save("../data/preprocessed/50sResNet1.mat", "data", "labels")
% clear all








