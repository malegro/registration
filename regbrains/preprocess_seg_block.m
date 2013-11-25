function preprocess_seg_block(directory)

%
% Segments blockface image background
% DIRECTORY : case dir
%

if directory(end) ~= '/'
    directory = [directory '/'];
end

block_dir = strcat(directory,'blockface/orig/'); %original images

files = dir(strcat(block_dir,'*.jpg'));
nFiles = length(files);

seg_dir = strcat(directory,'blockface/seg/');
mkdir(seg_dir);

for f=1:nFiles    
    
    fprintf('Processing %s...\n',files(f).name);
    
    name = strcat(block_dir,files(f).name);
    img = imread(name);
    
    %do segmentation
    img2 = seg_blockface(img);
    
    new_name = changeExt(files(f).name,'tif'); %avoid lossy compression
    
    new_name = strcat(seg_dir,new_name);
    imwrite(img2,new_name,'TIFF');
end

end

