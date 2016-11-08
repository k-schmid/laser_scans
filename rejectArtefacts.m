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
            
            [predecessor_idx,predecessor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit,-1);
            [successor_idx,successor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit,1);
            sucsuccessor_idx = get_neighbour(successor_idx,1,length(centers.(fn).x));
            prepredecessor_idx = get_neighbour(predecessor_idx,-1,length(centers.(fn).x));
            
            x_neighbours=[centers.(fn).x(prepredecessor_idx),...
                centers.(fn).x(predecessor_idx),...
                centers.(fn).x(successor_idx),...
                centers.(fn).x(sucsuccessor_idx)];
            y_neighbours=[centers.(fn).y(prepredecessor_idx),...
                centers.(fn).y(predecessor_idx),...
                centers.(fn).y(successor_idx),...
                centers.(fn).y(sucsuccessor_idx)];
            
            [r,m,b] = regression(x_neighbours,y_neighbours);
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
            if residuals > 0.5
                continue
            else
                if abs(x*m+b - y) > 10
                    centers.(fn).x(center_idx) = [];
                    centers.(fn).y(center_idx) = [];
                    centers.(fn).radius(center_idx) = [];
                    center_idx = center_idx - 1;
                end
                continue
            end
            if predecessor_radius < 10 || successor_radius < 10
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

