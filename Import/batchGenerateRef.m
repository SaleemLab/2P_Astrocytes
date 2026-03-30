% Script to generate Ref files

% Set Paths 
if ispc
    if exist('Z:\ibn-vision','dir')==7
        serverPath = 'Z:\ibn-vision\';
    else
        serverPath = 'Z:\';
    end
elseif ismac
    serverPath = '/Volumes/Research4/ibn-vision';
end

%% Generate reference file for M25135 GrayScreen 1
thisAnimal = 'M25135';
thisSession = '20260219';
thisFileName = 'GrayScreen';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00003';

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));

% which and how many slices are averaged
refSlices = [1 300];


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25135 GrayScreen 2
thisAnimal = 'M25135';
thisSession = '20260219';
thisFileName = 'GrayScreen';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00003';

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));

% which and how many slices are averaged
refSlices = [1 300];


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25135 Contrast 1
thisAnimal = 'M25135';
thisSession = '20260219';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00005';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25139 SparseNoise
thisAnimal = 'M25139';
thisSession = '20260226';
thisFileName = 'SparseNoise';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00005';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25139 Contrast 1 
thisAnimal = 'M25139';
thisSession = '20260220';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00008';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25136 Contrast 1 
thisAnimal = 'M25136';
thisSession = '20260223';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00009';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25136 Position 1 
thisAnimal = 'M25136';
thisSession = '20260227';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00013';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25136 SparseNoise
thisAnimal = 'M25136';
thisSession = '20260227';
thisFileName = 'SparseNoiseTexture';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00004';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25137 Contrast
thisAnimal = 'M25137';
thisSession = '20260304';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00008';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25137 Position
thisAnimal = 'M25137';
thisSession = '20260317';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00011';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25138 Contrast
thisAnimal = 'M25138';
thisSession = '20260218';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00011';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25134 Contrast
thisAnimal = 'M25134';
thisSession = '20260218';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00012';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25134 Position
thisAnimal = 'M25134';
thisSession = '20260224';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00012';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);


