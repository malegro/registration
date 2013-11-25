function image = seg_blockface_kmeans(img, wp, niter, backmask)

%img = rgb2gray(img);
img = imresize(img,0.15);
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

%img = weak_wb(img,wp);
yiq = rgb2ntsc(img);
Y = yiq(:,:,1);
I = gscale(yiq(:,:,2));
Q = gscale(yiq(:,:,3));

[rows cols] = size(Y);
img_center = [round(rows/2) round(cols/2)];

%[H S V] = rgb2hsv(img);

if ~isempty(backmask)
    
    fore_idx = find(backmask == 1);
    II = I(fore_idx);
    QQ = Q(fore_idx);
    %features = cat(2,double(II),double(QQ));
    features = double(QQ);
else
    features = cat(2,double(I(:)),double(Q(:)));
end

features = rescale2(features,0,1);
[idx,ctrs] = kmeans(features,2,'Distance','cityblock','Replicates',5);
%[idx,ctrs] = kmeans(features,2);
[m fore] = min(ctrs(:,1));

if ~isempty(backmask)
    npix = length(fore_idx);    
    clusters = zeros(size(Y));
    for p = 1:npix
        clusters(fore_idx(p)) = idx(p);      
    end
    clusters(clusters ~= fore) = 0;
    clusters(clusters == fore) = 1;
else
    clusters = zeros(size(Y));
    clusters(idx == fore) = 1;
    clusters(idx ~= fore) = 0;
end

[labels mainL] = findMainObj(clusters,img_center);
mask = zeros(size(labels));
mask(labels == mainL) = 1;


%img = weak_wb(img,wp);
new_mask = imfill(mask,'holes');
%B = anisodiff2D(B2,30,1/7,10,1);
[gmag gdir] = imgradient(img(:,:,3));

%gmag(gmag < 30) = 0;
mask = region_seg(gscale(gmag),new_mask,niter,0.4,1);
%[mask] = sfm_local_chanvese(gscale(gmag),new_mask,1000,0.2,10);

R2 = R; G2 = G; B2 = B;
R2(mask == 0) = 0;
G2(mask == 0) = 0;
B2(mask == 0) = 0;

image = cat(3,R2,G2,B2);


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

%
% Find largest connected structure close to the image center
%

function [labels mainL] = findMainObj(mask, img_center)

%find connected structures
[labels nL] = bwlabel(mask);

mainL = 0;
minDist = 0;
for l = 1:nL
    [r,c] = find(labels == l);
    sizeObj = length(find(labels == l));
    centroid = [round(mean(r))  round(mean(c))];
    
    %plot(centroid(2),centroid(1),'Marker','*','MarkerSize',10,'MarkerEdgeColor','r')
    
    dist = norm(img_center - centroid);
    if(mainL == 0) %must initialize variables
        minDist = dist;
        mainL = l;      
    end
       
    %get the largest object w/ min distance from center
    if(dist < minDist && sizeObj > 2000)
    %if(dist < minDist)
            minDist = dist;
            mainL = l;
    end 
end

end