function [ centers ] = rejectArtefacts( centers,limit, verbose )
%REJECTARTEFACTS Summary of this function goes here
%   Detailed explanation goes here

fns = fieldnames(centers);
for fn_idx = 1:length(fns)
    fn = fns{fn_idx};
    centers.(fn).radius(isnan(centers.(fn).radius)) = 100;
    center_idx = 0;
    while center_idx < length(centers.(fn).x)
        center_idx = center_idx + 1;
        radius = centers.(fn).radius(center_idx);
        if radius > limit - 10
            num_neigbours = 5;
            x_neighbours = zeros(num_neigbours*2,1);
            y_neighbours = zeros(num_neigbours*2,1);
            pred_idx = center_idx;
            suc_idx = center_idx;
            for num_neigbour = 1:num_neigbours
                [pred_idx,~] = getNextBelowLimit(centers.(fn),pred_idx,length(centers.(fn).x),limit,-1);
                [suc_idx,~] = getNextBelowLimit(centers.(fn),suc_idx,length(centers.(fn).x),limit,1);
                
                x_neighbours(num_neigbour*2-1) = centers.(fn).x(pred_idx);
                x_neighbours(num_neigbour*2) = centers.(fn).x(suc_idx);
                
                y_neighbours(num_neigbour*2-1) = centers.(fn).y(pred_idx);
                y_neighbours(num_neigbour*2) = centers.(fn).y(suc_idx);
            end
            
            [r,m,b] = regression(x_neighbours',y_neighbours');
            x = centers.(fn).x(center_idx);
            y = centers.(fn).y(center_idx);
            residuals = mean(abs((m*x_neighbours+b)-y_neighbours));
            if verbose
                plot_isovist(centers.(fn));
                hold on
                plot(x,y,'ro')
                plot(x_neighbours,y_neighbours,'rx');
                plot([-100,100],[-100,100]*m+b,'r')
                hold off
                fprintf('Residual: %2.2f\n',residuals)
                waitforbuttonpress;
            end
            if residuals < 0.5
                if abs(x*m+b - y) > 10
                    centers.(fn).x(center_idx) = [];
                    centers.(fn).y(center_idx) = [];
                    centers.(fn).radius(center_idx) = [];
                    center_idx = center_idx - 1;
                end
                continue
            end
            [~,predecessor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit,-1);
            [~,successor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit,1);
            if predecessor_radius < 5 || successor_radius < 5
                centers.(fn).x(center_idx) = [];
                centers.(fn).y(center_idx) = [];
                centers.(fn).radius(center_idx) = [];
                center_idx = center_idx - 1;
            elseif center_idx == 1
                border_idx = find(centers.(fn).radius~=100,1,'last');
                predecessor_radius = centers.(fn).radius(border_idx);
                if predecessor_radius < 10
                    centers.(fn).x(center_idx) = [];
                    centers.(fn).y(center_idx) = [];
                    centers.(fn).radius(center_idx) = [];
                    center_idx = center_idx - 1;
                end
            end
        end
    end
end
end

