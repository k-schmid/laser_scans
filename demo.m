% clear, close all,clc
% path = '../intersection1/';
path = 'E:\Konsi\Kreuzungen\1\1\';
file_list = dir([path,'*.pcd']);

clouds = [];
for i = 1:10%length(file_list)
    file = file_list(i);
    cloud = loadpcd([path,file.name]);
    clouds= cat(2,clouds,cloud(:,:,1:3));
end
%%
layer = 8;
[angle,dist]=cart2pol_interpolated(clouds(layer,:,1),clouds(layer,:,2),0.0067);

[~,idx]=sort(angle);
clouds = clouds(:,idx,:);

%% Scatter all Data
% figure(1)
% 
% scatter(clouds(layer,:,1),clouds(layer,:,2),2,'r','filled')
% title(['Scatter all Data Layer',int2str(layer)])
% axis equal
% axis off
% pause(1)

%% Plot cluster centers
% figure(2)
% clusters = get_isovist(360,clouds,0.1,8);
% scatter(clusters(:,1),clusters(:,2),2,'r','filled')
% title('Scatter cluster centers')
% axis equal
% axis off
% figure(3)
% plot(clusters(:,1),clusters(:,2), 'Marker','.')
% title('Plot cluster centers')
% axis equal
% axis off
%% Plot 1D Isovist (1 cloud/ Inf removed)
% figure(4)
% cloud(:,cloud(layer,:,1)==Inf,:)=[];
% cloud(:,cloud(layer,:,2)==Inf,:)=[];
% [angle,dist]= cart2pol(double(cloud(layer,:,1)),double(cloud(layer,:,2)));
% plot([angle,dist],'r')
% title('Plot 1D Isovist (1 cloud/ Inf removed)')

%% Plot all clouds (sorted/filtered)
% figure(1)
% 
% n=30;
% clouds_filtered(:,1) = medfilt1(clouds(layer,:,1),n);
% clouds_filtered(:,2) = medfilt1(clouds(layer,:,2),n);
% clouds_filtered(:,3) = medfilt1(clouds(layer,:,3),n);
% clouds_array = mean(clouds_array,4);
% plot(clouds_filtered(:,1),clouds_filtered(:,2), 'Marker','.')
% title('Plot all clouds (sorted)')
% axis equal
% axis off
figure(2)
i=0;
for degree=300:25:500
    
    i=i+1;
    figure(2)
    subplot(3,3,i)
    clusters = get_isovist(degree,clouds,1,7);
    scatter(clusters(:,1),clusters(:,2),2,'r','filled')
    % title('Scatter cluster centers')
    title(num2str(degree))
    axis equal
    axis off
    figure(3)
    subplot(3,3,i)
    plot(clusters(:,1),clusters(:,2), 'Marker','.')
    % title('Plot cluster centers')
    title(num2str(degree))
    axis equal
    axis off
end
%% 1D isovist all clouds
% figure(6)
% % [angle,dist]=cart2pol(clouds(layer,:,1),clouds(layer,:,2));
% plot([angle,dist],'r')
% title('1D isovist all clouds')

%% Plot mean of clouds
% figure(7)
% clouds_array = mean(clouds_array,4);
% plot(clouds_array(layer,:,1),clouds_array(layer,:,2))
% title('Plot mean of clouds')
% axis equal
% axis off

%%
figure
[x,y] = pol2cart(angle,dist);
plot(x,y, 'Marker','.')
% scatter(x,y)
title('Plot cloud')
axis equal
axis off
%%
figure
for neighbours = 9
[x,y] = pol2cart(angle,dist);
for i = 1:length(dist)
    distance = dist(:,i);
    if distance == 100
        [isoutlier,x_mean,y_mean] = outlierCheck(dist,i,neighbours,100,x,y);
        if isoutlier
            x(i) = x_mean;
            y(i) = y_mean;
        end
    end
end
% subplot(3,3,neighbours)
plot(x,y, 'Marker','.')
% scatter(x,y)
title(['Neighbour check ',num2str(neighbours)])
axis equal
axis off
end
%%
% figure
% x_res = reshape(x,960,10);
% y_res = reshape(y,960,10);
% plot(mean(x_res,2),mean(y_res,2), 'Marker','.')
% % scatter(x,y)
% title('Plot cloud')
% axis equal
% axis off