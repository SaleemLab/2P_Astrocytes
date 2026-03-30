function [success] = splitAndConcatenateTIFFs(startFile,endFile,nPlanes,tiffOptions)

% function to take a TIFF file, split it in planes and then concatenate the
% planes in a new TIFF file. If the total size of the created TIFF file
% exceeds 5GB (>8 planes with current 2p config) it won't be written
%
% function needs
% tiffOptions.fileList: list of files to be split and concatenated
% tiffOptions.fileDir: directory where to find the files
% tiffOptions.saveDir: directory where to save the concatenated files
% tiffOptions.newFileName: name of file to be saved (exclude plane name)
%
% nFiles that need to be split and concatenated (cannot exceed 8)
% directory where to find the files
% list of FileNames that can be indexed

% TO DO 
% Load Ref File (already averaged across nSlices)
%[ref] = generateRef4Registration(refFileName, refOptions.refSlices);



% options.append = false;
for thisFile = startFile:endFile
    % create file if it is the first, append afterwards
    if thisFile == startFile
        options.append = false;
    else
        options.append = true;
    end
    % check how long it takes to load one file, one plane 
    thisTiff = tiffreadVolume(fullfile(tiffOptions.fileDir,tiffOptions.fileList{thisFile}));
    [d1,d2,d3] = size(thisTiff);
    maxSlices = floor(d3/nPlanes);
    planes = zeros(d1,d2,maxSlices,4);

    for thisPlane = 1:nPlanes
        planes(:,:,:,thisPlane) = thisTiff(:,:,thisPlane:nPlanes:maxSlices*4);
    end

    clear thisTiff

    for thisPlane = 1:nPlanes

        % Name new tiff File 
        fileName = fullfile(tiffOptions.saveDir, append(string(tiffOptions.newFileName),'plane_',string(thisPlane),'_registered.tif'));

        % Load Ref File (already averaged across nSlices)
        ref = tiffreadVolume(fullfile(tiffOptions.refDir,append('refPlane',string(thisPlane),'.tif')));
        % Run through Registration
        [planes(:,:,:,thisPlane)] = registration(planes(:,:,:,thisPlane),ref);


        % change class of Planes to int16
        planes = cast(planes,'int16');

        % save the registered planes to appropriate tiff 
        saveastiffSDL(planes(:,:,:,thisPlane),fileName,options);

    end
end


fprintf('\nSaved data to %s ...',tiffOptions.saveDir)
success = 1;