function [ cloud ] = reject_outlier( cloud, outlier_range, layers_of_interest )
%[ cloud ] = reject_outlier( cloud, outlier_range, layers_of_interest)
%Rejects outlier
%
%   Input:
%       cloud               -   The raw cloud data with at least two dimensions
%                               (x,y)
%       outlier_range       -   Value in degree. Specifies the minimal angle of
%                               following infinity measures until such a
%                               measure is regarded as outlier.
%       layers_of_interest  -   (Optional) Only the layers of interest are
%                               evaluated
%
%   Output:
%       cloud           -   3 dimensional cartesian coordinates (depends
%                           on the input dimensionality) plus 3
%                           dimensions for azimuth, elevation and radius information.
%


end

