function preproc_seg_blockface_refine(dir_in,dir_out,files)

if dir_in(end) ~= '/'
    dir_in = [dir_in '/'];
end

if dir_out(end) ~= '/'
    dir_out = [dir_out '/'];
end

nFiles = size(files,1);

for f = 1:nFiles
    name = char(files(f,:));
    file_name = strcat(dir_in,name);
    img1 = imread(file_name);
    img2 = seg_blockface_em(img1,[134 155 160],50,0);    
%     idx = findstr(name,'_seg1.tif');
%     idx = idx(end);
%     name(idx:end) = '_seg2.tif';    
    new_name = strcat(dir_out,name);
    imwrite(img2,new_name,'TIFF');
end