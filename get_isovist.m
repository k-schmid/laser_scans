function [ centers ] = get_isovist( num_bins,cloud,scale,layer,use_mode )

if nargin < 5
    use_mode = false;
end


%%

azimuth = squeeze(cloud.azimuth(layer,:));
x = squeeze(cloud.x(layer,:));
y = squeeze(cloud.y(layer,:));
radius = squeeze(cloud.radius(layer,:));


angle_diff = 2*pi / num_bins;
x_centers = zeros(num_bins,1);
y_centers = zeros(num_bins,1);

for bin = 1:num_bins
    current_cluster = [];
    current_angle = (bin-1)*angle_diff;
    infinity = false;
    removed_data_points = [];
    for data_point =1:size(x,2)
        %         if radius(layer,data_point) == 100
        %             infinity = true;
        %             continue
        %         end
        %         elevation_angle = atan2(z,sqrt(x^2+y^2));
        %         if abs(elevation_angle) > 2*pi/360*5
        %             continue
        %         end
        angle = azimuth(data_point);
        if abs(angle-current_angle) > angle_diff/2 * scale
            if abs(angle-2*pi - current_angle) > angle_diff/2 * scale
                continue
            end
        end
        
        current_cluster(end+1,:) = [x(data_point),y(data_point)];
        removed_data_points = [removed_data_points, data_point];
    end
    azimuth(removed_data_points) = [];
    x(removed_data_points) = [];
    y(removed_data_points) = [];
    radius(removed_data_points) = [];
    if isempty(current_cluster)
        if infinity
            [x_centers(bin),y_centers(bin)] = pol2cart(current_angle-pi,100);
            
        else
%             warning('Neither inf nor sth else')
        end
    else
        if use_mode
            cluster_center = mode(current_cluster,1);
            x_centers(bin) = cluster_center(1);
            y_centers(bin) = cluster_center(2);
            
        else
            cluster_center = mean(current_cluster,1);
            x_centers(bin) = cluster_center(1);
            y_centers(bin) = cluster_center(2);
        end
    end
    
end
centers.x = x_centers;
centers.y = y_centers;
end

