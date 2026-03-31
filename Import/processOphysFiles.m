% function processOphysFiles(thisAnimal,thisSession,thisFileName,thisAcquisition,options,twoPLog)
% SDL 03/2026
% Default options
if ~exist('thisAnimal', 'var')
    thisAnimal = 'M25138';
end
if ~exist('thisSession', 'var')
    thisSession = '20260225';
end
if ~exist('thisFileName', 'var')
    thisFileName = 'Position';
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
    options.BonsaiPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'Bonsai',upper(thisSession));
    options.EyePath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'EyeTracking',upper(thisSession));
    options.TwoPPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'Processed2P',upper(thisSession));
    options.matToppath = fullfile(serverPath,'DATA','PROJECTS','2P_SDL','CollatedMat',upper(thisAnimal));
    options.desktopPath = "C:\Users\sara.deleo\Desktop\";
end

% other Options and Flags
options.flagAlternativeAcquisition = 1;
options.alternativeRefAcquisition = '_00001_';


% Find relevant files 
AnimalAndSessionOphysFiles = dir(options.OPhysPath);
AnimalAndSessionOphysFiles = struct2table(AnimalAndSessionOphysFiles);

ttIdx = find(contains(AnimalAndSessionOphysFiles.name,thisFileName));
theseStimulusFiles = AnimalAndSessionOphysFiles.name(ttIdx);

% find how many acquisitions there are for this stimulus
fileEnd = "_" + digitsPattern(5) + ".tif";
tempStimulusFiles = erase(theseStimulusFiles,fileEnd);
uAcquisitions = unique(tempStimulusFiles);

% have the option of using reference file from different acquisition (i.e.,
% if you want to use reference file from Contrast 1 acquisition, for
% Contrast 2 acquisition) 

if options.flagAlternativeAcquisition
    thisRefAcquisition = options.alternativeRefAcquisition;
else
    thisRefAcquisition = thisAcquisition;
end

% loop through acquisitions to generate files 

for acquisitionsNumber = 1:length(uAcquisitions)

    thisAcquisition = '_0000' + string(acquisitionsNumber) + '_';


    tIdx = find(contains(theseStimulusFiles,thisAcquisition));
    theseStimulusANDAcquisitionFiles = theseStimulusFiles(tIdx);
    nFiles = length(theseStimulusANDAcquisitionFiles);
    nPlanes = 4;

    % setting TIFF Options to split and concatenated OPhys Files
    tiffOptions.fileList = theseStimulusANDAcquisitionFiles;
    tiffOptions.fileDir = options.OPhysPath;
    tiffOptions.saveDir = fullfile(options.desktopPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession),'ConcatenatedPlanes');
    tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),thisAcquisition);
    tiffOptions.refDir = fullfile(options.OPhysPath,'ReferencePlanes',append(string(thisAnimal),'_',string(thisFileName),'_',thisSession,thisRefAcquisition));


    if nFiles<8
        startFile = 1;
        endFile = nFiles;
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);

    elseif nFiles>8 && nFiles<16
        startFile = 1;
        endFile = 8;
        tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),'_',thisAcquisition,'_1');
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);

        startFile = 9;
        endFile = nFiles;
        tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),'_',thisAcquisition,'_2');
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);
    elseif nFiles>16
        startFile = 1;
        endFile = 8;
        tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),'_',thisAcquisition,'_1');
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);

        startFile = 9;
        endFile = 16;
        tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),'_',thisAcquisition,'_2');
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);
        
        startFile = 17;
        endFile = nFiles;
        tiffOptions.newFileName = append(upper(thisAnimal),'_',thisFileName,'_',upper(thisSession),'_',thisAcquisition,'_3');
        [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions);
    end
end
