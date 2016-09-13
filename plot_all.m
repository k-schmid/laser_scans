clear 
close all
clc
for layer = 8
    disp(int2str(layer))
for i=12
    clouds_path = ['/pfs/data2/home/fr/fr_fr/fr_ks414/Documents/Kreuzungen/' int2str(i) '/'];
    plot_intersection(clouds_path,layer);
    filename =[int2str(layer) '/Isovists ',int2str(i),'.png'];
    set(gcf, 'Position', get(0, 'Screensize'));
    mkdir(int2str(layer))
    export_fig(filename,'-m3')
end
end