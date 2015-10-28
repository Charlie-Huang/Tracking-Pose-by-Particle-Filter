function showcenters( im,centers )
%SHOWCENTERS Summary of this function goes here
%   Detailed explanation goes here
colorset = {'g','g','y','m','m','m','m','y','y','y','y','c','c','c','c','y','y','y'};
im_marker=insertMarker(im,centers','x','color',colorset,'size',3);
figure;
imshow(im_marker);
end

