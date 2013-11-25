function tmp(direc)

% do threshold

% files = dir(strcat(direc,'/*.tif'));
% nFiles = length(files);
% 
% for f=1:nFiles
%     
%     fprintf('Processing %s...\n',files(f).name);
%     
%     img_name = strcat(direc,'/',files(f).name);
%     img = imread(img_name);
% 
%     img(img >= 200) = 0;    
%    
%     imwrite(img,img_name,'TIFF');
%     
% end
% 
% end

% fix file names

if direc(end) ~= '/'
    direc = [direc '/'];
end

files = dir(strcat(direc,'*.JPG'));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    
    idx1 = strfind(name,'_');
    idx1 = idx1(end);
    idx2 = strfind(name,'.');
    idx2 = idx2(end);
    
    new_name = strcat(direc,name(idx1+1:idx2-1),'.jpg');
    name = strcat(direc,name);
    
    movefile(name,new_name);    
end