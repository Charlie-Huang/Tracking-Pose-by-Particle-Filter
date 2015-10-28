function [ particles ] = generateParticles( mu ,N,size_im)
%GENERATEPARTICLES Summary of this function goes here
%   Detailed explanation goes here
particles=zeros(2,N);
for i=1:N
    particles(:,i)=normrnd(mu,[20 20]);
    if particles(1,i)>=size_im(2)
        particles(1,i)= size_im(2)-abs(normrnd(0,5));
    end
    
    if particles(2,i)>=size_im(1)
        particles(2,i)= size_im(1)-abs(normrnd(0,5));
    end
end

end

