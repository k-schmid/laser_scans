function [cloud] = reduceAngle(cloud,viewing_angle, layers_of_interest)
%[ cloud ] = reduceAngle( cloud, viewing_angle, layers_of_interest)
%Rejects outlier
%
%   Input:
%       cloud               -   The sorted cloud data with three dimensions
%                               (x,y,z)
%       viewing_angle       -   Angle to be used [min,max]
%       layers_of_interest  -   Only the layers of interest are
%                               evaluated
%
%   Output:
%       cloud           -   cloud with reduced data
%


