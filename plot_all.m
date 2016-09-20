clear
close all
clc
layer = 8;
viewing_angle = [deg2rad(0),deg2rad(90);deg2rad(270),deg2rad(360)];

outlier_range = deg2rad(3);

rangeLimit = 60;

for intersections=2
    clouds_path = ['data/' int2str(intersections) '/'];
    plot_intersection(clouds_path,layer,outlier_range, rangeLimit, viewing_angle);
    path = ['mean' ];
    filename =['/Isovists ',int2str(intersections),'.png'];
    set(gcf, 'Position', get(0, 'Screensize'));
    mkdir(path)
    export_fig([path,filename],'-m3')
end
