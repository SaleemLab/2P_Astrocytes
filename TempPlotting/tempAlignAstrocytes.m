% suite2P output processed data 

% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_processed2PData_M25126_Contrast_20260216_00003.mat")
% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_PeripheralData_M25126_Contrast_20260216_00003.mat")
% load("Z:\ibn-vision\DATA\SUBJECTS\M25126\Analysis\20260216\M25126_20260216_BonsaiData_M25126_Contrast_20260216_00003.mat")
% 

% Set info about the recording session 
options.numberPlanes = 2;
% M25139

% Load 2P Data (plane1)
twoPDat_1 = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\OPhys\20260212\M25139_GrayScreen_20260212_00001_ROI_meanFluorescence_plane1.csv");
twoPDat_1.Var1 = [];
twoPDat_1 = table2array(twoPDat_1);

F0 = prctile(twoPDat_1,10);
denominator = repmat(F0,height(twoPDat_1),1);
deltaF_P1 = twoPDat_1-denominator;
deltaFOverF_P1 = deltaF_P1./denominator;

% Load 2P Data (plane2)
twoPDat_2 = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\OPhys\20260212\M25139_GrayScreen_20260212_00001_ROI_meanFluorescence_plane2.csv");
twoPDat_2.Var1 = [];
twoPDat_2 = table2array(twoPDat_2);

F0 = prctile(twoPDat_2,10);
denominator = repmat(F0,height(twoPDat_2),1);
deltaF_P2 = twoPDat_2-denominator;
deltaFOverF_P2 = twoPDat_2./denominator;

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

ntwoPBonsaiTable_P1 = ntwoPBonsaiTable(1:2:end-1,:);
ntwoPBonsaiTable_P2 = ntwoPBonsaiTable(2:2:end,:);

% Make into Structure
twoPBonsaiTable_P1.twoPFrameTime = ntwoPBonsaiTable_P1(:,1);
twoPBonsaiTable_P1.BonsaiTime = ntwoPBonsaiTable_P1(:,2);
twoPBonsaiTable_P1.RenderFrameCount = ntwoPBonsaiTable_P1(:,3);
twoPBonsaiTable_P1.LastSyncPulseTime = ntwoPBonsaiTable_P1(:,4);
twoPBonsaiTable_P1.ArduinoTime = ntwoPBonsaiTable_P1(:,5);

% Load Wheel 
WheelDat = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_Wheel2026-02-12T18_32_06.csv");
twoPBonsaiTable_P1.twoPFrameTime(:,2) = interp1(WheelDat.ArduinoTime,WheelDat.Wheel,twoPBonsaiTable_P1.twoPFrameTime);


% Load Eye
EyeTimestamps = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\EyeTracking\20260212\M25139_GrayScreen_20260212_00001_EyeCamTimeStamps2026-02-12T18_30_44.csv");

% Remove duplicates of samples in EyeTimeStamps
[tt,tp] = unique(EyeTimestamps.ArduinoTime);
EyeTimestamps = EyeTimestamps(tp,:);

EyeData = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\EyeTracking\20260212\M25139_GrayScreen_20260212_00001_EyeCamLog_2026-02-12T18_28_54.csv");
EyeTimestamps.newArea = interp1(EyeData.Item1_eyeMillisSinceStartOfDay,EyeData.Item2_Area,EyeTimestamps.EyeCamTime,'linear','extrap');

%twoPLog = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_2P2026-02-12T18_30_52.csv");

uSyncEye = unique(EyeTimestamps.LastSyncPulseTime);
uSyncTwoP = unique(twoPBonsaiTable_P1.LastSyncPulseTime);
EyeTimestamps.newArduinoTime = align2PSyncPulses(uSyncEye,uSyncTwoP,EyeTimestamps.ArduinoTime);
twoPBonsaiTable_P1.twoPFrameTime(:,3) = interp1(EyeTimestamps.newArduinoTime,EyeTimestamps.newArea,twoPBonsaiTable_P1.twoPFrameTime(:,1),'linear','extrap');



% Plotting
subplot(411)
plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),deltaF_P1)

subplot(412)
plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),deltaF_P2)

subplot(413)
plot(twoPBonsaiTable_P1.twoPFrameTime(1:end-1,1),diff(twoPBonsaiTable_P1.twoPFrameTime(:,2)))
set(gca,'yLim',[-5 40])

subplot(414)
plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),twoPBonsaiTable_P1.twoPFrameTime(:,3)); 
%% M25134 Contrast
% Load 2P Data (plane1)
twoPDat_1 = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Ophys\20260218\M25134_Contrast_20260218_00001_1to5_plane1_meanFluorescence.csv");
twoPDat_1.Var1 = [];
twoPDat_1 = table2array(twoPDat_1);

