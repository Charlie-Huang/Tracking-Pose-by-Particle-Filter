function showParticles( im,particles,color )
%SHOWPARTICLES Summary of this function goes here
%   Detailed explanation goes here
figure;
im_marker=insertMarker(im,particles','o','color',color,'size',3);
imshow(im_marker);
end

