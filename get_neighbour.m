function [ idx_neighbour ] = get_neighbour( idx,shift,size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

idx_neighbour = idx + shift;

if idx_neighbour > size
    idx_neighbour = idx_neighbour - size;
end
if idx_neighbour <= 0
    idx_neighbour = size + idx_neighbour;
end

end