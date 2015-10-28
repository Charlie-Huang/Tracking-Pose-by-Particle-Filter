function makevideo( imageDir )
%MAKEVIDEO Summary of this function goes here
%   Detailed explanation goes here
imlist = dir(fullfile(imageDir,'*.jpg'));

% sort the order of the frames
imnumlist=zeros(1,length(imlist));
for i=1:length(imlist)
    imnumlist(i)=str2double(imlist(i).name(1:end-4));
end
imnumlist=sort(imnumlist);

outputVideo = VideoWriter(fullfile(imageDir,'tracking_results.avi'));
outputVideo.FrameRate = 1;
open(outputVideo);

for ii = 1:length(imnumlist)
   img = imread(fullfile(imageDir,[num2str(imnumlist(ii)) '.jpg']));
   writeVideo(outputVideo,img);
end

close(outputVideo);
end

