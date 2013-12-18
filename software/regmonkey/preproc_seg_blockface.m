function preproc_seg_blockface(dir_in,dir_out,wp,samples)

if dir_in(end) ~= '/'
    dir_in = [dir_in '/'];
end

if dir_out(end) ~= '/'
    dir_out = [dir_out '/'];
end

wsize = 13;

init_obj = init_gmm(wsize,wp, samples);

files = dir(strcat(dir_in,'*.tif'));
nFiles = length(files);

for f = 1:nFiles
    fprintf('Processing %s...\n',files(f).name);
    file_name = strcat(dir_in,files(f).name);
    img1 = imread(file_name);
    img2 = seg_blockface_em(img1,wp,1,0,1,[],[],init_obj);
    new_name = strcat(dir_out,files(f).name,'_seg1.tif');
    imwrite(img2,new_name,'TIFF');
end