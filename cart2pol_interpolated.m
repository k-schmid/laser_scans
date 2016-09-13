function [ angle,dist ] = cart2pol_interpolated( cloud_x,cloud_y,angle_inc )
cloud_x = squeeze(cloud_x);
cloud_y = squeeze(cloud_y);

angle = zeros(size(cloud_x,1),1);
dist = zeros(size(cloud_x,1),1);

for i = 1:length(cloud_x)
    x = cloud_x(i);
    y = cloud_y(i);
    if (x == Inf) | (y == Inf)
        angle(i) = (angle(i-1)-angle_inc);
        if angle(i) < -pi
            angle(i) = pi; 
        end
        dist(i) = 100;
    else
        [angle(i),dist(i)] = cart2pol(x,y);
    end
end

end

