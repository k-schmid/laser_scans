function [ is_outlier ] = is_outlier( sorted_cloud,idx,layer,angle_range, percentage_equal)
%[ is_outlier ] = is_outlier( sorted_cloud,idx,layer,angle_range) Checks whether
%the infinity radius of the data point with the given index is an outlier.
%   If not enough neighbours of the current data point has infinity
%   radius as well, the data point is regarded as an outlier. The number
%   of neighbours is defined by an angle range. If a sequence of following
%   neighbours of at least this angle are inifinity the current is regarded
%   as being not an outlier.
%
%   Input:
%       sorted_cloud    -   Struct with fields azimuth and radius
%       idx             -   Index of the current data point
%       layer           -   layer of the current data point
%       anlge_range     -   Minimal angle of adjacent infinity measures.
%   Output:
%       is_outlier    -   Boolean
%

if nargin < 5
    percentage_equal = 0.75;
end
num_elem = size(sorted_cloud.radius,2);
radius_datapoint = sorted_cloud.radius(layer,idx);
angle_datapoint = sorted_cloud.azimuth(layer,idx);

% find idx of lower angle limit
lower_angle_limit = angle_datapoint - angle_range;
lower_angle_limit =  mod(lower_angle_limit,2*pi);
lower_idx = find(sorted_cloud.azimuth(layer,:)<lower_angle_limit,1,'last');

% find idx of upper angle limit
upper_angle_limit = angle_datapoint + angle_range;
upper_angle_limit =  mod(upper_angle_limit,2*pi);
upper_idx = find(sorted_cloud.azimuth(layer,:)>upper_angle_limit,1);


if lower_idx < idx
    neighbouring_radii = sorted_cloud.radius(layer,lower_idx:idx);
else
    neighbouring_radii = sorted_cloud.radius(layer,[1:idx,lower_idx:num_elem]);
end
num_equal = sum(isnan(neighbouring_radii));
num_total = length(neighbouring_radii);
if num_equal > percentage_equal * num_total
    is_outlier = false;
    return
end

if upper_idx > idx
    neighbouring_radii = sorted_cloud.radius(layer,idx:upper_idx);
else
    neighbouring_radii = sorted_cloud.radius(layer,[1:upper_idx,lower_idx:num_elem]);
end
num_equal = sum(isnan(neighbouring_radii));
num_total = length(neighbouring_radii);
if num_equal > percentage_equal * num_total
    is_outlier = false;
    return
end


is_outlier = true;
return
end

