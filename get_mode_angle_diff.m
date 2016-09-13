function [ mode_angle_diff ] = get_mode_angle_diff(x,y)
%[ mean_angle_diff ] = get_mode_angle_diff(x,y) Calculates the most often 
% difference between two adjacent datapoints.
%   Cartesian coordinates are transferred to polar coordinates. 
%   
%   Input:
%       x   -   x value of cartesian coordinates
%       y   -   y value of cartesian coordinates
% 
%   Output:
%       mean_angle_diff     -   Mean difference of two following datapoints.
%                               Positive and negative values are possible.
%

[angle,~] = cart2pol(x,y);
diffs = reshape(diff(angle'),1,[]);
diffs(diffs==0) = [];
mode_angle_diff = mode(diffs);

end

