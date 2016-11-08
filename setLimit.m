function [ cloud ] = setLimit( cloud, limit)
%[ cloud ] = setLimit( cloud, limit) All radius values larger than limit
%are set to the limit and cartesian coordinates are adapted.
%   datapoints.
%
%   Input:
%       cloud     -   Cloud data (Struct with fields:
%                     x, y, z, azimuth, elevation, radius)
%       limit     -   Maximal value
%   Output:
%       cloud     -   Adapted cloud data
%

idxs = cloud.radius > limit;
cloud.radius(idxs) = limit;

[cloud.x,cloud.y,cloud.z]=sph2cart(cloud.azimuth,cloud.elevation,cloud.radius);

end

