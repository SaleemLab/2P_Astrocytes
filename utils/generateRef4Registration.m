function [success] = generateRef4Registration(refFileName, refSlices, nPlanes, saveDir)
% generates ref slice to be used in registration
% needs: 
% refFileName: directory of slices needed for reference 
% refSlices: which slices to be averaged to generate the reference
% 
% Set parameters for writing image
options.append = false;
tic
refFullFile = tiffreadVolume(refFileName);
toc 

for thisPlane = 1:nPlanes
    ref(:,:,:,thisPlane) = refFullFile(:,:,thisPlane:nPlanes:end);
end

clear refFullFile

for thisPlane = 1:nPlanes
    tRef = mean(ref(:,:,refSlices(1):refSlices(2),thisPlane),3);

    % change class from double to int6
    tRef = cast(tRef,'int16');

    saveastiffSDL(tRef,fullfile(saveDir,append('refPlane',string(thisPlane),'.tif')),options);
    clear tRef
end

success = 1;