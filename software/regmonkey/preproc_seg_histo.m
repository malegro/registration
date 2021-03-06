function preproc_seg_histo(dir_in,dir_out)


if dir_in(end) ~= '/'
    dir_in = [dir_in '/'];
end

if dir_out(end) ~= '/'
    dir_out = [dir_out '/'];
end

files = dir(strcat(dir_in,'*.tif'));
nFiles = length(files);

for f = 1:nFiles
    file_name = strcat(dir_in,files(f).name);
    img1 = imread(file_name);
    img2 = seg_histology(img1);
    new_name = strcat(dir_out,files(f).name,'_seg1.tif');
    imwrite(img2,new_name,'TIFF');
end