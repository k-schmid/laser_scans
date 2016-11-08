function [  ] = plot_isovist( centers )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    plot(centers.x,centers.y,'Marker','.','Color','black')
    hold on
    plot([centers.x(end),centers.x(1)],[centers.y(end),centers.y(1)],'Marker','.','MarkerSize',1,'Color','black')
    plot(0,0,'Marker','x','MarkerSize',5,'Color','r')
%     axis off
    axis equal
    xlim([-105,105])
    ylim([-105,105])
    set(gca, 'XTickLabel','','YTickLabel','');
    hold off
    drawnow()

end

