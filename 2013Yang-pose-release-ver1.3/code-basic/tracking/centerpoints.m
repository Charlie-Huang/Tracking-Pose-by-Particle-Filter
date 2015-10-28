function [ centers ] = centerpoints( boxes,numparts )
%CENTREPOINTS Summary of this function goes here
%   Detailed explanation goes here
box = boxes(:,1:4*numparts);
xy= reshape(box,size(box,1),4,numparts);
xy = permute(xy,[1 3 2]);
x=(1/2)*(xy(:,:,1)+xy(:,:,3));
y=(1/2)*(xy(:,:,2)+xy(:,:,4));
centers=[x;y];
end
