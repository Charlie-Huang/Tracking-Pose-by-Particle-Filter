function [ test1,test2,test3,test4,aug_num ] = data_augmentation( test0 )
%DATA_AUGMENTATION trys to generate images with a little changement
%   test0 is the origin image, test1 is the blurred image, test2 is the
%   brighted image, test3 is the resized image
    aug_num=4;
    test1=test0;test2=test0;test3=test0;test4=test0;
    for i=1:length(test0)
        im=imread(test0(i).im);
        test1(i).im=['BUFFY1/' test0(i).im(7:end)];
        test2(i).im=['BUFFY2/' test0(i).im(7:end)];
        test3(i).im=['BUFFY3/' test0(i).im(7:end)];
        test4(i).im=['BUFFY4/' test0(i).im(7:end)];
        %imwrite(blur(im,0.02),test4(i).im); %this one should make the final result get worse, for the result on blurred image is worse, and the average result will get worse
        imwrite(bright(im,0.8),test2(i).im); %less bright
        imwrite(bright(im,1.5),test3(i).im); % brighter
        imwrite(imnoise(im,'salt & pepper',0.02),test1(i).im);
        
        %imwrite(ones(size(im)),test1(i).im);
        %imwrite(im(11:end,11:end,:),test1(i).im); % brighter
        %test4(i).im=test0(i).im(10:end,10:end,:); %move
        %test5(i).im=test0(i).im(:,end:-1:1,:); %convert horizontally
    end

end

function [im2] = blur(im, sigma)
% sigma represents the degree of the blurring, which is that the bigger the sigma is, the fuzzy the image becomes
  hsize = ceil(20 * sigma);
  if sigma == 0 || hsize < 3
    im2 = im;
  else
    filter = fspecial('gaussian', hsize, sigma);
    im2 = imfilter(im, filter, 'symmetric', 'same');
  end
end

function [im2] = bright(im, light_percent) 
    im=im2double(im);
    hsv=rgb2hsv(im);
    hsv(:,:,3)=light_percent.*hsv(:,:,3);
    im2=hsv2rgb(hsv);
    im2=im2uint8(im2);
end
