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
return
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

%% Generate reference file for M25134 Position
thisAnimal = 'M25135';
thisSession = '20260304';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00014';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25139 Position
thisAnimal = 'M25139';
thisSession = '20260226';
thisFileName = 'Position';
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

%% Generate reference file for M25139 Position
thisAnimal = 'M25138';
thisSession = '20260225';
thisFileName = 'Position';
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

%% Generate reference file for M25139 Position
thisAnimal = 'M25138';
thisSession = '20260228';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25134 SparseNoiseTexture
thisAnimal = 'M25134';
thisSession = '20260302';
thisFileName = 'SparseNoiseTexture';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);


%% Generate reference file for M25137 SparseNoiseTexture
thisAnimal = 'M25137';
thisSession = '20260317';
thisFileName = 'SparseNoiseTexture';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25138 SparseNoiseTexture
thisAnimal = 'M25138';
thisSession = '20260228';
thisFileName = 'SparseNoiseTexture';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);


%% Generate reference file for M25135 SparseNoiseTexture
thisAnimal = 'M25135';
thisSession = '20260304';
thisFileName = 'SparseNoiseTexture';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25134 Position1
thisAnimal = 'M25134';
thisSession = '20260414';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00010';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25134 Position2
thisAnimal = 'M25134';
thisSession = '20260414';
thisFileName = 'Position';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25134 Contrast3
thisAnimal = 'M25134';
thisSession = '20260414';
thisFileName = 'Contrast';
thisAcquisition = '_00003_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00005';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25138 Position1
thisAnimal = 'M25138';
thisSession = '20260415';
thisFileName = 'Position';
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

%% Generate reference file for M25138 Contrast1
thisAnimal = 'M25138';
thisSession = '20260415';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25138 Contrast2
thisAnimal = 'M25138';
thisSession = '20260415';
thisFileName = 'Contrast';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25135 Contrast1
thisAnimal = 'M25135';
thisSession = '20260416';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00007';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25135 Contrast2
thisAnimal = 'M25135';
thisSession = '20260416';
thisFileName = 'Contrast';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25135 Position1
thisAnimal = 'M25135';
thisSession = '20260416';
thisFileName = 'Position';
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
%% Generate reference file for M25135 Position2
thisAnimal = 'M25135';
thisSession = '20260416';
thisFileName = 'Position';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00007';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25136 Contrast1
thisAnimal = 'M25136';
thisSession = '20260417';
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
%% Generate reference file for M25136 Contrast2
thisAnimal = 'M25136';
thisSession = '20260417';
thisFileName = 'Contrast';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00005';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25136 Position1
thisAnimal = 'M25136';
thisSession = '20260417';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00007';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25136 Position2
thisAnimal = 'M25136';
thisSession = '20260417';
thisFileName = 'Position';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00008';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);

%% Generate reference file for M25137 Contrast1
thisAnimal = 'M25137';
thisSession = '20260421';
thisFileName = 'Contrast';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25137 Contrast2
thisAnimal = 'M25137';
thisSession = '20260421';
thisFileName = 'Contrast';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25137 Position1
thisAnimal = 'M25137';
thisSession = '20260421';
thisFileName = 'Position';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25137 Position2
thisAnimal = 'M25137';
thisSession = '20260421';
thisFileName = 'Position';
thisAcquisition = '_00002_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00006';
% which and how many slices are averaged
refSlices = [700 1000];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
%% Generate reference file for M25134 GrayScreen1
thisAnimal = 'M25134';
thisSession = '20260218';
thisFileName = 'GrayScreen';
thisAcquisition = '_00001_';
nPlanes = 4;

% which file is taken for registration
thisTiffFile = '00003';
% which and how many slices are averaged
refSlices = [1 300];

OPhysPath = fullfile(serverPath,'DATA','SUBJECTS',upper(thisAnimal),'OPhys',upper(thisSession));
saveDir = fullfile(OPhysPath,'ReferencePlanes',append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition));
refFileName = fullfile(OPhysPath,append(upper(thisAnimal),'_',thisFileName,'_',thisSession,thisAcquisition,thisTiffFile,'.tif'));


generateRef4Registration(refFileName, refSlices, nPlanes, saveDir);
