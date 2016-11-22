function [ centers ] = rejectArtefacts( centers,limit, verbose,center_statistics )
%REJECTARTEFACTS Summary of this function goes here
%   Detailed explanation goes here


fns = fieldnames(centers);

figure(1000)
fns = fieldnames(centers);
for fn_idx = 1:length(fns)
    fn = fns{fn_idx};
    centers.(fn).radius(isnan(centers.(fn).radius)) = 100;
    center_idx = 0;
    while center_idx < length(centers.(fn).x)
        center_idx = center_idx + 1;
        radius = centers.(fn).radius(center_idx);
        if radius > limit - 30
            num_neigbours = 5;
            x_neighbours = zeros(num_neigbours*2,1);
            y_neighbours = zeros(num_neigbours*2,1);
            pred_idx = center_idx;
            suc_idx = center_idx;
            predecessors = [];
            successors = [];
            for num_neigbour = 1:num_neigbours
                [pred_idx,~] = getNextBelowLimit(centers.(fn),pred_idx,length(centers.(fn).x),limit-50,-1);
                [suc_idx,~] = getNextBelowLimit(centers.(fn),suc_idx,length(centers.(fn).x),limit-50,1);
                predecessors = [predecessors , pred_idx];
                successors = [successors , suc_idx];
                x_neighbours(num_neigbour*2-1) = centers.(fn).x(pred_idx);
                x_neighbours(num_neigbour*2) = centers.(fn).x(suc_idx);
                
                y_neighbours(num_neigbour*2-1) = centers.(fn).y(pred_idx);
                y_neighbours(num_neigbour*2) = centers.(fn).y(suc_idx);
            end
            
            [~,m,b] = regression(x_neighbours',y_neighbours');
            x = centers.(fn).x(center_idx);
            y = centers.(fn).y(center_idx);
            residuals = mean(abs((m*x_neighbours+b)-y_neighbours));
            if verbose && isequal(center_statistics,fn)
                plot_isovist(centers.(fn));
                hold on
                if residuals < 0.5
                    plot(x,y,'ro')
                    plot(x_neighbours,y_neighbours,'rx');
                    plot([-100,100],[-100,100]*m+b,'r')
                    hold off
                    fprintf('Residual: %2.2f\n',residuals)
                    waitforbuttonpress;
                else
                    plot(x,y,'go')
                    plot(x_neighbours,y_neighbours,'rx');
                    plot([-100,100],[-100,100]*m+b,'r')
                    hold off
                    fprintf('Residual: %2.2f\n',residuals)
%                     pause(0.1)
                end
                
            end
            if residuals < 0.5
                if abs(x*m+b - y) > 10
                    lower_border = max(predecessors);
                    upper_border = min(successors);
                    
                    azimuth_lower = cart2pol(centers.(fn).x(lower_border),centers.(fn).y(lower_border));
                    azimuth_upper = cart2pol(centers.(fn).x(upper_border),centers.(fn).y(upper_border));
                    
                    x_lower = centers.(fn).x(lower_border);
                    x_upper = centers.(fn).x(upper_border);
                    y_lower = centers.(fn).y(lower_border);
                    y_upper = centers.(fn).y(upper_border);
                    
                    x_step = (x_upper-x_lower)/(upper_border-lower_border);
                    xs = x_lower+x_step:x_step:(x_upper-x_step);
                    
                    ys = xs*m+b;
                    
                    
                    idxs = lower_border+1:upper_border-1;
                    
                    centers.(fn).x(idxs) = xs;
                    centers.(fn).y(idxs) = ys;
                    [~,r]=cart2pol(centers.(fn).x(idxs),centers.(fn).y(idxs));
                    centers.(fn).radius(idxs) = r;
                    if verbose && isequal(center_statistics,fn)
                        plot_isovist(centers.(fn));
                        hold on
                        
                        plot(xs,ys,'gx')
                        plot(x_neighbours,y_neighbours,'rx');
                        plot([-100,100],[-100,100]*m+b,'r')
                        hold off
                        fprintf('Residual: %2.2f\n',residuals)
                        waitforbuttonpress
                        
                    end
                end
                continue
            end
            [~,predecessor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit-10,-1);
            [~,successor_radius] = getNextBelowLimit(centers.(fn),center_idx,length(centers.(fn).x),limit-10,1);
            if predecessor_radius < 5 || successor_radius < 5
                
                azimuth = cart2pol(centers.(fn).x(center_idx),centers.(fn).y(center_idx));
                centers.(fn).radius(center_idx) = mean([predecessor_radius,successor_radius]);
                x = centers.(fn).x(center_idx);
                y = centers.(fn).y(center_idx);
                if verbose && isequal(center_statistics,fn)
                    plot_isovist(centers.(fn));
                    hold on
                    plot(x,y,'ro')
                    plot(x_neighbours,y_neighbours,'rx');
                    plot([-100,100],[-100,100]*m+b,'r')
                    hold off
                    fprintf('Residual: %2.2f\n',residuals)
                    waitforbuttonpress;
                end
                [x,y] = pol2cart(azimuth,centers.(fn).radius(center_idx));
                centers.(fn).x(center_idx) = x;
                centers.(fn).y(center_idx) = y;
                if verbose && isequal(center_statistics,fn)
                    plot_isovist(centers.(fn));
                    hold on
                    plot(x,y,'gx')
                    plot(x_neighbours,y_neighbours,'rx');
                    plot([-100,100],[-100,100]*m+b,'r')
                    hold off
                    fprintf('Residual: %2.2f\n',residuals)
                    waitforbuttonpress;
                end
            end
        end
    end
end
end

