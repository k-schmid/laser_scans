clear
close all
clc

warning('off','MATLAB:prnRenderer:opengl');
warning off MATLAB:MKDIR:DirectoryExists
%% default settings
plot_path = '../Evaluation/';
layer = 8;
rangeLimit = 100;
precision = 0;
viewing_angle = [deg2rad(0),deg2rad(360)];
outlier_range = deg2rad(5);
center_statistics = 'median';
num_bins = 180;
reload = false;

for intersections = 1:22
    clouds_path = ['../data/' int2str(intersections) '/'];
    fprintf('Intersection %d\n',intersections)

    %% center_stat
    path = [plot_path,'center_statistics/'];
    center_stats = {'median','mean','mode'};
    
    for i = 1:length(center_stats)
        center_statistics_ = center_stats{i};
        if i == 1
            plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle,precision,center_statistics_,num_bins,reload);
        else
            plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle,precision,center_statistics_,num_bins,true);
        end
        filename =sprintf('Isovists %d_%d bins_%s.png',intersections,num_bins,center_statistics_);
        set(gcf, 'Position', get(0, 'Screensize'));
        mkdir(path)
        export_fig([path,filename],'-pdf','-m3','-transparent')
    end
    
    %% num_bins
    path = [plot_path,'num_bins/'];
    for num_bins_ = 100:40:360
        plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle,precision,center_statistics,num_bins_,reload);
        
        filename =sprintf('Isovists %d_%d bins_%s.png',intersections,num_bins_,center_statistics);
        set(gcf, 'Position', get(0, 'Screensize'));
        mkdir(path)
        export_fig([path,filename],'-pdf','-m3','-transparent')
    end
    
    
    %% viewing_angle
    path = [plot_path,'viewing_angle_new/'];
    
    for angle = 120:10:360
        viewing_angle_ = [deg2rad(0),deg2rad(angle/2);deg2rad(360-(angle/2)),deg2rad(360)];
        plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle_,precision,center_statistics,num_bins,reload);
        
        filename =sprintf('Isovists %d_%d bins_%s_angle %d.png',intersections,num_bins,center_statistics,angle);
        set(gcf, 'Position', get(0, 'Screensize'));
        mkdir(path)
        export_fig([path,filename],'-pdf','-m3','-transparent')
    end
    
end