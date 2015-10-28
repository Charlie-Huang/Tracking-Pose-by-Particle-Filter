
for i=104:276

    demoimid=i;
    im  = imread(test(demoimid).im);
    
    figure(3);

    box = boxes_gtbox0{demoimid};
    subplot(1,2,1); showskeletons(im,box,colorset,model.pa);title(['origin' num2str(i)]);%origin

    box = boxes_gtbox{demoimid};
    subplot(1,2,2); showskeletons(im,box,colorset,model.pa);title(['new' num2str(i)]);%new

    saveas(gcf,['Contrast_images/' 'myfig' num2str(i) '.jpg']);

end