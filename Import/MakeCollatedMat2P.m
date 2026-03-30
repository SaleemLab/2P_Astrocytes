
% function [success] = MakeCollatedMat2P(thisAnimal,thisSession,thisFileName,options)
% based on MakeCollatedMatLFPPhotometry

% Dependencies - needs 'getParametersForLFP_PMExperiments' and also needs
% folders 'Import' and 'ImportGeneral' from Tg4510-SRP repository, and
% 'MFLP' repository
% History 
% MakeCollatedMatLFPPHotometry SGS 12.12.2023
% Adapted for 2p SDL 15/02/2026
function [success,matfilepath] = MakeCollatedMat2P(thisAnimal,thisSession,thisFileName,options)
% Default options
if ~exist('thisAnimal', 'var')
    thisAnimal = 'M25136';
end
if ~exist('thisSession', 'var')
    thisSession = '20260219';
end
if ~exist('thisFileName', 'var')
    thisFileName = 'Contrast';
end
if ~exist('thisAcquisition', 'var')
    thisAcquisition = '00001';
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
end

% Get other parameters
options = getParametersFor2PExperiments(thisAnimal,options,thisSession);
FileNameIdx = ismember(options.FileName,thisFileName);
options.stim_dur = options.AllStim_dur(FileNameIdx);
options.Animal = thisAnimal;
options.Session = thisSession;
options.FileName = thisFileName;
options.nPlanes = 4;

% Set up success
success = -1;


% If necessary set up main folder
if ~exist(options.matToppath,'dir')
    fprintf('\nCreating new directory %s ...',options.matToppath)
    mkdir(options.matToppath)
end

% Set up relevant file names for collated data
targetAnimalAndSessionAndFileNumAndAcquisitionNum = strcat(lower(thisAnimal),'_',num2str(thisFileName),'_',thisSession,'_',thisAcquisition);
matfilepath = fullfile(options.matToppath,[targetAnimalAndSessionAndFileNumAndAcquisitionNum,'_collated.mat']);

% Check to see if it already exists - and if it does, if we want to overwrite
if exist(matfilepath,'file')
    fprintf('\nCollated mat file %s already exists...',matfilepath)
    if options.overwriteCollatedFlag
        fprintf('overwriting')
    else
        fprintf('NOT overwriting')
        return
    end
end
fprintf('\n\nParsing data for %s ...',targetAnimalAndSessionAndFileNumAndAcquisitionNum)

%%%%%%%
% Load the raw data from OE and eye data from bonsai logs
[EyeDat,WheelDat,twoPDat,options] = parseRawToCollated2P(thisAnimal,thisSession,thisFileName,thisAcquisition,options);

%%%%%%%
% Load stimulus data to read the file and return a table containing stim params
thisStimfileName = [];
stimInfo = [];
parseDate = date;

switch(options.FileName)
    case 'SparseNoiseTexture'
        thisBonsaiFile = fullfile(options.BonsaiPath, [thisAnimal,'_SparseNoiseTexture_', num2str(thisFileName),'_', '*']);
        folder_dir = dir(thisBonsaiFile);
        if ~isempty(folder_dir)
            folder_name = folder_dir.name;
            thisStimfileName = fullfile(options.BonsaiPath,folder_dir.name);
            stimInfo = []; %Events file not needed, bin file is sufficient
            %             [stim_info] = load_bonsai_SRP_csv_v1(thisBonfileName); % SGS 13/12/2023 may need to update this file which reads
        else
            stimInfo = [];
        end
        % Process bonvision file containing stimulus information
        % Read in the bonsai stimulus log
        thisBonsaiFile = fullfile(options.BonsaiPath, append(thisAnimal,'_SparseNoiseTexture_',thisSession,'_',thisAcquisition,'_Log', '*'));
        folder_dir = dir(thisBonsaiFile);
        if isempty(folder_dir) % Not always the same file root as above
            thisBonsaiFile = fullfile(options.BonsaiPath, [ thisAnimal,'_quaddata', '*']); % May need to be able to include other options here eg including filenumber
            folder_dir = dir(thisBonsaiFile);
        end
        folder_name = folder_dir.name;
        thisBonsaiFileName = fullfile(options.BonsaiPath,folder_name);
        fileID=fopen(thisBonsaiFileName);
        thisBinFile=fread(fileID);
        fclose(fileID);

        % Translate stimulus into -1:1 scale
        stim_matrix = zeros(1,length(thisBinFile));
        stim_matrix(thisBinFile==0)=-1;
        stim_matrix(thisBinFile==255)=1;
        stim_matrix(thisBinFile==128)=0;

        % Make a NxM grid from the stimulus log
        stim_matrix = reshape(stim_matrix, [options.grid_size(1), options.grid_size(2), length(thisBinFile)/options.grid_size(1)/options.grid_size(2)]);
        stim_matrix = stim_matrix(:,:,1:end-1); % The last upswing should be ignored

        stimTimestamps = union(twoPDat.upPhases,twoPDat.downPhases);
        if length(stimTimestamps)<size(stim_matrix,3)
            warning('Number of ttls (%d) LESS than number of stimulus instances (%d).',length(stimTimestamps),size(stim_matrix,3));
        elseif length(stimTimestamps)>size(stim_matrix,3)
            warning('Number of ttls (%d) MORE than number of stimulus instances (%d).',length(stimTimestamps),size(stim_matrix,3));
        end

        % Save data
        save(matfilepath, 'EyeDat','WheelDat','twoPDat','stimInfo','stim_matrix','options','parseDate');

        fprintf('\nSaved data to %s ...',matfilepath)
        success = 1;
        return 
    otherwise

        thisStimFileName = fullfile(options.BonsaiPath, [thisAnimal,'_',thisFileName,'_',thisSession,'_',thisAcquisition,'_stimEvents','*']);
        folder_dir = dir(thisStimFileName);
        folder_name = folder_dir.name;

end

thisStimFileName = fullfile(options.BonsaiPath,folder_dir.name);
stimInfo = readtable(thisStimFileName);
stimInfo.Properties.VariableNames  = {'Frame','Timestamp', 'Computer_Timestamp', 'StimType', 'StimValue'};

%[stim_info] = load_bonsai_LFPPhotometry_csv(thisStimFile,options);

% Save data
save(matfilepath,'EyeDat','WheelDat','twoPDat','stimInfo','options','parseDate');


fprintf('\nSaved data to %s ...',matfilepath)
success = 1;



