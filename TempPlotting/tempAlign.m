% suite2P output processed data 

% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_processed2PData_M25126_Contrast_20260216_00003.mat")
% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_PeripheralData_M25126_Contrast_20260216_00003.mat")
% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_BonsaiData_M25126_Contrast_20260216_00003.mat")
% 

% Set info about the recording session 
options.numberPlanes = 2;


% Load 2P Data
twoPDat = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\OPhys\20260212\M25139_GrayScreen_20260212_00001_ROI_meanFluorescence_plane1.csv");
twoPDat.Var1 = [];
twoPDat = table2array(twoPDat);

F0 = prctile(twoPDat,10);
denominator = repmat(F0,height(twoPDat),1);
deltaF = twoPDat-denominator;
deltaFOverF = deltaF./denominator;

% Load 2P FrameTime Bonsai File 
twoPBonsaiTable = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_2P2026-02-12T18_30_52.csv");

% Remove the first row of zeroes
if twoPBonsaiTable.TwoPFrameTime(1) == 0
    twoPBonsaiTable(1,:) = [];
end 

% Split 2P FrameTime Bonsai File according to number of planes (in this
% test, 2 planes)

ntwoPBonsaiTable = table2array(twoPBonsaiTable);

% Create new tables for potential Planes 
twoPFrameTime_P1 = [];
twoPFrameTime_P2 = [];
twoPFrameTime_P3 = [];
twoPFrameTime_P4 = [];

ntwoPBonsaiTable_P1 = ntwoPBonsaiTable(1:2:end,:);
ntwoPBonsaiTable_P1 = ntwoPBonsaiTable(2:2:end,:);

% Make into Structure




% Load Wheel 
WheelDat = readtable();

% Pupil Data 
EyeTimestamps = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25126\EyeTracking\20260216\M25126_Contrast_20260216_00003_EyeCamTimeStamps2026-02-16T11_31_11.csv");
% Remove duplicates of samples in EyeTimeStamps
[tt,tp] = unique(EyeTimestamps.ArduinoTime);
EyeTimestamps = EyeTimestamps(tp,:);

EyeData = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25126\EyeTracking\20260216\M25126_Contrast_20260216_00003_EyeCamLog_2026-02-16T11_31_07.csv");
EyeTimestamps.newArea = interp1(EyeData.Item1_eyeMillisSinceStartOfDay,EyeData.Item2_Area,EyeTimestamps.EyeCamTime,'linear','extrap');

twoPLog = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25126\Bonsai\20260216\M25126_Contrast_20260216_00003_2P2026-02-16T11_31_24.csv");

uSyncEye = unique(EyeTimestamps.LastSyncPulseTime);
uSyncTwoP = unique(twoPLog.LastSyncPulseTime);
EyeTimestamps.newArduinoTime = align2PSyncPulses(uSyncEye,uSyncTwoP,EyeTimestamps.ArduinoTime);
twoPLog.newPupilArea = interp1(EyeTimestamps.newArduinoTime,EyeTimestamps.newArea,twoPLog.TwoPFrameTime,'linear','extrap');

% Wheel


% Plotting all ROIs across session
h1 = subplot(311);
h2 = subplot(312);
h3 = subplot(313);

subplot(h1)
imagesc(TwoPFrameTime,1:size(processedSignals.dFF,1),zscore(processedSignals.dFF,0,2));

subplot(h2)
plot(peripheralData.Photodiode.sampleTimes,peripheralData.Photodiode.Value);

subplot(h3)
yyaxis left 
plot(peripheralData.Wheel.sampleTimes(1:end-1),diff(peripheralData.Wheel.Value),'r'); hold on

yyaxis right 
plot(twoPLog.TwoPFrameTime/1000,twoPLog.newPupilArea,'b-'); 

linkaxes([h1 h2 h3],'x')

% Plotting average across trials for 2 stim conditions 
figure()
%% 

% For processed data
columnIdx = [-8:40];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-TwoPFrameTime));
    stimFrame(thisStim,1) = idx;
