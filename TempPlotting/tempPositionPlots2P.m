% Function to try to plot Contrast for 2p
% SDL 27/03/2026 adapted from tempPlotting options SGS

% Need to average across acquisitions



% Some defaults
thisColor = ['r' 'b'];
sampleLims = [-5 20];

speedThreshold = 1; % speed below this value - 'stationary', above - 'running'
speedWindow = [-5 5]; % time window for calculating speed
tempOffset = 0; 

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
positions = stimInfo.StimValue(ismember(stimInfo.StimType,'LocationX'));
uPositions = unique(positions);
timeVector2P = sampleInds2P/twoPDat.SampleRate;

% Create temporal indices
zeropoint = nearestpoint(0,timeVector2P);
startSpeed = nearestpoint(speedWindow(1),timeVector2P);
endSpeed = nearestpoint(speedWindow(2),timeVector2P);

% % average across all ROIs
allPixels = sum(twoPDat.ROIsize);
avgROI = sum(twoPDat.ROImatrix,1)./allPixels;

figure('Name',sprintf('distribution fValues for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum))
h = histogram(avgROI,'BinWidth',1);
minF = min(avgROI);
maxF = max(avgROI);
rangeF = range(avgROI);

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
imagesc(timeVector2P,1:size(ttdat,1),ttdat,[-0.1 0.1])
set(gca,'TickDir','out','Box','off')

% Plot mean over all stimuli 
subplot(6,1,2)
plot(timeVector2P,nanmean(ttdat,1));
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
% Plot mean over all stimuli
subplot(6,1,4)
plot(timeVector2P,nanmean(ttdat,1)); hold on
% plot(timeVector2P,nanmean(abs(ttdat),1));
set(gca,'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
ylabel('Speed - baseline')

% Eye
tdat = traces_pupil;
subplot(6,1,5)
% Subtract speed from preceding
% normalizer = repmat(nanmean(tdat(:,1:zeropoint-1),2),1,size(tdat,2));
% ttdat = tdat-normalizer;
ttdat = tdat;
imagesc(timeVector2P,1:size(ttdat,1),ttdat)
set(gca,'TickDir','out','Box','off')
title('Pupil')
% Plot mean over all stimuli
subplot(6,1,6)
plot(timeVector2P,nanmean(ttdat,1));
set(gca,'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
ylabel('Pupil - baseline')

%%%%%%
% Plot responses as a function of Position
figure('Name',sprintf('Position Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...
tdat = avgTraces;
for thisPosition =  1:length(uPositions)
    subplot(2,1,thisPosition)
    % Get this data
    ttdat = tdat(positions == uPositions(thisPosition),:);
    % Subtract activity from preceding
    denominator = repmat(mean(ttdat(:,1:zeropoint-1),2),1,size(ttdat,2));
    % Get df / F
    ttdat = (ttdat-denominator)./denominator;
    tresp_mean = mean(ttdat,1);
    tresp_median = median(ttdat,1);
    plot(timeVector2P,ttdat,[thisColor(2),'-']); hold on % Individual trials
    plot(timeVector2P,tresp_mean,[thisColor(1),'-']);
    set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
    title(sprintf('Position %3.2f',uPositions(thisPosition)))
end


%%%%%%
% Plot responses as a function of contrast and running speed
figure('Name',sprintf('Speed dependent contrast Data for %s :: %s (file %01d)', EyeDat.Animal,EyeDat.Session,EyeDat.Filenum), ...
    'Position', [100 100 600 800])
% For each contrast...only for channel 1
tdat = avgTraces;
thisColor = 'bc';
for thisPosition =  1:length(uPositions)
    % Get this data
    ttdat = tdat(positions == uPositions(thisPosition),:);
    % Subtract activity from preceding
    denominator = repmat(mean(ttdat(:,1:zeropoint-1),2),1,size(ttdat,2));
    % Get df / F
      ttdat = (ttdat-denominator)./denominator;


    % Get speeds
    tWhDat = traces_wheel(positions == uPositions(thisPosition),:);
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
        subplot(length(uPositions),2,(thisPosition-1)*2+1)
        tresp_meanS(thisPosition,:) = mean(ttdatS,1);
        tresp_medianS(thisPosition,:) = median(ttdatS,1);
        tresp_semS(thisPosition,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        plot(timeVector2P,tresp_meanS(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Stationary (< %3.1f cm/s): Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Position %3.2f',uPositions(thisPosition)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uPositions),2,(thisPosition-1)*2+2)
        tresp_meanR(thisPosition,:) = mean(ttdatR,1);
        tresp_medianR(thisPosition,:) = median(ttdatR,1);
        tresp_semR(thisPosition,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVectorPM,tresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tresp_meanR(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[-1 2],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Running (>= %3.1f cm/s: Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Contrast %3.2f',uPositions(thisPosition)))
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
for thisPosition =  1:length(uPositions)

    % Get speeds
    tWhDat = traces_wheel(positions == uPositions(thisPosition),:);
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
        subplot(length(uPositions),2,(thisPosition-1)*2+1)
        tWhresp_meanS(thisPosition,:) = mean(ttdatS,1);
        tWhresp_medianS(thisPosition,:) = median(ttdatS,1);
        tWhresp_semS(thisPosition,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tWhresp_medianS(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tWhresp_meanS(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[-10 40],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Stationary (< %3.1f cm/s): Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Position %3.2f',uPositions(thisPosition)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uPositions),2,(thisPosition-1)*2+2)
        tWhresp_meanR(thisPosition,:) = mean(ttdatR,1);
        tWhresp_medianR(thisPosition,:) = median(ttdatR,1);
        tWhresp_semR(thisPosition,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tWhresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tWhresp_meanR(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[-10 40],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Running (>= %3.1f cm/s: Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Position %3.2f',uPositions(thisPosition)))
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
for thisPosition =  1:length(uPositions)

    % Get Eye data
    tEyeDat = traces_pupil(positions == uPositions(thisPosition),:);
    % Get speeds
    tWhDat = traces_wheel(positions == uPositions(thisPosition),:);
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
        subplot(length(uPositions),2,(thisPosition-1)*2+1)
        tEyeresp_meanS(thisPosition,:) = mean(ttdatS,1);
        tEyeresp_medianS(thisPosition,:) = median(ttdatS,1);
        tEyeresp_semS(thisPosition,:) = std(ttdatS,0,1)./sqrt(size(ttdatS,1));
        plot(timeVector2P,ttdatS,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tEyeresp_medianS(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tEyeresp_meanS(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[0 2000],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatS,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Stationary (< %3.1f cm/s): Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Position %3.2f',uPositions(thisPosition)))
        end
    end

    % Plot Run
    if ~isempty(ttdatR)
        subplot(length(uPositions),2,(thisPosition-1)*2+2)
        tEyeresp_meanR(thisPosition,:) = mean(ttdatR,1);
        tEyeresp_medianR(thisPosition,:) = median(ttdatR,1);
        tEyeresp_semR(thisPosition,:) = std(ttdatR,0,1)./sqrt(size(ttdatR,1));
        plot(timeVector2P,ttdatR,[thisColor(2),'-']); hold on % Individual trials
        % plot(timeVector2P,tEyeresp_median(thisContrast,:),[thisColor(2),'-']); hold on
        plot(timeVector2P,tEyeresp_meanR(thisPosition,:),[thisColor(1),'-']);
        set(gca,'YLim',[0 2000],'XLim',[timeVector2P(1) timeVector2P(end)],'TickDir','out','Box','off')
        text(0.05,0.95,sprintf('%01d trials',size(ttdatR,1)),'Units','normalized')
        if thisPosition == 1
            title(sprintf('Running (>= %3.1f cm/s: Position %3.2f',speedThreshold,uPositions(thisPosition)))
        else
            title(sprintf('Position %3.2f',uPositions(thisPosition)))
        end
    end
end

