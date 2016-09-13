function [ cloud ] = reject_outlier( cloud, outlier_range, layers_of_interest )
%[ cloud ] = reject_outlier( cloud, outlier_range, layers_of_interest)
%Rejects outlier
%
%   Input:
%       cloud               -   The sorted cloud data with three dimensions
%                               (x,y,z)
%       outlier_range       -   Value in degree. Specifies the minimal angle of
%                               following infinity measures until such a
%                               measure is regarded as outlier.
%       layers_of_interest  -   Only the layers of interest are
%                               evaluated
%
%   Output:
%       cloud           -   3 dimensional cartesian coordinates (depends
%                           on the input dimensionality) plus 3
%                           dimensions for azimuth, elevation and radius information.
%

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

fprintf('Removed %d data lines',length(reject_datalines))
end