F0 = prctile(twoPDat_1,10);
denominator = repmat(F0,height(twoPDat_1),1);
deltaF_P1 = twoPDat_1-denominator;
deltaFOverF_P1 = deltaF_P1./denominator;


% Load 2P FrameTime Bonsai File 
twoPBonsaiTable = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Bonsai\20260128\M25134_GreyScreen_20260128_00002_2P2026-01-28T17_18_09.csv");

% Remove the first row of zeroes
if twoPBonsaiTable.TwoPFrameTime(1) == 0
    twoPBonsaiTable(1,:) = [];
end 

% Split 2P FrameTime Bonsai File according to number of planes (in this
% test, 2 planes)

ntwoPBonsaiTable = table2array(twoPBonsaiTable);

% Make into Structure
twoPBonsaiTable_P1.twoPFrameTime = ntwoPBonsaiTable(:,1);
twoPBonsaiTable_P1.BonsaiTime = ntwoPBonsaiTable(:,2);
twoPBonsaiTable_P1.RenderFrameCount = ntwoPBonsaiTable(:,3);
twoPBonsaiTable_P1.LastSyncPulseTime = ntwoPBonsaiTable(:,4);
twoPBonsaiTable_P1.ArduinoTime = ntwoPBonsaiTable(:,5);

% Load Wheel 
WheelDat = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Bonsai\20260218\M25134_Contrast_20260218_00001_Wheel2026-02-18T13_35_18.csv");
twoPBonsaiTable_P1.twoPFrameTime(:,2) = interp1(WheelDat.ArduinoTime,WheelDat.Wheel,twoPBonsaiTable_P1.twoPFrameTime);


% Load Eye
EyeTimestamps = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\EyeTracking\20260128\M25134_GreyScreen_20260128_00002_EyeCamTimeStamps2026-01-28T17_18_07.csv");

[tt,tp] = unique(EyeTimestamps.ArduinoTime);
% Remove duplicates of samples in EyeTimeStamps
EyeTimestamps = EyeTimestamps(tp,:);

EyeData = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\EyeTracking\20260128\M25134_GreyScreen_20260128_00002_EyeCamLog_2026-01-28T17_18_05.csv");
EyeTimestamps.newArea = interp1(EyeData.Item1_eyeMillisSinceStartOfDay,EyeData.Item2_Area,EyeTimestamps.EyeCamTime,'linear','extrap');

%twoPLog = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_2P2026-02-12T18_30_52.csv");

uSyncEye = unique(EyeTimestamps.LastSyncPulseTime);
uSyncTwoP = unique(twoPBonsaiTable_P1.LastSyncPulseTime);
EyeTimestamps.newArduinoTime = align2PSyncPulses(uSyncEye,uSyncTwoP,EyeTimestamps.ArduinoTime);
twoPBonsaiTable_P1.twoPFrameTime(:,3) = interp1(EyeTimestamps.newArduinoTime,EyeTimestamps.newArea,twoPBonsaiTable_P1.twoPFrameTime(:,1),'linear','extrap');



% Plotting
subplot(411)
plot(twoPBonsaiTable_P1.twoPFrameTime(1:end-2,1),deltaF_P1)

% subplot(412)
% plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),deltaF_P2)

subplot(413)
plot(twoPBonsaiTable_P1.twoPFrameTime(1:end-1,1),diff(twoPBonsaiTable_P1.twoPFrameTime(:,2)))
set(gca,'yLim',[-5 40])

subplot(414)
plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),twoPBonsaiTable_P1.twoPFrameTime(:,3)); 



% Load 2P Data (plane1)
twoPDat_1 = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Ophys\20260128\M25134_GreyScreen_20260128_00002_meanFluorescence.csv");
twoPDat_1.Var1 = [];
twoPDat_1 = table2array(twoPDat_1);

F0 = prctile(twoPDat_1,10);
denominator = repmat(F0,height(twoPDat_1),1);
deltaF_P1 = twoPDat_1-denominator;
deltaFOverF_P1 = deltaF_P1./denominator;


% Load 2P FrameTime Bonsai File 
twoPBonsaiTable = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Bonsai\20260128\M25134_GreyScreen_20260128_00002_2P2026-01-28T17_18_09.csv");

% Remove the first row of zeroes
if twoPBonsaiTable.TwoPFrameTime(1) == 0
    twoPBonsaiTable(1,:) = [];
end 

% Split 2P FrameTime Bonsai File according to number of planes (in this
% test, 2 planes)

ntwoPBonsaiTable = table2array(twoPBonsaiTable);

% Make into Structure
twoPBonsaiTable_P1.twoPFrameTime = ntwoPBonsaiTable(:,1);
twoPBonsaiTable_P1.BonsaiTime = ntwoPBonsaiTable(:,2);
twoPBonsaiTable_P1.RenderFrameCount = ntwoPBonsaiTable(:,3);
twoPBonsaiTable_P1.LastSyncPulseTime = ntwoPBonsaiTable(:,4);
twoPBonsaiTable_P1.ArduinoTime = ntwoPBonsaiTable(:,5);

