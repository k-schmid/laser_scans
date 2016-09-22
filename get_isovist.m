function [ centers ] = get_isovist( num_bins,cloud,scale,layer_of_interest )

if nargin < 5
    center_stat = 'mean';
end


%%




angle_diff = 2*pi / num_bins;

centers.median.x = [];
centers.median.y = [];
centers.mode.x = [];
centers.mode.y = [];
centers.mean.x = [];
centers.mean.y = [];


data_point_bools =ones(16,size(cloud.x(layer_of_interest,:),2));

for bin = 1:num_bins
    fprintf('Bin: %d\n',bin)
    current_cluster = [];
    current_angle = (bin-1)*angle_diff;
    [x_ray,y_ray]=pol2cart(current_angle,60);
    ray = [x_ray,y_ray];
    %     continue
    infinity = false;
    removed_data_points = [];
    for layer = layer_of_interest-1:layer_of_interest+1
        x = squeeze(cloud.x(layer,:));
        y = squeeze(cloud.y(layer,:));
        z = squeeze(cloud.z(layer,:));
        %         azimuth = squeeze(cloud.azimuth(layer,:));
        radius = squeeze(cloud.radius(layer,:));
        data_point_idx = 1:size(x,2);
        data_point_idx = data_point_idx(logical(data_point_bools(layer,:)));
        fprintf('Num data points: %d\n',length(data_point_idx))
        for data_point =data_point_idx
            if isnan(radius(data_point))
                %                 infinity = true;
                data_point_bools(layer,data_point) = 0;
                continue
            end
            
            data_point_coord = [x(data_point),y(data_point)];
            
            angle = acos( dot(data_point_coord,ray) / (norm(data_point_coord) * norm(ray)) );
            %             angle = subspace(ray,data_point_coord);
            
            %             angle = azimuth(data_point);
            if abs(angle) > angle_diff/2 * scale
                continue
            end
            
            current_cluster(end+1,:) = [x(data_point),y(data_point)];
            data_point_bools(layer,data_point) = 0;
        end
        %         cloud.azimuth(layer,removed_data_points) = [];
        %         cloud.x(layer,removed_data_points) = [];
        %         cloud.y(layer,removed_data_points) = [];
        %         cloud.radius(layer,removed_data_points) = [];
        if isempty(current_cluster)
            if infinity
                %             [x_centers(bin),y_centers(bin)] = pol2cart(current_angle-pi,100);
                
            else
                %                             disp('>>>> WARNING: Neither inf nor sth else')
            end
        else
            
            cluster_center = mode(current_cluster,1);
            centers.mode.x(end+1) = cluster_center(1);
            centers.mode.y(end+1) = cluster_center(2);
            
            cluster_center = mean(current_cluster,1);
            centers.mean.x(end+1) = cluster_center(1);
            centers.mean.y(end+1) = cluster_center(2);
            
            cluster_center = median(current_cluster,1);
            centers.median.x(end+1) = cluster_center(1);
            centers.median.y(end+1) = cluster_center(2);
            
            
            
            
        end
        
    end
end

end

