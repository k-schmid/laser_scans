function [ cloud ] = get_sorted_scans( cloud,  layers_of_interest)
%[ sorted_cloud ] = getSortedScans( cloud, outlier_range, layers_of_interest) Sorts cloud data
% by angle and add angle information
%
%   Input:
%       cloud               -   The raw cloud data with at least two dimensions
%                               (x,y)
%       layers_of_interest  -   (Optional) Only the layers of interest are
%                               evaluated
%
%   Output:
%       sorted_cloud    -   3 dimensional cartesian coordinates (depends
%                           on the input dimensionality) plus 3
%                           dimensions for azimuth, elevation and radius information.
%

num_layers = size(cloud,1);
layers_selected = true;
if nargin<3
    layers_selected = false;
    layers_of_interest = 1:num_layers;
end


% Sort the cloud by increasing angles
cloud = sort_cloud(cloud);

%% Outlier rejection
[layers_idx,data_lines_idx]=find(isnan(cloud.radius(layers_of_interest,:)));
reject_idx = zeros(length(layers_idx),1);
for i = 1:length(layers_idx)
    layer = layers_of_interest(layers_idx(i));
    data_line = data_lines_idx(i);
    if is_outlier(cloud,data_line,layer,outlier_range)
        reject_idx(i) = 1;
    end
end
reject_datalines = data_lines_idx(logical(reject_idx));
cloud.azimuth(:,reject_datalines) = [];
cloud.x(:,reject_datalines) = [];
cloud.y(:,reject_datalines) = [];
cloud.z(:,reject_datalines) = [];
cloud.elevation(:,reject_datalines) = [];
cloud.radius(:,reject_datalines) = [];

% warning('Removed %d data lines',length(reject_datalines))