% Load Wheel 
WheelDat = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\Bonsai\20260128\M25134_GreyScreen_20260128_00002_Wheel2026-01-28T17_18_15.csv");
twoPBonsaiTable_P1.twoPFrameTime(:,2) = interp1(WheelDat.ArduinoTime,WheelDat.Wheel,twoPBonsaiTable_P1.twoPFrameTime);


% Load Eye
EyeTimestamps = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\EyeTracking\20260128\M25134_GreyScreen_20260128_00002_EyeCamTimeStamps2026-01-28T17_18_07.csv");

% Remove duplicates of samples in EyeTimeStamps
[tt,tp] = unique(EyeTimestamps.ArduinoTime);
EyeTimestamps = EyeTimestamps(tp,:);

EyeData = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25134\EyeTracking\20260128\M25134_GreyScreen_20260128_00002_EyeCamLog_2026-01-28T17_18_05.csv");
EyeTimestamps.newArea = interp1(EyeData.Item1_eyeMillisSinceStartOfDay,EyeData.Item2_Area,EyeTimestamps.EyeCamTime,'linear','extrap');

%twoPLog = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_2P2026-02-12T18_30_52.csv");

uSyncEye = unique(EyeTimestamps.LastSyncPulseTime);
uSyncTwoP = unique(twoPBonsaiTable_P1.LastSyncPulseTime);
EyeTimestamps.newArduinoTime = align2PSyncPulses(uSyncEye,uSyncTwoP,EyeTimestamps.ArduinoTime);
twoPBonsaiTable_P1.twoPFrameTime(:,3) = interp1(EyeTimestamps.newArduinoTime,EyeTimestamps.newArea,twoPBonsaiTable_P1.twoPFrameTime(:,1),'linear','extrap');



% Plotting
subplot(411)
plot(twoPBonsaiTable_P1.twoPFrameTime(1:end-2,1),deltaF_P1)

% subplot(412)
% plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),deltaF_P2)

subplot(413)
plot(twoPBonsaiTable_P1.twoPFrameTime(1:end-1,1),diff(twoPBonsaiTable_P1.twoPFrameTime(:,2)))
set(gca,'yLim',[-5 40])

subplot(414)
plot(twoPBonsaiTable_P1.twoPFrameTime(:,1),twoPBonsaiTable_P1.twoPFrameTime(:,3)); 




%%
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


% For processed data
columnIdx = [-8:40];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-TwoPFrameTime));
    stimFrame(thisStim,1) = idx;
end
lowContrastFrameTime = stimFrame(bonsaiData.stimType<0.5);
highContrastFrameTime = stimFrame(bonsaiData.stimType>0.5);
lowContrastTrials = repmat(lowContrastFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(lowContrastFrameTime),1);
highContrastTrials = repmat(highContrastFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(highContrastFrameTime),1);

tdat = mean(zscore(processedSignals.dFF,0,2),1);
lowContrastData = tdat(lowContrastTrials);
highContrastData = tdat(highContrastTrials);

subplot(421)
imagesc(columnIdx,1:size(lowContrastData,1),lowContrastData)
subplot(423)
imagesc(columnIdx,1:size(highContrastData,1),highContrastData)
subplot(223)
plot(columnIdx,mean(lowContrastData,1),'b'); hold on 
plot(columnIdx,mean(highContrastData,1),'r')


% For eye
columnIdx = [-8:100];
stimFrame = [];
for thisStim = 1:size(bonsaiData.onARDTimes)
    [t,idx] = min(abs(bonsaiData.onARDTimes(thisStim,1)-twoPLog.TwoPFrameTime/1000));
    stimFrame(thisStim,1) = idx;
end
lowContrastFrameTime = stimFrame(bonsaiData.stimType<0.5);
highContrastFrameTime = stimFrame(bonsaiData.stimType>0.5);
lowContrastTrials = repmat(lowContrastFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(lowContrastFrameTime),1);
highContrastTrials = repmat(highContrastFrameTime,1,length(columnIdx)) + repmat(columnIdx,length(highContrastFrameTime),1);

tdat = twoPLog.newPupilArea;
lowContrastData = calculateDeltaF(tdat(lowContrastTrials),columnIdx,[-8 -1],'deltaF');
highContrastData = calculateDeltaF(tdat(highContrastTrials),columnIdx,[-8 -1],'deltaF');


subplot(422)
imagesc(columnIdx,1:size(lowContrastData,1),lowContrastData)
subplot(424)
imagesc(columnIdx,1:size(highContrastData,1),highContrastData)
subplot(224)
plot(columnIdx,mean(lowContrastData,1),'b'); hold on 
plot(columnIdx,mean(highContrastData,1),'r')
