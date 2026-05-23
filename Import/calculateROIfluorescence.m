% function [roiInfo] = calculateRoiFluorescence(dirRoiFile,dirTiffFile)
%UNTITLED3 Summary of this function goes here
% SDL 03/2026
if ~exist('thisAnimal', 'var')
    thisAnimal = 'M25134';
end
if ~exist('thisSession', 'var')
    thisSession = '20260218';
end
if ~exist('thisFileName', 'var')
    thisFileName = 'GrayScreen';
end

if ~exist('thisRoiSetAcquisition', 'var')
    thisRoiSetAcquisition = '__00001';
end

if ~exist('options', 'var')
    % Defualts
    options.logErrorsFlag = 0;
    options.overwriteCollatedFlag = 1;
end
if ~isfield(options,'BonsaiPath')
    % Paths
    if ispc
        if exist('Z:\ibn-vision','dir')==7
            serverPath = 'Z:\ibn-vision\';
        else
            serverPath = 'Z:\';
        end
    elseif ismac
        serverPath = '/Volumes/Research4/ibn-vision';
    end

    options.OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
    options.TwoPPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'Processed2P');
    options.desktopPath = "C:\Users\sara.deleo\Desktop\";
    options.concatPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession),'ConcatenatedPlanes');
    options.matToppath = fullfile(options.TwoPPath,upper(thisSession));
end

% If necessary set up Session Folder inside TwoPPath
if ~exist(options.matToppath,'dir')
    fprintf('\nCreating new directory %s ...',options.matToppath)
    mkdir(options.matToppath)
end

AnimalAndSessionConcatenatedFiles = dir(options.concatPath);
AnimalAndSessionConcatenatedFiles = struct2table(AnimalAndSessionConcatenatedFiles);

ttIdx = find(contains(AnimalAndSessionConcatenatedFiles.name,thisFileName));
theseStimulusFiles = AnimalAndSessionConcatenatedFiles.name(ttIdx);

% find how many acquisitions there are for this stimulus
fileEnd = "_" + digitsPattern(1) + 'plane_' + digitsPattern(1) + "_registered.tif";
tempStimulusFiles = erase(theseStimulusFiles,fileEnd);
uAcquisitions = unique(tempStimulusFiles);

% find how many concatenated files there are for each plane
fileEnd = "plane_" + digitsPattern(1) + "_registered.tif";
tempStimulusFiles = erase(theseStimulusFiles,fileEnd);
acquisitionInfo = "__" + digitsPattern(5) + "__";
tempStimulusFiles = erase(tempStimulusFiles,acquisitionInfo);
uConcatFiles = unique(tempStimulusFiles);

nPlanes = 4;

%%
% loop through acquisitions to generate files

% create variables of interest

%%
for thisAcquisition = 1 %:length(uAcquisitions)
    for thisPlane = 1:nPlanes

        % define directories for Roi File - currently independent of
        % Acquisition number, using the same ROI set for both acquisitions
        % - will need to standardise
        dirRoiFile = fullfile(options.concatPath,'RoiSets', append(upper(thisAnimal),'_',thisFileName, '_', ...
            string(thisSession),thisRoiSetAcquisition,'__plane_',string(thisPlane),'_RoiSet.zip'));

        % load the ROI stats and the Tiff video
        % if only one Roi, and not an RoiSet, try different syntax
        try  roiStats = ReadImageJROI(dirRoiFile);
        catch dirRoiFile = fullfile(options.concatPath,'RoiSets', append(upper(thisAnimal),'_',thisFileName, '_', ...
                string(thisSession),thisRoiSetAcquisition,'__plane_',string(thisPlane),'_RoiSet.roi'));
            roiStats = ReadImageJROI(dirRoiFile);


            nRois = length(roiStats);
            for thisConcatFile = 1:length(uConcatFiles)

                % define directories for Tiff

                dirTiffFile = fullfile(options.concatPath, append(upper(thisAnimal),'_',thisFileName, '_', ...
                    string(thisSession),'__0000',string(thisAcquisition),'__',string(thisConcatFile),'plane_',string(thisPlane),'_registered.tif'));
                if ~isfile(dirTiffFile)
                    warning("this file %s does not exist",dirTiffFile)
                else

                    % loadTiffFile
                    tic
                    currentTiff = tiffreadVolume(dirTiffFile);
                    toc

                    % pre allocate variables
                    troiSum = zeros(nRois,size(currentTiff,3));
                    mask = zeros(size(currentTiff,1),size(currentTiff,2),nRois);

                    % show the first image of the video
                    standardImg = imagesc(max(currentTiff,[],3));

                    % use the vertex position to draw an ROI
                    for thisRoi = 1:size(roiStats,2)
                        try roi = drawpolygon('Position',roiStats{1,thisRoi}.mnCoordinates);
                        catch roi = drawpolygon('Position',roiStats(1,thisRoi).mnCoordinates);
                            mask(:,:,thisRoi)= createMask(roi);
                            clear roi
                        end

                        for thisRoi = 1:size(roiStats,2)
                            try tRoiPosition(thisRoi,:) = {roiStats{1,thisRoi}.mnCoordinates};
                            catch tRoiPosition(thisRoi,:) = {roiStats(1,thisRoi).mnCoordinates};
                            end

                            % transform mask into matrix
                            mask = single(mask);

                            % calculate the sum fluorescence within each ROI (+ record how many pixels
                            % in each ROI); can use these info later to calculate mean fluorescence
                            for thisRoi = 1:size(mask,3)
                                troiSum(thisRoi,:) = sum(pagemtimes(single(currentTiff),squeeze(mask(:,:,thisRoi))),[1 2]);
                                roiSize(thisRoi) = size(find(mask(:,:,thisRoi)),1);
                            end


                            % Store info across concat files
                            roiSum{thisConcatFile,:} = troiSum;

                            clear tRoiSum

                        end
                    end
                    % Store info across plane files
                    roiInfo.roiStats(1:nRois,:) = roiStats';
                    roiInfo.roiSum = roiSum;
                    roiInfo.roiSize = roiSize;


                    % Define Saving directory depending on plane and acquisition
                    savingDir = fullfile(options.matToppath,append(thisAnimal,'_',thisFileName,'_',thisSession,'_0000',string(thisAcquisition),'_plane_',string(thisPlane),'RoiFluorescence.mat'));

                    % Save data
                    save(savingDir,'roiInfo');

                    clear roiInfo roiSum roiSize
                end
            end
        end
    end
end
