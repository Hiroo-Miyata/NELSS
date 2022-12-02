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

tw = 10;
ntrial = 5*10;

filteredeeg = filter(b,a,eeg);
filteredeeg = bandpass(filteredeeg,[10 50],fs);


labels = zeros(fs*tw, ntrial);
eegData = zeros(fs*tw, 29, ntrial);
for i=(1:ntrial)
    eegData(:, :, i) = filteredeeg(1+(i-1)*fs*tw:i*fs*tw, :);
    labels(:, i) = emotion(1+(i-1)*fs*tw:i*fs*tw);
end
meanlabels = round(mean(labels, 1));

for c=1:29
    figure
    for emotion=1:5
        eachEEG = eegData(:, c, meanlabels==emotion);
        [psd freq] = pwelch(eachEEG,[], [], 4096, fs);
        meanpsd = mean(psd, 2);
        plot(freq, meanpsd, LineWidth=2);hold on;
    end
    hold off;
    legend(["1", "2", "3", "4", "5"]);
    xlabel("Frequenct (Hz)");
    ylabel("Power Spectgram Density");
    title("Channel "+num2str(c));
    set(gca, 'fontsize', 14, 'fontname', 'arial', 'tickdir', 'out');
    saveas(gcf, "../results/hiroo/preprocessed/"+num2str(c)+".jpg");
    close all
end


% save '../data/preprocessed/hiroo-cnn.mat' 'eegData' 'labels'