end
rightScreenFrameTime = stimFrame(bonsaiData.stimType<0.5);
leftScreenFrameTime = stimFrame(bonsaiData.stimType>0.5);
rightScreenTrials = repmat(rightScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(rightScreenFrameTime),1);
leftScreenTrials = repmat(leftScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(leftScreenFrameTime),1);

tdat = mean(zscore(processedSignals.dFF,0,2),1);
rightScreenData = tdat(rightScreenTrials);
leftScreenData = tdat(leftScreenTrials);

subplot(421)
imagesc(columnIdx,1:size(rightScreenData,1),rightScreenData)
subplot(423)
imagesc(columnIdx,1:size(leftScreenData,1),leftScreenData)
subplot(223)
plot(columnIdx,mean(rightScreenData,1),'b'); hold on 
plot(columnIdx,mean(leftScreenData,1),'r')


% For eye
columnIdx = [-8:100];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-twoPLog.TwoPFrameTime/1000));
    stimFrame(thisStim,1) = idx;
end
rightScreenFrameTime = stimFrame(bonsaiData.stimType<0.5);
leftScreenFrameTime = stimFrame(bonsaiData.stimType>0.5);
rightScreenTrials = repmat(rightScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(rightScreenFrameTime),1);
leftScreenTrials = repmat(leftScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(leftScreenFrameTime),1);

tdat = twoPLog.newPupilArea;
rightScreenData = calculateDeltaF(tdat(rightScreenTrials),columnIdx,[-8 -1],'deltaF');
leftScreenData = calculateDeltaF(tdat(leftScreenTrials),columnIdx,[-8 -1],'deltaF');


subplot(422)
imagesc(columnIdx,1:size(rightScreenData,1),rightScreenData)
subplot(424)
imagesc(columnIdx,1:size(leftScreenData,1),leftScreenData)
subplot(224)
plot(columnIdx,mean(rightScreenData,1),'b'); hold on 
plot(columnIdx,mean(leftScreenData,1),'r')

%% Position stim 
% For processed data
columnIdx = [-8:40];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)-1
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-TwoPFrameTime));
    stimFrame(thisStim,1) = idx;
end
rightScreenFrameTime = stimFrame(bonsaiData.locationX>0);
leftScreenFrameTime = stimFrame(bonsaiData.locationX<0);
rightScreenTrials = repmat(rightScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(rightScreenFrameTime),1);
leftScreenTrials = repmat(leftScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(leftScreenFrameTime),1);

tdat = mean(zscore(processedSignals.dFF,0,2),1);
rightScreenData = tdat(rightScreenTrials);
leftScreenData = tdat(leftScreenTrials);

subplot(421)
imagesc(columnIdx,1:size(rightScreenData,1),rightScreenData)
subplot(423)
imagesc(columnIdx,1:size(leftScreenData,1),leftScreenData)
subplot(223)
plot(columnIdx,mean(rightScreenData,1),'b'); hold on 
plot(columnIdx,mean(leftScreenData,1),'r')

%%
% For eye
columnIdx = [-8:100];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)-1
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-TwoPFrameTime/1000));
    stimFrame(thisStim,1) = idx;
end
rightScreenFrameTime = stimFrame(bonsaiData.locationX>0);
leftScreenFrameTime = stimFrame(bonsaiData.locationX<0);
rightScreenTrials = repmat(rightScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(rightScreenFrameTime),1);
leftScreenTrials = repmat(leftScreenFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(leftScreenFrameTime),1);

tdat = twoPLog.newPupilArea;
rightScreenData = calculateDeltaF(tdat(rightScreenTrials),columnIdx,[-8 -1],'deltaF');
leftScreenData = calculateDeltaF(tdat(leftScreenTrials),columnIdx,[-8 -1],'deltaF');


subplot(422)
imagesc(columnIdx,1:size(rightScreenData,1),rightScreenData)
subplot(424)
imagesc(columnIdx,1:size(leftScreenData,1),leftScreenData)
subplot(224)
plot(columnIdx,mean(rightScreenData,1),'b'); hold on 
plot(columnIdx,mean(leftScreenData,1),'r')


