function [heatMap] = plotCloudHeatMap( unsorted_cloud, resolution_factor )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

unsorted_cloud.x = reshape(unsorted_cloud.x,16,960,[]);
unsorted_cloud.y = reshape(unsorted_cloud.y,16,960,[]);
unsorted_cloud.radius = reshape(unsorted_cloud.radius,16,960,[]);
unsorted_cloud.azimuth = reshape(unsorted_cloud.azimuth,16,960,[]);
heatMap = zeros(200*resolution_factor);
for scan = 1:size(unsorted_cloud.x,3)
    unsorted_cloud.radius(7,isnan(unsorted_cloud.radius(7,:,scan)),scan) = 100;
    [x,y] = pol2cart(unsorted_cloud.azimuth(7,:,scan),unsorted_cloud.radius(7,:,scan));
    mask = poly2mask(double(x+100)*resolution_factor, double(y+100)*resolution_factor, 200 * resolution_factor,200 * resolution_factor);
    heatMap = heatMap + mask;
end
end

