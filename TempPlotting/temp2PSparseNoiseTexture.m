% Analyse Photometry Sparsenoise
% Adapted from Visual-response-analysis:sparsenoise:sparseNoiseCaAnalyse to
% make use of the fact that photometry data has already been collated
% Assumes you have loaded the collated mat file into the system already
% SGS 2nd May 2024

options.stim_dur = 0.533;


wheel_data = [];
eye_data = [];
twoP_data = [];

% assign upPhases and downPhases
upPhases = twoPDat.upPhases;
downPhases = twoPDat.downPhases;

% normalise responses 
% RoiSizeMat = repmat(twoPDat.ROIsize',1,length(twoPDat.ROImatrix));
% meanRoiMat = twoPDat.ROImatrix./RoiSizeMat;
% 
% normaliser = prctile(twoPDat.ROImatrix,10,2);
% normaliser = repmat(abs(normaliser),1,length(twoPDat.ROImatrix));
% 
% deltafMat = twoPDat.ROImatrix-normaliser;
% deltafOverfMat = deltafMat./normaliser;


% % average across all ROIs
allPixels = sum(twoPDat.ROIsize);
avgRoi = sum(twoPDat.ROImatrix,1)./allPixels;

normaliser = prctile(avgRoi,10,2);
deltaf = avgRoi-normaliser;
deltafOverf = deltaf./normaliser;


% Get all timestamps
if ~isempty(twoPDat)
    % make sure there are equal numbers of upPhases and downPhases
    if length(upPhases) > length(downPhases)
        upPhases(length(downPhases)+1:end) = [];
    elseif length(upPhases) < length(downPhases)
        downPhases(length(upPhases)+1:end) = [];
    end

    timestamps = union(twoPDat.upPhases, twoPDat.downPhases);
    % ttltimestamps = ttltimestamps(1:size(stim_matrix,3)); %
    if length(timestamps) > size(stim_matrix,3)
        timestamps(size(stim_matrix,3)+1:end) = [];
    elseif length(timestamps) < size(stim_matrix,3)
        stim_matrix(:,:,length(timestamps)+1:end) = [];
    end
    
    mapSampleRate = twoPDat.SampleRate; % Hz at which map is calculated
    samples_to_keep =  fix(options.stim_dur*mapSampleRate);
    twoP_data = nan(length(timestamps),samples_to_keep);
end


% Get the lfp, photometry and wheel signal for each stimulus presentation
% - samples to keep after ttl pulse (equals to stimulus duration)

% % First - its possible that the number of stimuli 'shown' are not equal to
% % the number of stimuli recorded, if things weren't shut down correctly
% if ~isempty(OE) && ~isempty(PMDat)
%     if length(pm_ttltimestamps) ~= length(ttltimestamps)
%         error('Different numbers of ttl pulses in OE and PM')
%     end
% end
% stim_matrix = stim_matrix(:,:,1:length(pm_ttltimestamps));
% 

% for thisRoi = 1:50
    if ~isempty(twoPDat)
        for i=1:size(stim_matrix,3)-6
            twoP_data(i,:) = deltafOverf(:,timestamps(i):timestamps(i)+samples_to_keep-1);
            wheel_data(i,:) = WheelDat.newSpeed(:,timestamps(i):timestamps(i)+samples_to_keep-1);
            eye_data(i,:) = EyeDat.Area(:,timestamps(i):timestamps(i)+samples_to_keep-1);
        end
    end


    %%%%%
    % Call mapping progamme
    options.mapMethod = 'fitlm'; % could be fitlm or mean
    options.figName = sprintf('%s :: %s (file %01d)',    options.Animal, options.Session,1);%,  thisRoi);
    options.mapSampleRate = mapSampleRate;
    options.framesToShow = fix([80,160,240,480].*(mapSampleRate/1000));
    initMap_2P = sparseNoiseAnalysis(stim_matrix(:,:,1:end-6),twoP_data(1:end-6,:)-repmat(twoP_data(1:end-6,1),1,size(twoP_data,2)),wheel_data,eye_data,options);
    drawnow
% end
