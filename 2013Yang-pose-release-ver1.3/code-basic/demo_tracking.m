addpath visualization;
addpath tracking;
addpath tracking/OpticalFlow;
addpath tracking/OpticalFlow/mex;
if isunix()
  addpath mex_unix;
elseif ispc()
  addpath mex_pc;
end

compile;

sigm=5;% the parameter to measure Gaussian distance
sigm_motion=3;
N=1000;%number of particles

% load and display model
load('BUFFY_model');
numparts=18;


% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% sort the order of the frames
imlist = dir('images/*.jpg');
imnumlist=zeros(1,length(imlist));
for i=1:length(imlist)
    imnumlist(i)=str2double(imlist(i).name(1:end-4));
end
imnumlist=sort(imnumlist);

% inilization of the tracking
im_t = imread(['images/' num2str(imnumlist(1)) '.jpg']);
boxes = detect_fast(im_t, model, min(model.thresh,-1));
boxes = nms(boxes, .1); % nonmaximal suppression
boxes = boxes(1,:);%select the best one
centers = centerpoints( boxes,numparts );
point = centers(:,7);%???7????????
size_im=size(im_t);
particles = generateParticles(point',N,size_im(1:2));
%showParticles(im_t,particles,'r');%display the particles


%start tracking
for i = 2:length(imnumlist)
    
    tic;
    
    % load and display image
    im_tplus1 = imread(['images/' num2str(imnumlist(i)) '.jpg']);

    % Calculate Optical Flow
    im1 = im2double(im_t);
    im2 = im2double(im_tplus1);
    [vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
    
    % Motion stage
    int_particles=round(particles);
    particles_motion=zeros(2,N);
    
    for j=1:N
        
        particles_motion(1,j) = particles(1,j) + vx(int_particles(2,j),int_particles(1,j))+normrnd(0,sigm_motion);
        if particles_motion(1,j)>=size(im2,2)
            particles_motion(1,j)= size(im2,2)-abs(normrnd(0,sigm_motion));
        end
        
        particles_motion(2,j) = particles(2,j) + vy(int_particles(2,j),int_particles(1,j))+normrnd(0,sigm_motion);
        if particles_motion(2,j)>=size(im2,1)
            particles_motion(2,j)= size(im2,1)-abs(normrnd(0,sigm_motion));
        end
    end
    %showParticles(im_tplus1,particles_motion,'r'); %display the particles after motion
    
    
    %Measurement stage
    
    
    % weight

    boxes = detect_fast(im_tplus1, model, min(model.thresh,-1));% call detect function
    boxes = nms(boxes, .1); % nonmaximal suppression
    boxes = boxes(1,:);
    
    centers = centerpoints( boxes,numparts );
    point_detect = centers(:,7);%???7????????
    weight=exp(-((particles_motion(1,:)-point_detect(1)).^2+(particles_motion(2,:)-point_detect(2)).^2)/2/(sigm^2));
    weight=weight./sum(weight);
    point_tracking = [weight*particles_motion(1,:)'; weight*particles_motion(2,:)']; % new location of the joint
    
    
    % resample
    
    for k = 1 : N  
        particles(:,k) = particles_motion(:,find(rand <= cumsum(weight),1));   
    end                                                    
    im_t=im_tplus1;
    
    dettime = toc;
    fprintf(['Frame ' num2str(imnumlist(i)) 'detection and tracking took %.1f seconds\n'],dettime);
    
    %display the particles after measurement stage
%     showParticles(im_t,particles,'r');
    
    % contrast the locations of the joint
    im_marker=insertMarker(im_t,particles','o','color','blue','size',3);
    im_marker=insertMarker(im_marker,[point_detect point_tracking]','+','color',{'y','r'},'size',6); %red is the new one
    
      
    imwrite(im_marker,['tracking/Output/' num2str(imnumlist(i)) '.jpg']);
    
%     figure;
%     imshow(im_marker);
%     disp('press any key to continue');
%     pause;
end

disp('done');
