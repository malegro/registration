function f = wrapper(params,im1,im2,obj_f,roi)
 
   if isempty(roi), roi = [1 size(im1,2) 1 size(im2,1)]; end
   
   roiX   = roi(1):roi(2);
   roiY   = roi(3):roi(4);
   
   im2t = image_transform(im2,params);
   
   f = obj_f(im1(roiY,roiX),im2t(roiY,roiX));
   
  
   if 0
     figure(1);
     display_alignment(im1,im2t); hold on;
     plot([roi(1) roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(4) roi(4) roi(3) roi(3)],'r-');
     hold off;
     drawnow;
   end
