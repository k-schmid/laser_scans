clear 
close all
clc
layer = 8;
for intersections=1:22
    clouds_path = ['/pfs/data2/home/fr/fr_fr/fr_ks414/Documents/Kreuzungen/' int2str(intersections) '/'];
    plot_intersection(clouds_path,layer);
    path = ['mean' ];
    filename =['/Isovists ',int2str(intersections),'.png'];
    set(gcf, 'Position', get(0, 'Screensize'));
    mkdir(path)
    export_fig([path,filename],'-m3')
end
