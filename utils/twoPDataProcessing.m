function twoPDataProcessing(thisAnimal,thisSession,thisFileName,thisAcquisition,options,twoPLog)

%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
% Findoptions.OPhysPath = 'Z:\ibn-vision\DATA\SUBJECTS\M25135\OPhys\20260219\';
AnimalAndSessionOphysFiles = dir(options.OPhysPath);
AnimalAndSessionOphysFiles = struct2table(AnimalAndSessionOphysFiles);

ttIdx = find(contains(AnimalAndSessionOphysFiles.name,thisFileName));
theseStimulusFiles = AnimalAndSessionOphysFiles.name(ttIdx);

tIdx = find(contains(theseStimulusFiles,thisAcquisition));
theseStimulusANDAcquisitionFiles = theseStimulusFiles(tIdx);


