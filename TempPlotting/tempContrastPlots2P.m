% Function to try to plot Contrast for 2p
% SDL 27/03/2026 adapted from tempPlotting options SGS

% Need to average across acquisitions



% Some defaults
thisColor = ['r' 'b'];
sampleLims = [-5 20];

speedThreshold = 1; % speed below this value - 'stationary', above - 'running'
speedWindow = [-5 5]; % time window for calculating speed
tempOffset = 0; %-1.5;  % For cases in which upPhase wrongly assigned

% First get data out and into a matrix
sampleInds2P = fix(sampleLims*twoPDat.SampleRate);
sampleInds2P = sampleInds2P(1):sampleInds2P(2);
if tempOffset ~= 0
    tcol = repmat(sampleInds2P,length(twoPDat.upPhases),1);
    trow = repmat(twoPDat.upPhases(:)+fix(tempOffset*twoPDat.SampleRate),1,size(tcol,2));
else
    tcol = repmat(sampleInds2P,length(twoPDat.upPhases),1);
    trow = repmat(twoPDat.upPhases(:),1,size(tcol,2));
end

tIndices = trow+tcol;
tIndices(tIndices>size(twoPDat.ROImatrix,2)) = length(size(twoPDat.ROImatrix,2));

% Now find contrast of each stimulus
contrasts = stimInfo.StimValue;
uContrasts = unique(contrasts);
stim_present = find(contrasts ~= 0);
nostim = find(contrasts == 0);

Contrast100 = find(contrasts==1);
timeVector2P = sampleInds2P/twoPDat.SampleRate;

% Create temporal indices
zeropoint = nearestpoint(0,timeVector2P);
startSpeed = nearestpoint(speedWindow(1),timeVector2P);
endSpeed = nearestpoint(speedWindow(2),timeVector2P);

% % average across all ROIs
% allPixels = sum(twoPDat.ROIsize);
% avgROI = sum(twoPDat.ROImatrix,1)./allPixels;

avgROI = nanmean(twoPDat.ROImatrix,1);

% Average ROI response at indices
avgTraces = avgROI(tIndices);

% Wheel
traces_wheel = WheelDat.newSpeed(tIndices);
% Eye
traces_pupil = EyeDat.Area(tIndices);


