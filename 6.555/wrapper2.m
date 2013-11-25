function f = wrapper2(params,im1,im2,obj_f,roi,extra_params)

%
% im1: reference image(s)
% im2: moving image
%

N = size(im1,3);

%
% only 1 image considered in obj function
% in this case obj_f(img1,img2)
%
if(N == 1) 
 
   if isempty(roi), roi = [1 size(im1,2) 1 size(im2,1)]; end
   
   roiX   = roi(1):roi(2);
   roiY   = roi(3):roi(4);
   
   im2t = image_transform(im2,params);
   
   f = obj_f(im1(roiY,roiX),im2t(roiY,roiX));
   
%   
% multiple neighboors considered in obj funtion
% in this case obj_f(params,ref_img,mov_img)
% im1(:,:,1) will always be the main ref_img
%
else
    
   % all images should be the same size 
   if isempty(roi), roi = [1 size(im1(:,:,1),2) 1 size(im2,1)]; end
   
   roiX   = roi(1):roi(2);
   roiY   = roi(3):roi(4);
   
   
   im2t = image_transform(im2,params);  
   
   
   im = [];
   for i=1:N
       im = cat(3,im,im1(roiY,roiX,i));
   end   
   f = obj_f(extra_params,im,im2t(roiY,roiX));   
    
end

   
  
   if 0
     figure(1);
     display_alignment(im1(:,:,1),im2t); hold on;
     plot([roi(1) roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(4) roi(4) roi(3) roi(3)],'r-');
     hold off;
     drawnow;
   end
