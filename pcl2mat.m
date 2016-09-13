function [ output_args ] = pcl2mat( folder_path )
%PCL2MAT Summary of this function goes here
%   Detailed explanation goes here

% Get a list of all files and folders in this folder.
files = dir(folder_path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

folderNames = {subFolders.('name')};
folderIdx = cellfun(@str2num,folderNames,'un',0);
%Check for none numeric folder names (which are ignored)
numericValue = ~cell2mat(cellfun(@isempty,folderIdx,'un',0));
% Remove none numeric folder names and change to array
folderIdx = cell2mat(folderIdx);
[~,idx] = sort(folderIdx);

%Remove first folders with non numeric names and sort afterwards
subFolders = subFolders(numericValue);
subFolders = subFolders(idx);

numFolder = length(subFolders);

for i = 1:numFolder
    subFolder = subFolders(i);
    subFolderPath = [folder_path subFolder.name];
    pcd_file_list = dir([subFolderPath,'/*.pcd']);
    
    cloud.x = [];
    cloud.y = [];
    cloud.z = [];
    cloud.azimuth = [];
    cloud.elevation = [];
    cloud.radius = [];
    
    for j = 1:length(pcd_file_list)
        file = pcd_file_list(j);
        current_cloud = loadpcd([subFolderPath,'\',file.name]);
        cloud.x= cat(2,cloud.x,current_cloud(:,:,1));
        cloud.y= cat(2,cloud.y,current_cloud(:,:,2));
        cloud.z= cat(2,cloud.z,current_cloud(:,:,3));
        cloud.azimuth= cat(2,cloud.azimuth,current_cloud(:,:,4));
        cloud.elevation= cat(2,cloud.elevation,current_cloud(:,:,5));
        cloud.radius= cat(2,cloud.radius,current_cloud(:,:,6));    
    end
    save([subFolderPath '\cloud.mat'],'cloud')
end

end

