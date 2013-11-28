function preprocess_intnorm_histo(direc,opt)

%
% Normalizes histology intensities
% DIREC: case directory ( direc = '/autofs/space/hercules_001/users/malegro/Brains/Case01')
% OPT: 1 - load JPG | 2 - load nifti
%

if direc(end) ~= '/'
    direc = [direc '/'];
end

if opt == 1
    ext = '*.jpg';
    dir_histo = strcat(direc,'histology/seg/');
    dir_norm = strcat(direc,'histology/intnorm1/');
elseif opt == 2
    ext = '*.mgz';    
    dir_histo = strcat(direc,'histology/reg1/');
    dir_norm = strcat(direc,'histology/intnorm2/');
end
% dir_tmp = strcat(direc,'tmp/');
% r = dir(dir_tmp);
% if ~isempty(r) %veryfies tmp existence
%     rmdir(dir_tmp,'s');
% end
% mkdir(dir_tmp);


files = dir(strcat(dir_histo,ext));
nFiles = length(files);
files = sortfiles(files);

%pick middle slice as histogram reference (middle brain images usually are pretty "stable")
 ref = round(nFiles/2);
 ref_img = strcat(dir_histo,files(ref).name);
 %copyfile(ref_img,strcat(dir_norm,files(ref).name));

for f=ref:-1:1    
    
    fprintf('Processing %s.\n',files(f).name);
    
    norm_img = strcat(dir_histo,files(f).name);    
    %loads image to be corrected
    if isNifti(norm_img) || isMGZ(norm_img) 
        img1 = MRIread(norm_img);
        img1 = img1.vol;
        img1 = uint8(round(img1));  
    else
        img1 = imread(norm_img);
    end
    mask = zeros(size(img1));
    mask(img1 >= 1) = 1;  
    
    %loads reference image
    if isNifti(ref_img) || isMGZ(ref_img) 
        img2 = MRIread(ref_img);
        img2 = img2.vol;
        img2 = uint8(round(img2));  
    else
        img2 = imread(ref_img);   
    end
    
    %run intensity correction
    new_img = intensity_compensation(img1,img2);    
    %remask to avoid boundary artifacts
    new_img(mask == 0) = 0;    
    
    %save file
    new_norm_name = changeExt(files(f).name,'mgz');
    new_norm_name = strcat(dir_norm,new_norm_name); 
    mgz.vol = new_img;
    MRIwrite(mgz,new_norm_name);
    
    ref_img = new_norm_name;    
end

ref_img = strcat(dir_histo,files(ref).name);
for f=ref+1:nFiles   
    
    fprintf('Processing %s.\n',files(f).name);
    
    norm_img = strcat(dir_histo,files(f).name);    
    %loads image to be corrected
    if isNifti(norm_img) || isMGZ(norm_img) 
        img1 = MRIread(norm_img);
        img1 = img1.vol;
        img1 = uint8(round(img1));  
    else
        img1 = imread(norm_img);
    end
    mask = zeros(size(img1));
    mask(img1 >= 1) = 1;  
    
    %loads reference image
    if isNifti(ref_img) || isMGZ(ref_img) 
        img2 = MRIread(ref_img);
        img2 = img2.vol;
        img2 = uint8(round(img2));  
    else
        img2 = imread(ref_img);   
    end
    
    %run intensity correction
    new_img = intensity_compensation(img1,img2);    
    %remask to avoid boundary artifacts
    new_img(mask == 0) = 0;    
    
    %save file
    new_norm_name = changeExt(files(f).name,'mgz');
    new_norm_name = strcat(dir_norm,new_norm_name); 
    mgz.vol = new_img;
    MRIwrite(mgz,new_norm_name);
    
    ref_img = new_norm_name;          
end

%converts all corrected images to NIFTI
% files = dir(strcat(dir_tmp,'*.tif'));
% nFiles = length(files);
% for f=1:nFiles    
%     tmp_name = strcat(dir_tmp,files(f).name);    
%     
%     nii_name = files(f).name;
%     nii_name = changeExt(nii_name,'nii');
%     nii_name = strcat(dir_norm,nii_name);    
%     
%    command = sprintf('mri_convert %s %s', tmp_name, nii_name);
%    [status_bf, result_bf] = system(command);
%    if status_bf ~=0 
%         fprintf('Could no convert %s.\n', name);
%         return;
%    end 
% end



end


%
% ex: ext = 'jpg'
%
function new_name = changeExt(name,ext)
    idx = strfind(name,'.');
    idx = idx(end);    
    new_name = strcat(name(1:idx),ext);
end

function flag = isNifti(name)
    idx = strfind(name,'.');
    idx = idx(end);
    ext = name(idx+1:end);    
    flag = strcmp(ext,'nii');    
end

function flag = isMGZ(name)
    idx = strfind(name,'.');
    idx = idx(end);
    ext = name(idx+1:end);    
    flag = strcmp(ext,'mgz');    
end



