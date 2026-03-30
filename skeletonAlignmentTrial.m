% Import Fluorescent traces from ROIs, with information about the plane of origin (nxm: n ROI number, m is total frame number/4, nx1: rows are plane the ROI is in, 4xm: m number of frames in ROI data, 4 planes)



% TimeFrame matrix: ()
% 
% 
% 
% Bonsai 2P file: FrameTime 

% Load ROIs 
a = tiffreadVolume("Z:\ibn-vision\DATA\SUBJECTS\M25135\OPhys\20260219\M25135_Contrast_20260219_00001_00002.tif");
plane1 = a(:,:,1:4:end);
plane2 = a(:,:,2:4:end);
plane3 = a(:,:,3:4:end);
plane4 = a(:,:,4:4:end);


t2 = Tiff("Z:\ibn-vision\DATA\SUBJECTS\M25135\OPhys\20260219\M25135_Contrast_20260219_00001_00002_plane1.tif",'w');
imageLength = size(plane1,1);
imageWidth = size(plane1,2);
imageDepth = size(plane1,3);

setTag(t2,"ImageLength", imageLength);
setTag(t2,"ImageWidth", imageWidth);
setTag(t2,"Photometric", Tiff.Photometric.MinIsBlack);
setTag(t2,"PlanarConfiguration", Tiff.PlanarConfiguration.Chunky);
setTag(t2,"BitsPerSample",16);
setTag(t2,"SamplesPerPixel",imageDepth);
setTag(t2,"SampleFormat",Tiff.SampleFormat.Int);



write(t2,plane1);


% Put planes together 
conT = Tiff("Z:\ibn-vision\DATA\SUBJECTS\M25135\OPhys\20260219\M25135_Contrast_20260219_00001_plane1.tif","a");



imageLength = size(plane1,1);
imageWidth = size(plane1,2);
imageDepth = size(plane1,3);

setTag(conT,"ImageLength", imageLength);
setTag(conT,"ImageWidth", imageWidth);
setTag(conT,"Photometric", Tiff.Photometric.MinIsBlack);
setTag(conT,"PlanarConfiguration", Tiff.PlanarConfiguration.Chunky);
setTag(conT,"BitsPerSample",16);
setTag(conT,"SamplesPerPixel",imageDepth);
setTag(conT,"SampleFormat",Tiff.SampleFormat.Int);



write(conT, t2);

% Load Wheel 
WheelDat = readtable("C:\Users\sara.deleo\OneDrive - University College London\Desktop\test2Palignment\Bonsai\20260212\M25139_GrayScreen_20260212_00001_Wheel2026-02-12T18_32_06.csv");
twoPBonsaiTable_P1.twoPFrameTime(:,2) = interp1(WheelDat.ArduinoTime,WheelDat.Wheel,twoPBonsaiTable_P1.twoPFrameTime);
% split wheel in 4xm matrix

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

%split pupil in 4xm matrix


% Load PD 

PD = readtable("Z:\ibn-vision\DATA\SUBJECTS\M25139\Bonsai\20260220\M25139_Contrast_20260220_00001_Photodiode2026-02-20T13_00_38.csv");

