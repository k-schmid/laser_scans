function [ cloud ] = roundData( cloud, precision )
%[ cloud ] = roundData( cloud, precision) Data is rounded. Cartesian
%coordinates are updated.
%
%   Input:
%       cloud     -   Cloud data (Struct with fields:
%                     x, y, z, azimuth, elevation, radius). Radius values
%                     have to be real numbers (not Inf/NaN)
%       precision -   Number of decimal places
%   Output:
%       cloud     -   Adapted cloud data
%

cloud.radius = round(cloud.radius,precision);

[cloud.x,cloud.y,cloud.z]=sph2cart(cloud.azimuth,cloud.elevation,cloud.radius);

end


