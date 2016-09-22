plot_path = '../Evaluation/';
clear
close all
clc

%% default settings
layer = 8;
rangeLimit = 60;
precision = 0;
viewing_angle = [deg2rad(0),deg2rad(90);deg2rad(270),deg2rad(360)];
outlier_range = deg2rad(3);
center_statistics = 'median';
num_bins = 180;
reload = false;

parfor intersections = 1:21
    clouds_path = ['../data/' int2str(intersections) '/'];
    
    %% center_stat
    path = 'center_statistic/';
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
        export_fig([plot_path,path,filename],'-m3')
    end
    
    %% num_bins
    path = 'num_bins/';
    for num_bins_ = 100:40:360
        plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle,precision,center_statistics,num_bins_,reload);
        
        filename =sprintf('Isovists %d_%d bins_%s.png',intersections,num_bins_,center_statistics);
        set(gcf, 'Position', get(0, 'Screensize'));
        mkdir(path)
        export_fig([plot_path,path,filename],'-m3')
    end
    
end