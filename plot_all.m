clear all
close all
clc
layer = 8;
rangeLimit = 100;
precision = 0;
viewing_angle = [deg2rad(0),deg2rad(360)];% [deg2rad(0),deg2rad(90);deg2rad(270),deg2rad(360)];
outlier_range = deg2rad(15);
center_statistics = 'median';
num_bins = 180;
reload = false;
plot_path = '../Evaluation/';
addpath('..');
addpath('../../tools/')
data_path = get_dataPath();
parfor intersections=1:12%:22
    clouds_path = [data_path int2str(intersections) '/'];
    fprintf('Intersection %d\n',intersections)
    %% Defaults
    path = [plot_path,'current_isovists/'];
    plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle,precision,center_statistics,num_bins,reload,true);
    filename =sprintf('Isovists %d_%d bins_%s.png',intersections,num_bins,center_statistics);
    set(gcf, 'Position', get(0, 'Screensize'));
    mkdir(path)
    export_fig([path,filename],'-pdf','-m3','-transparent')
    
end


addpath('../iso_analysis/')
save_all_iso_stats();
