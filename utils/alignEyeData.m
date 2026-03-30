function [alignedEyeData] = alignEyeData(EyeData,EyeTimestamps,twoPLog)
% SGS SDL 02/2026 
% Function to align the Eyedata collected in 2p rig with the rest of the
% data 
% 
% EyeData = EyeCamLog file 
% EyeTimestamps = EyeCamTimeStamps
% TwoPLog = 2P bonsai file 

intEyeData = struct();
alignedEyeData = struct();

% Remove duplicates of samples in EyeTimeStamps
[tt,tp] = unique(EyeTimestamps.ArduinoTime);
EyeTimestamps = EyeTimestamps(tp,:);

% Interpolate to the EyeTimestamps X all the EyeData
intEyeData.Centroid_X = interp1(EyeData.eyeMsSinceStartOfDay,EyeData.Centroid_X,EyeTimestamps.EyeCamTime,'linear','extrap');
intEyeData.Centroid_Y = interp1(EyeData.eyeMsSinceStartOfDay,EyeData.Centroid_Y,EyeTimestamps.EyeCamTime,'linear','extrap');
intEyeData.Area = interp1(EyeData.eyeMsSinceStartOfDay,EyeData.Area,EyeTimestamps.EyeCamTime,'linear','extrap');
intEyeData.MajorAxisLength = interp1(EyeData.eyeMsSinceStartOfDay,EyeData.MajorAxisLength,EyeTimestamps.EyeCamTime,'linear','extrap');
intEyeData.MinorAxisLength = interp1(EyeData.eyeMsSinceStartOfDay,EyeData.MinorAxisLength,EyeTimestamps.EyeCamTime,'linear','extrap');

% Interpolate to twoPLog.TwoPFrameTime all the EyeTimestamps dependent data

uSyncEye = unique(EyeTimestamps.LastSyncPulseTime);
uSyncTwoP = unique(twoPLog.LastSyncPulseTime);
EyeTimestamps.newArduinoTime = align2PSyncPulses(uSyncEye,uSyncTwoP,EyeTimestamps.ArduinoTime);

alignedEyeData.Centroid_X = interp1(EyeTimestamps.newArduinoTime,intEyeData.Centroid_X,twoPLog.TwoPFrameTime,'linear','extrap')';
alignedEyeData.Centroid_Y = interp1(EyeTimestamps.newArduinoTime,intEyeData.Centroid_Y,twoPLog.TwoPFrameTime,'linear','extrap')';
alignedEyeData.Area = interp1(EyeTimestamps.newArduinoTime,intEyeData.Area,twoPLog.TwoPFrameTime,'linear','extrap')';
alignedEyeData.MajorAxisLength = interp1(EyeTimestamps.newArduinoTime,intEyeData.MajorAxisLength,twoPLog.TwoPFrameTime,'linear','extrap')';
alignedEyeData.MinorAxisLength = interp1(EyeTimestamps.newArduinoTime,intEyeData.MinorAxisLength,twoPLog.TwoPFrameTime,'linear','extrap')'; 
alignedEyeData.TimeBase = twoPLog.TwoPFrameTime;

