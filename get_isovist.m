function [ centers ] = get_isovist( num_bins,cloud,scale,layer_of_interest, outlier_range, limit)
warning('off','MATLAB:mode:EmptyInput');
angle_diff = 2*pi / num_bins;

layers = layer_of_interest-1:layer_of_interest+1;

bins = cell(num_bins,2);
for layer = layers
    nan_found = false;
    datapoint = 0;
    while datapoint < size(cloud.x(layer,:),2)
        datapoint= datapoint + 1;
        angle_datapoint = cloud.azimuth(layer,datapoint);
        
        if isnan(cloud.radius(layer,datapoint))
            
            if ~nan_found
                nan_found = true;
                start_angle = angle_datapoint;
                start_idx = datapoint;
            else                
%                 fprintf('%f\n',abs(start_angle - angle_datapoint))
                if abs(start_angle - angle_datapoint) > outlier_range                   
                    n = find(not(isnan([cloud.radius(layer,datapoint:end) , cloud.radius(layer,1:datapoint-1)])),1);
                    if datapoint+n-2 > size(cloud.radius(layer,:),2)
                        cloud.radius(layer,start_idx:end) = limit;
                        [x,y] = pol2cart(cloud.azimuth(layer,start_idx:end),cloud.radius(layer,start_idx:end));
                        cloud.x(layer,start_idx:end)=x;
                        cloud.y(layer,start_idx:end)=y;

                        n = datapoint+n-2 - size(cloud.radius(layer,:),2);
                        cloud.radius(layer,1:n) = limit;
                        [x,y] = pol2cart(cloud.azimuth(layer,1:n),cloud.radius(layer,1:n));
                        cloud.x(layer,1:n)=x;
                        cloud.y(layer,1:n)=y;
                    else
                        cloud.radius(layer,start_idx:datapoint+n-2) = limit;
                        [x,y] = pol2cart(cloud.azimuth(layer,start_idx:datapoint+n-2),cloud.radius(layer,start_idx:datapoint+n-2));
                        cloud.x(layer,start_idx:datapoint+n-2)=x;
                        cloud.y(layer,start_idx:datapoint+n-2)=y;
                        
                    end
                    datapoint = start_idx;
                end
            end
                continue;
        end
        nan_found = false;
        
        closest_bin = round(angle_datapoint/(2*pi) * num_bins);
        if closest_bin == 0
            closest_bin = num_bins;
        end
        
        angle_bin = closest_bin*angle_diff;
        angle = abs(angle_bin-angle_datapoint);
        
        if abs(angle) > angle_diff/2 * scale
            continue
        end
        
        bins{closest_bin,1} = [bins{closest_bin,1} , cloud.x(layer,datapoint)];
        bins{closest_bin,2} = [bins{closest_bin,2} , cloud.y(layer,datapoint)];
    end
    
end
averages = cellfun(@median, bins,'UniformOutput',false);
nans = cell2mat(cellfun(@(V) any(isnan(V(:))), averages,'UniformOutput',false));
averages(nans(:,1),:) = [];
averages = cell2mat(averages);
centers.median.x = averages(:,1);
centers.median.y = averages(:,2);

averages = cellfun(@mode, bins,'UniformOutput',false);
nans = cell2mat(cellfun(@(V) any(isnan(V(:))), averages,'UniformOutput',false));
averages(nans(:,1),:) = [];
averages = cell2mat(averages);
centers.mode.x = averages(:,1);
centers.mode.y = averages(:,2);

averages = cellfun(@mean, bins,'UniformOutput',false);
nans = cell2mat(cellfun(@(V) any(isnan(V(:))), averages,'UniformOutput',false));
averages(nans(:,1),:) = [];
averages = cell2mat(averages);
centers.mean.x = averages(:,1);
centers.mean.y = averages(:,2);
end

