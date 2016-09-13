function  plot_intersection( folder_path, layer_of_interest,outlier_range, rangeLimit, viewing_angle )
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
if nargin <2
    layer_of_interest = 8;
end
if nargin <3
    outlier_range = deg2rad(1.5);
end
if nargin <4
    rangeLimit = 60;
end
if nargin <5
    viewing_angle = [deg2rad(0),deg2rad(180)];
end


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
clouds = cell(numFolder,1);

subplot_dim = [ceil(sqrt(numFolder)),round(sqrt(numFolder))];
figure()
for i = 1:numFolder
    subFolder = subFolders(i);
    subFolderPath = [folder_path subFolder.name];
    if exist(sprintf('%s/cloud_preprocessed_%d.mat',subFolderPath,layer_of_interest))==2 && 0
        load(sprintf('%s/cloud_preprocessed_%d.mat',subFolderPath,layer_of_interest));
    else
        load([subFolderPath '/cloud.mat']);
        cloud = sort_cloud(cloud);
        cloud = reject_outlier(cloud,outlier_range,layer_of_interest);
        cloud = setLimit(cloud, rangeLimit);     
        cloud = reduceAngle(cloud, viewing_angle);
        centers = get_isovist(360,cloud,1,layer_of_interest,false);
        save(sprintf('%s/cloud_preprocessed_%d.mat',subFolderPath,layer_of_interest),'centers','cloud')
    end
    subplotxl(subplot_dim(1),subplot_dim(2),i);
    %     scatter(clouds{i}.x(7,:),clouds{i}.y(7,:),2,'r','filled')
    plot(centers.x,centers.y,'Marker','.')
    hold on
    plot([centers.x(end),centers.x(1)],[centers.y(end),centers.y(1)],'Marker','.','LineWidth',0.1,'MarkerSize',1)
    plot(0,0,'Marker','.','MarkerSize',10,'Color','r')
    xlim([-100,100])
    ylim([-100,100])
    axis off
    axis equal
    hold off
end

end

