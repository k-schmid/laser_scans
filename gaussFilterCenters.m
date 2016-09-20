function [ data ] = gaussFilterCenters( data,window_length )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Construct blurring window.
windowWidth = int16(window_length);
halfWidth = windowWidth / 2;
gaussFilter = gausswin(window_length);
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.

% Do the blur.
data.x = conv(data.x, gaussFilter);
data.y = conv(data.y, gaussFilter);
end

