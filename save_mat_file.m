function [  ] = save_mat_file( centers,cloud,subFolderPath,layer_of_interest )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        save(sprintf('%s/cloud_preprocessed_%d.mat',subFolderPath,layer_of_interest),'centers','cloud')


end

