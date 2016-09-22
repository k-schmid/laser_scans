function [ centers ] = get_isovist( num_bins,cloud,scale,layer_of_interest )
warning('off','MATLAB:mode:EmptyInput');
angle_diff = 2*pi / num_bins;

layers = layer_of_interest-1:layer_of_interest+1;

bins = cell(num_bins,2);
for layer = layers
    
    for datapoint = 1:size(cloud.x(layer,:),2)
        if isnan(cloud.radius(layer,datapoint))
            continue
        end
        angle_datapoint = cloud.azimuth(layer,datapoint);
        
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