%%%%%%
% Plot the overall data as a function of time into session
figure('Name',sprintf('Data as a function of time in session :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])

tdat = avgTraces;
subplot(6,1,1)
normalizer = repmat(nanmean(tdat(:,1:zeropoint-1),2),1,size(tdat,2));
ttdat = tdat-normalizer;
imagesc(timeVector2P,1:size(ttdat(stim_present,:),1),ttdat(stim_present,:),[-0.1 0.1])
set(gca,'TickDir','out','Box','off')

% Plot mean over all stimuli (non zero contrast)
subplot(6,1,2)
plot(timeVector2P,nanmean(ttdat(stim_present,:),1));
set(gca,'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
ylabel('dF/F')

%%%%
% Wheel
tdat = traces_wheel;
subplot(6,1,3)
% Subtract speed from preceding
normalizer = repmat(nanmean(tdat(:,1:zeropoint-1),2),1,size(tdat,2));
ttdat = tdat-normalizer;
imagesc(timeVector2P,1:size(ttdat,1),ttdat)
set(gca,'TickDir','out','Box','off')
title('Wheel')
% Plot mean over all stimuli (non zero contrast)
subplot(6,1,4)
plot(timeVector2P,nanmean(ttdat(stim_present,:),1)); hold on
% plot(timeVector2P,nanmean(abs(ttdat(stim_present,:)),1));
set(gca,'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
ylabel('Speed - baseline')

% Eye
tdat = traces_pupil;
subplot(6,1,5)
% Subtract speed from preceding
% normalizer = repmat(nanmean(tdat(:,1:zeropoint-1),2),1,size(tdat,2));
% ttdat = tdat-normalizer;
ttdat = tdat;
imagesc(timeVector2P,1:size(ttdat(stim_present,:),1),ttdat(stim_present,:))
set(gca,'TickDir','out','Box','off')
title('Pupil')
% Plot mean over all stimuli (non zero contrast)
subplot(6,1,6)
plot(timeVector2P,nanmean(ttdat(stim_present,:),1));
set(gca,'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
ylabel('Pupil - baseline')

%%%%%%
% Plot responses as a function of contrast
figure('Name',sprintf('Contrast Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...
tdat = avgTraces;
for thisContrast =  1:length(uContrasts)
    subplot(2,1,thisContrast)
    % Get this data
    ttdat = tdat(contrasts == uContrasts(thisContrast),:);
    % Subtract activity from preceding
    denominator = repmat(mean(ttdat(:,1:zeropoint-1),2),1,size(ttdat,2));
    % Get df / F
    ttdat = (ttdat-denominator)./denominator;
%     ttdat = ttdat-denominator;
    tresp_mean = mean(ttdat,1);
    tresp_median = median(ttdat,1);
    plot(timeVector2P,ttdat,[thisColor(2),'-']); hold on % Individual trials
    % plot(timeVectorPM,tresp_median,[thisColor(2),'-']); hold on
    plot(timeVector2P,tresp_mean,[thisColor(1),'-']);
   % set(gca,'YLim',[-400 1000],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
    title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
end


%%%%%%
% Plot responses as a function of contrast and running speed
figure('Name',sprintf('Speed dependent contrast Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...only for channel 1
tdat = avgTraces;
thisColor = 'bc';
for thisContrast =  1:length(uContrasts)
    % Get this data
    ttdat = tdat(contrasts == uContrasts(thisContrast),:);
    % Subtract activity from preceding
    denominator = repmat(mean(ttdat(:,1:zeropoint-1),2),1,size(ttdat,2));
    % Get df / F
      ttdat = (ttdat-denominator)./denominator;
%     ttdat = ttdat-denominator;

    % Get speeds
    tWhDat = traces_wheel(contrasts == uContrasts(thisContrast),:);
    % %     normalizer = repmat(nanmean(tWhDat(:,1:zeropointEyeWh-1),2),1,size(tWhDat,2));
    % %     tWhDat = tWhDat-normalizer;
    tSpeeds = nanmean(tWhDat(:,startSpeed:endSpeed-1),2) ;

    % Stationary
    stat_Trials = find(tSpeeds < speedThreshold);
    ttdatS = ttdat(stat_Trials,:);
    % Running
    running_Trials = find(tSpeeds >= speedThreshold);
    ttdatR = ttdat(running_Trials,:);

    % Plot Stat
    if ~isempty(ttdatS)
        subplot(length(uContrasts),2,(thisContrast-1)*2+1)
        tresp_meanS(thisContrast,:) = mean(ttdatS,1);
        tresp_medianS(thisContrast,:) = median(ttdatS,1);
        tresp_semS(thisContrast,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVectorPM,tresp_medianS(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tresp_meanS(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Stationary (< %3.1f cm/s): Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uContrasts),2,(thisContrast-1)*2+2)
        tresp_meanR(thisContrast,:) = mean(ttdatR,1);
        tresp_medianR(thisContrast,:) = median(ttdatR,1);
        tresp_semR(thisContrast,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVectorPM,tresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tresp_meanR(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Running (>= %3.1f cm/s: Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end
end


%%%%%%
% Plot wheel data as a function of contrast and running speed
figure('Name',sprintf('Speed dependent contrast Wheel Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...only for channel 1
thisColor = 'bc';

tWhresp_meanS = [];
tWhresp_medianS = [];
tWhresp_meanR = [];
tWhresp_medianR = [];
tWhresp_semS = [];
tWhresp_semR = [];
for thisContrast =  1:length(uContrasts)

    % Get speeds
    tWhDat = traces_wheel(contrasts == uContrasts(thisContrast),:);
    % %     normalizer = repmat(nanmean(tWhDat(:,1:zeropointEyeWh-1),2),1,size(tWhDat,2));
    % %     tWhDat = tWhDat-normalizer;
    tSpeeds = nanmean(tWhDat(:,startSpeed:endSpeed-1),2) ;

    % Stationary
    stat_Trials = find(tSpeeds < speedThreshold);
    ttdatS = tWhDat(stat_Trials,:);
    % Running
    running_Trials = find(tSpeeds >= speedThreshold);
    ttdatR = tWhDat(running_Trials,:);

    % Plot Stat
    if ~isempty(ttdatS)
        subplot(length(uContrasts),2,(thisContrast-1)*2+1)
        tWhresp_meanS(thisContrast,:) = mean(ttdatS,1);
        tWhresp_medianS(thisContrast,:) = median(ttdatS,1);
        tWhresp_semS(thisContrast,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tWhresp_medianS(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tWhresp_meanS(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Stationary (< %3.1f cm/s): Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uContrasts),2,(thisContrast-1)*2+2)
        tWhresp_meanR(thisContrast,:) = mean(ttdatR,1);
        tWhresp_medianR(thisContrast,:) = median(ttdatR,1);
        tWhresp_semR(thisContrast,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tWhresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tWhresp_meanR(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[-10 40],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Running (>= %3.1f cm/s: Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end
end

%%%%%
% Plot eye data as a function of contrast and running speed
figure('Name',sprintf('Speed dependent contrast Eye Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...only for channel 1
thisColor = 'bc';

tEyeresp_meanS = [];
tEyeresp_medianS = [];
tEyeresp_meanR = [];
tEyeresp_medianR = [];
tEyeresp_semS = [];
tEyeresp_semR = [];
for thisContrast =  1:length(uContrasts)

    % Get Eye data
    tEyeDat = traces_pupil(contrasts == uContrasts(thisContrast),:);
    % Get speeds
    tWhDat = traces_wheel(contrasts == uContrasts(thisContrast),:);
    % %     normalizer = repmat(nanmean(tWhDat(:,1:zeropointEyeWh-1),2),1,size(tWhDat,2));
    % %     tWhDat = tWhDat-normalizer;
    tSpeeds = nanmean(tWhDat(:,startSpeed:endSpeed-1),2) ;

    % Stationary
    stat_Trials = find(tSpeeds < speedThreshold);
    ttdatS = tEyeDat(stat_Trials,:);
    % Running
    running_Trials = find(tSpeeds >= speedThreshold);
    ttdatR = tEyeDat(running_Trials,:);

    % Plot Stat
    if ~isempty(ttdatS)
        subplot(length(uContrasts),2,(thisContrast-1)*2+1)
        tEyeresp_meanS(thisContrast,:) = mean(ttdatS,1);
        tEyeresp_medianS(thisContrast,:) = median(ttdatS,1);
        tEyeresp_semS(thisContrast,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tEyeresp_medianS(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tEyeresp_meanS(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[0 2000],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Stationary (< %3.1f cm/s): Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uContrasts),2,(thisContrast-1)*2+2)
        tEyeresp_meanR(thisContrast,:) = mean(ttdatR,1);
        tEyeresp_medianR(thisContrast,:) = median(ttdatR,1);
        tEyeresp_semR(thisContrast,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tEyeresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tEyeresp_meanR(thisContrast,:),[thisColor(1),'-']);
        set(gca,'YLim',[0 2000],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisContrast == 1
            title(sprintf('Running (>= %3.1f cm/s: Contrast %3.2f',speedThreshold,uContrasts(thisContrast)))
        else
            title(sprintf('Contrast %3.2f',uContrasts(thisContrast)))
        end
    end
end
%to save variables for plotting together different animals, need to change
%the variable name (i.e., M240##) (SDL 22/06/24)
%
% save("tresp_meanS_M24012.mat","tresp_meanS")
% save("tresp_semR_M24012.mat","tresp_semR")
% save("tresp_semS_M24012.mat","tresp_semS")
