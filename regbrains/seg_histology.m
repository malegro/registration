function img_seg = seg_histology(img)

    img = imresize(img,0.15); %same of blockface   
    
    level = graythresh(img);
    mask = im2bw(img,level);
    mask = ~mask;
    
    %se = strel('disk', 6);
    %mask = imopen(mask,se);
    
    %clean small connected structures from the mask
    mask = clean(mask,0.006);
    
    %[mask Lz] = sfm_local_chanvese(img,mask,600,0.1,10,1);
    mask = region_seg(img,mask,600,0.2,1);

    %clean small objs
    mask = clean(mask,0.006);

    %close holes
    mask = imfill(mask,'holes');
    
    %img_seg  = adapthisteq(img);
    img_seg = img;
    img_seg(mask == 0) = 0;   
    
    %erase remaining white background
    img_seg(img_seg >= 200) = 0;
    
end


%
% clean mask from small connected objects
%
function mask = clean(mask,p)

[labels nL] = bwlabel(mask);

%find largest
%maxL = 0;
maxCount = 0;
for l=1:nL
    nElem = length(find(labels == l));
    if nElem > maxCount
        maxCount = nElem;
        %maxL = l;
    end
end

for l=1:nL    
    nElem = length(find(labels == l));    
    if nElem <= maxCount*p % p% of the largest obj in the image
        labels(labels == l) = 0;
    end
end

mask(labels == 0) = 0;

end