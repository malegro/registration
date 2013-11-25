function preprocess_seg_histo(directory)

%
% Segments histology slices from the backgroung plate.
% Used in full brain histology images.
% Preprocess step befote registration with blockface.
%
% DIRECTORY : path to case root directory. Ex.: /home/Brains/Case01/
%

if directory(end) ~= '/'
    directory = [directory '/'];
end

histo_dir = strcat(directory,'histology/orig/');
seg_dir = strcat(directory,'histology/seg/');
mkdir(seg_dir);

files = dir(strcat(histo_dir,'*.jpg'));
nFiles = length(files);

for f=1:nFiles
    
    fprintf('Processing %s...\n',files(f).name);
    
    img_name = strcat(histo_dir,files(f).name);
    img = imread(img_name);
    if size(img,3) > 1
        img = rgb2gray(img);
    end    
    
    %do segmentation
    img_seg = seg_histology(img);
    
    new_name = files(f).name;
    new_name = changeExt(new_name,'tif');    
    imwrite(img_seg,strcat(seg_dir,new_name),'TIFF');
    
end

end


