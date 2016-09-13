clear 
close all
clc
for layer = 10:16
    disp(int2str(layer))
parfor intersections=1:22
    clouds_path = ['/pfs/data2/home/fr/fr_fr/fr_ks414/Documents/Kreuzungen/' int2str(intersections) '/'];
    plot_intersection(clouds_path,layer);
    filename =['mean/',int2str(layer) '/Isovists ',int2str(intersections),'.png'];
    set(gcf, 'Position', get(0, 'Screensize'));
    mkdir(['mean/',int2str(layer)])
    export_fig(filename,'-m3')
end
end