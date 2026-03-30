%
% Inputs
%       thisAnimal  [= 'M19062']
%       thisSession [= '20190911']
%       thisFileNum [= 0]
%       options -
%           options.BonsaiPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'Extras',upper(thisSession));
%           options.conToppath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'Ephys',upper(thisSession));
%               NB if following fields exist they will be used to directly
%                   access the eye data and OE file
%               options.thisOEfileName - full path to OE file
%               options.thisEYEfileName - fullpath to EYE file
%           options.sync_input = 'ch';
%           options.sync_channel = 20;
%           options.wheel_input = 'ch';
%           options.wheel_channels = [22:23];
%           options.includeWheel = 1;
%           options.UseOneSignal = 0; % 0 or 1
%           options.chanNumbersToInclude = 9;
%           options.EyeSR = 31;
%           options.stim_dur = 0.5; % For PD calculations only
%           options.photo_br = 1;
%           options.NewOESampleRate = 1000;
%
% Dependencies

% History
%   SGS 8th March 2020 Wrote it adapted from SRP_RunCONtoMAT_EPhys
%   SGS 23rd April 2024 Adapted from TG4510:parseRawToCollated
%   SDL 15/02/2026 adapted for 2p data  
%
function [EyeDat,WheelDat,twoPDat,options] = parseRawToCollated2P(thisAnimal,thisSession,thisFileName,thisAcquisition,options)

if ~exist('thisAnimal', 'var')
    thisAnimal = 'M19075';
end
if ~exist('thisSession', 'var')
    thisSession = '20190617';
end
if ~exist('thisFileName', 'var')
    thisFileName = 0;
end
if ~isfield(options,'logErrorsFlag')
    options.logErrorsFlag = 0;
end
% Default options for debugging
if ~exist('options', 'var')
    if ispc
        if exist('X:\ibn-vision','dir')==7
            serverPath = 'X:\ibn-vision\';
        else
            serverPath = 'X:\';
        end
    elseif ismac
        serverPath = '/Users/s.solomon/Filestore/Research2/ibn-vision';
    end
end

% Set up
% twoPDat = [];
twoPLog = [];
EyeDat = [];
WheelDat = [];


%%%%%
% Load twoPLog from Bonsai
if isfield(options, 'this2PLogfileName') && ~isempty(options.this2PLogfileName)
    this2PLogfileName = fullfile(options.BonsaiPath,options.this2PLogfileName);
