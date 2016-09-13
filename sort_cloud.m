function [ cloud ] = sort_cloud(cloud)

cloud.azimuth = mod(cloud.azimuth, 2*pi);
[~,idx] = sort(cloud.azimuth(7,:));

cloud.x = cloud.x(:,idx);
cloud.y = cloud.y(:,idx);
cloud.z = cloud.z(:,idx);
cloud.elevation = cloud.elevation(:,idx);
cloud.azimuth = cloud.azimuth(:,idx);
cloud.radius = cloud.radius(:,idx);
end