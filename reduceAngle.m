function [cloud] = reduceAngle(cloud,viewing_angle, layer_of_interest)
%[ cloud ] = reduceAngle( cloud, viewing_angle, layers_of_interest)
%Rejects outlier
%
%   Input:
%       cloud               -   The sorted cloud data with three dimensions
%                               (x,y,z)
%       viewing_angle       -   Angle to be used [min,max]
%
%   Output:
%       cloud           -   cloud with reduced data
%

rejected_idx = [];
for i = 1:length(cloud.azimuth)
   if any(cloud.azimuth(layer_of_interest,i) >= viewing_angle(:,1) & cloud.azimuth(layer_of_interest,i) <= viewing_angle(:,2))
       rem=true;
   else
       rejected_idx = [rejected_idx,i];
   end
end
cloud.azimuth(:,rejected_idx) = [];
cloud.x(:,rejected_idx) = [];
cloud.y(:,rejected_idx) = [];
cloud.z(:,rejected_idx) = [];
cloud.elevation(:,rejected_idx) = [];
cloud.radius(:,rejected_idx) = [];

