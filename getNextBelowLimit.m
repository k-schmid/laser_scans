function [ successor_idx,successor_radius ] = getNextBelowLimit(centers,idx,size,limit,direction )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
found = false;

while not(found)
   successor_idx = get_neighbour(idx,direction,size); 
   idx = successor_idx;
   successor_radius = centers.radius(successor_idx);
   if successor_radius < (limit - 10)
       return
   end
end

end