else
    this2PLogfileName = fullfile(options.BonsaiPath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_2P','*']);
    folder_dir = dir(this2PLogfileName);
    if ~isempty(folder_dir)
        folder_name = folder_dir.name;
        this2PLogfileName = fullfile(options.BonsaiPath,folder_name);
    end
end

if ~isempty(this2PLogfileName) 
    twoPLog = readtable(this2PLogfileName); 
    twoPLog.Properties.VariableNames  = {'TwoPFrameTime','BonsaiTime', 'RenderFrameCount','LastSyncPulseTime', 'ArduinoTime'};
end 

options.TwoPSampleRate = 1/(mean(diff(twoPLog.TwoPFrameTime)))*1000;

%%%%%
% Load PD and find idx of Up and DownPhases
if isfield(options, 'thisPDfileName') && ~isempty(options.thisPDfileName)
    thisPDfileName = fullfile(options.BonsaiPath,options.thisPDfileName);
else
    thisPDfileName = fullfile(options.BonsaiPath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_Photodiode','*']);
    folder_dir = dir(thisPDfileName);
    if ~isempty(folder_dir)
        folder_name = folder_dir.name;
        thisPDfileName = fullfile(options.BonsaiPath,folder_name);
    end
end

if ~isempty(thisPDfileName) 
    tempPD = readtable(thisPDfileName); 
    tempPD.Properties.VariableNames  = {'PDOutput','LastSyncPulse', 'ArduinoTime', 'BonsaiTime','RenderFrameCount'};
end 

% Interpolate to twoPFrameTime 
PD.PDOutput = interp1(tempPD.ArduinoTime, tempPD.PDOutput, twoPLog.TwoPFrameTime);

% Get the photodiode change 
[upPhases, downPhases] = PDUpDownPhases(PD.PDOutput,options);
% May not return to baseline, in which case length(EyedownPhases) = length(EyeupPhases)-1
% if length(EyedownPhases) == length(EyeupPhases)-1
%     upPhases = upPhases(1:end-1);
% end

%%%%%
% Load the EyeTimestamps and EyeData from the bonsai file
thisEyeTimestampsfileName = [];
if isfield(options, 'thisEyeTimestampsfileName') && ~isempty(options.thisEyeTimestampsfileName)
    thisEyeTimestampsfileName = fullfile(options.EyePath,options.thisEyeTimestampsfileName);
else
    thisEyeFile = fullfile(options.EyePath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_EyeCamTimeStamps','*']);
    folder_dir = dir(thisEyeFile);
    if ~isempty(folder_dir)
        folder_name = folder_dir.name;
        thisEyeTimestampsfileName = fullfile(options.EyePath,folder_name);
    end
end

thisEyeDatafileName = [];
if isfield(options, 'thisEyeDatafileName') && ~isempty(options.thisEyeDatafileName)
    thisEyeDatafileName = fullfile(options.EyePath,options.thisEyeDatafileName);
else
    thisEyeFile = fullfile(options.EyePath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_EyeCamLog_','*']);
    folder_dir = dir(thisEyeFile);
    if ~isempty(folder_dir)
        folder_name = folder_dir.name;
        thisEyeDatafileName = fullfile(options.EyePath,folder_name);
    end
end


if ~isempty(thisEyeTimestampsfileName) && ~isempty(thisEyeDatafileName)

    tempEyeDat = readtable(thisEyeDatafileName); 
    tempEyeDat.Properties.VariableNames  = {'eyeMsSinceStartOfDay','Centroid_X', 'Centroid_Y', 'Area', 'MajorAxisLength','MinorAxisLength'};

    EyeTimeStamps = readtable(thisEyeTimestampsfileName); 
    EyeTimeStamps.Properties.VariableNames  = {'EyeCamTime','LastSyncPulseTime', 'ArduinoTime'};

    % Align EyeData
    [EyeDat] = alignEyeData(tempEyeDat,EyeTimeStamps,twoPLog);
    
    % Process eye data
%     [EyeDat, EyeTrackerParams] = EyePreprocess_LFPPM(EyeDat, options.eyeTrackerParams);
   % tTime = (EyeDat.eyeMsSinceStartOfDay-EyeDat.eyeMsSinceStartOfDay(1)); % Convert to s since beginning of recording


    % Store
    EyeDat.SampleRate = options.TwoPSampleRate;
    EyeDat.EyeFileName = [thisEyeTimestampsfileName,thisEyeDatafileName];
%     EyeDat.EyeTrackerParams = EyeTrackerParams;
    EyeDat.upPhases = upPhases;
    EyeDat.downPhases = downPhases;


%     EyeDat.ttl_timestamps = tTime(EyeupPhases)./1000; % convert from ms to s
%     EyeDat.data = EyeDat(:,{'EyeX_deg','EyeY_deg','EyeArea','EyeArea_mm2','valid'});
%     EyeDat.data.timestamps = tTime./1000; % Add time stamps in s
end
%%%
% Load Wheel 

if isfield(options, 'thisWheelfileName') && ~isempty(options.thisWheelfileName)
    thisWheelfileName = fullfile(options.BonsaiPath,options.thisWheelfileName);
else
    thisWheelfileName = fullfile(options.BonsaiPath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_Wheel','*']);
    folder_dir = dir(thisWheelfileName);
    if ~isempty(folder_dir)
        folder_name = folder_dir.name;
        thisWheelfileName = fullfile(options.BonsaiPath,folder_name);
    end
end

if ~isempty(thisWheelfileName) 

    tempWheelDat = readtable(thisWheelfileName); 
    tempWheelDat.Properties.VariableNames  = {'Wheel','LastSyncPulseTime', 'ArduinoTime', 'BonsaiTime', 'RenderFrameCount'};
end 

% Process Wheel (from Edd 13.05.2024)
    % unwrap wheel and convert to cm
    halfMax = max(tempWheelDat.Wheel)/2;
    wheelCircum = pi*options.wheelDiameter;

    WheelDat.data.wheelOutput = tempWheelDat.Wheel;
    WheelDat.data.wheelOutput = options.wheelDirection*unwrap(WheelDat.data.wheelOutput, halfMax);
    WheelDat.data.Distance = (WheelDat.data.wheelOutput/1024) * wheelCircum; % distance in wheel rotation, * the cms of that
    temp_speed = diff(WheelDat.data.Distance)./diff(tempWheelDat.ArduinoTime);
    temp_speed = movmean(temp_speed, 2);
    temp_speed = [temp_speed(1); temp_speed];
    WheelDat.data.Speed = temp_speed*1000; % timestmap were in ms
    
%     WheelDat.SampleRate = 1/(mean(diff(EyeDat.wheelMsSinceStartOfDay))/1000);

    % Interpolate to twoPLog.TimeFrame 
    WheelDat.newSpeed = interp1(tempWheelDat.ArduinoTime,WheelDat.data.Speed,twoPLog.TwoPFrameTime,'linear','extrap');
    WheelDat.newSpeed = WheelDat.newSpeed';
    % Get PD 
    WheelDat.upPhases = upPhases;
    WheelDat.downPhases = downPhases;

%%%%%%%
% Load ROI measurements
% First define the ROI matrix variable 
ROImatrix = [];
ROIstats = [];
ROIsize = [];
ROIid = [];

% Then loop through the planes and horizontally concatenate the ROIs from
% each plane 
for thisPlane = 1:options.nPlanes
    tROIid = [];
    if isfield(options, 'this2PfileName') && ~isempty(options.this2PfileName)
        this2PfileName = fullfile(options.TwoPPath,options.this2PfileName);
    else
        this2PfileName = fullfile(options.TwoPPath, append(thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_plane_',string(thisPlane),'RoiFluorescence.mat'));
        folder_dir = dir(this2PfileName);
        if ~isempty(folder_dir)
            folder_name = folder_dir.name;
            this2PfileName = fullfile(options.TwoPPath,folder_name);
        else
            this2PfileName = [];
        end
    end
    if ~isempty(this2PfileName)
        load(this2PfileName)
        tempROImatrix = cat(2,roiInfo.roiSum{:});
        tempROImatrix = tempROImatrix';

        ROImatrix = horzcat(ROImatrix,tempROImatrix);

        % In parallel, make a matrix with the plane ID for each ROI
        tROIid = repmat(thisPlane,size(tempROImatrix,2),1);
        ROIid = vertcat(ROIid,tROIid);

        % Make a matrix with the ROI info from all planes
        ROIsize = vertcat(ROIsize, roiInfo.roiSize');
        ROIstats = vertcat(ROIstats, roiInfo.roiStats);

    end
end


% Transform into matrix mxn m=cells n=time
ROImatrix = ROImatrix';

%% 
% Split twoPLog TwoPFrametime by plane 
planeFrameTime = zeros(options.nPlanes,floor(size(twoPLog.TwoPFrameTime,1)/4)); 
for thisPlane = 1:options.nPlanes
    planeFrameTime(thisPlane,1:size(twoPLog.TwoPFrameTime(thisPlane:options.nPlanes:end,:))) = twoPLog.TwoPFrameTime(thisPlane:options.nPlanes:end,:);

    % at this point the FrameTime is almost always going to be longer than
    % the ROI matrix because we have trimmed incomplete GRABs - need to
    % crop planeFrameTime accordingly 

    if length(planeFrameTime) > length(ROImatrix)
        planeFrameTime(:,length(ROImatrix)+1:end) = [];
    end 

    % find idx of ROI for the correct plane
    theseIdx = [];
    theseIdx = find(ROIid == thisPlane);

    % Interpolate ROI measurements to full 2pFrameTime
    for i = 1:height(theseIdx)
        newROImatrix(theseIdx(i),:) = interp1(planeFrameTime(thisPlane,:),ROImatrix(theseIdx(i),:),twoPLog.TwoPFrameTime);
    end

end

% Define the new timeVector 
ROItimeVector = twoPLog.TwoPFrameTime';

% Remove NaNs from newROImatrix (that were introduced by the interpolation), which means removing the first and last GRAB
% First remove first GRAB 
newROImatrix(:,1:options.nPlanes) = [];
ROItimeVector(:,1:options.nPlanes) = [];

% remove from all other measurements as well
WheelDat.newSpeed(:,1:options.nPlanes) = [];
EyeDat.Area(:,1:options.nPlanes) = [];
EyeDat.Centroid_X(:,1:options.nPlanes) = [];
EyeDat.Centroid_Y(:,1:options.nPlanes) = [];
EyeDat.MinorAxisLength(:,1:options.nPlanes) = [];
EyeDat.MajorAxisLength(:,1:options.nPlanes) = [];

% Then remove last GRAB + any extra NaNs due to final incomplete GRAB
nanidx = find(isnan(newROImatrix(1,:)));
newROImatrix(:,nanidx) = [];
ROItimeVector(:,nanidx) = [];

% remove from Eye and Wheel as well 
EyeDat.Area(:,nanidx) = [];
EyeDat.Centroid_X(:,nanidx) = [];
EyeDat.Centroid_Y(:,nanidx) = [];
EyeDat.MinorAxisLength(:,nanidx) = [];
EyeDat.MajorAxisLength(:,nanidx) = [];

WheelDat.newSpeed(:,nanidx) = [];

% store
twoPDat.ROImatrix = newROImatrix;
twoPDat.ROIid = ROIid;
twoPDat.ROIstats = ROIstats;
twoPDat.ROIsize = ROIsize;
twoPDat.TimeVector = ROItimeVector;
twoPDat.planeIdMatrix = ROIid;
twoPDat.planeFrameTime = planeFrameTime;
twoPDat.upPhases = upPhases;
twoPDat.downPhases = downPhases;    
twoPDat.SampleRate = options.TwoPSampleRate;

% assign new timeVector to other variables also 
WheelDat.timeVector = ROItimeVector;
EyeDat.timeVector = ROItimeVector;




%%%%%
% Extra info to save

if ~isempty(EyeDat)
    EyeDat.Animal = thisAnimal;
    EyeDat.Session = thisSession;
    EyeDat.Filenum = thisFileName;
    if options.includeWheel==1 && ~isempty(WheelDat)
        WheelDat = WheelDat;
    end
end
if ~isempty(twoPDat)
    twoPDat.Animal = thisAnimal;
    twoPDat.Session = thisSession;
    twoPDat.Filenum = thisFileName;
end

