function options = getParametersFor2PExperiments(animal,options,session)
% based on getParametersForLFPPhotometryExperiments
%
% Function to provide single point of access for animal/batch dependent
% parameter setting for collating SRP experiments with Reward
%
% Returns options structure for the relevant animal. Will add to that
% structure if passed through
%
% Example calls:
%    options = getParametersForLFP_PMExperiments('M20018',options,session)
%

if ~exist('session','var')
    session = -1;
end
if ~exist('options','var') || isempty(options)
    options = struct;
end

%%%
% % New code for more transparency

allParadigmData = {
    'GrayScreen', 1; ...
    'Contrast', 1.5; ... % 1.5s, 25%, 100% contrast
    'Position', 10; ... % 10s 1.3TF on left and right screen
    'SparseNoiseTexture',0.5; ...
    };

options.FileName = allParadigmData(:,1);
options.AllStim_dur = cell2mat(allParadigmData(:,2)');
options.paradigms = allParadigmData(:,2)';


% Wheel related parameters
options.includeWheel = 1;   % If 1, get from OE or Arduino depending what is available
options.wheelDiameter = 19.05; % cm Sara D 13.05.2025
options.wheelDirection = 1; % -1 means forward == negative values; it is 1 for 2p rig 

% Eye Tracker related parameters
options.EyeSR = 31;
options.photo_br = 1; % 0 (when the screen had pulse width modulation) or 1 (when it didn't - most recent data)
options.eyeTrackerParams.eyeRadius = 1.25; %mm Sakatani Isa (2004) model of the effective eye radius based on Remtulla Hallett (1985) measurements of anatomical parameters from C57B1/6J mice eyes.
options.eyeTrackerParams.blink_thresh_std = 2; % standard deviations from the median
options.eyeTrackerParams.n_pre = 2;  % samples to remove before the blink
options.eyeTrackerParams.n_post = 3; % samples to remove after the blink
options.eyeTrackerParams.mmPerCameraPix = 0.02;

% Sparse noise parameters
options.grid_size = [8 12];
end