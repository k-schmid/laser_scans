function  plot_intersection( folder_path, layer_of_interest,outlier_range, rangeLimit, viewing_angle,precision,center_statistics,num_bins,reload,save_mat,verbose)
%[ output_args ] = plot_intersection( input_args ) Plots all the data of a
%whole intersection
%   All data within a folder is plotted. Each viewpoint is assumed to have
%   its own subfolder with the index of it (1,2,3,...). Return the
%   datapoints.
%
%   Input:
%       folder_path     -   Path of the intersection data
%   Output:
%       clouds          -   Processed point clouds
%

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
subplot_dim = [round(sqrt(numFolder)),ceil(sqrt(numFolder))];
fig_handle = figure();
for i = 1:numFolder
    fprintf('Scene %d/%d\n',i,numFolder);
    subFolder = subFolders(i);
    subFolderPath = [folder_path subFolder.name];
    if exist(sprintf('%s/cloud_preprocessed.mat',subFolderPath),'file') && reload
        loaded_data = load(sprintf('%s/cloud_preprocessed.mat',subFolderPath));
        centers = loaded_data.centers;
        %         clear loaded_data
    else
        loaded_data = load([subFolderPath '/cloud.mat']);
        cloud = loaded_data.cloud;
        cloud = sort_cloud(cloud);
        %         cloud = roundData(cloud,precision);
        %         cloud = reduceAngle(cloud, viewing_angle,layer_of_interest);
        %         cloud = reject_outlier(cloud,outlier_range,layer_of_interest);
        cloud = setLimit(cloud, rangeLimit);
        centers = get_isovist(num_bins,cloud,1,layer_of_interest,outlier_range, rangeLimit);
        %         centers = gaussFilterCenters(centers,5);
        if save_mat
            save_mat_file( centers,cloud,subFolderPath,layer_of_interest );
        end
    end
    
    centers = rejectArtefacts(centers,rangeLimit,verbose,center_statistics);
    figure(fig_handle)
    subplotxl(subplot_dim(1),subplot_dim(2),i);
    %         scatter(clouds{i}.x(7,:),clouds{i}.y(7,:),2,'r','filled')
    plot_isovist( centers.(center_statistics));
end

end

