function preprocess_seg_block(directory,wp,todo,do1st,samples)

%
% Segments blockface image background
% DIRECTORY : case dir
%

wsize = 13;
rfactor = 0.15;

if directory(end) ~= '/'
    directory = [directory '/'];
end

init_obj = [];
if ~isempty(samples)
    init_obj = init_gmm(wsize,wp,samples);
end

block_dir = strcat(directory,'blockface/orig/'); %original images
seg_dir = strcat(directory,'blockface/seg/');
mkdir(seg_dir);

if isempty(todo) %first segmentation

    files = dir(strcat(block_dir,'*.jpg'));
    nFiles = length(files);
    for f=1:nFiles    

        fprintf('Processing %s...\n',files(f).name);

        name = strcat(block_dir,files(f).name);
        img = imread(name);
        img = imresize(img,rfactor);

        %do segmentation
        img2 = seg_blockface_em(img,wp,1,120,1,[],[],init_obj);
        new_name = changeExt(files(f).name,'tif'); %avoid lossy compression

        new_name = strcat(seg_dir,new_name);
        imwrite(img2,new_name,'TIFF');
    end

else %segmentation refinement
    
   nFiles = length(todo);   
   for f = 1:nFiles  
       
       prefix = [];
       if (todo(f) <= 9)
           prefix = '00';
       elseif (todo(f) >= 10 && todo(f) <= 99)
           prefix = '0';
       end
       
       if do1st 
           name = strcat(prefix,int2str(todo(f)),'.jpg');
           fprintf('Processing %s...\n',name);
           new_name = changeExt(name,'tif'); %avoid lossy compression
           name = strcat(block_dir,name);           
           new_name = strcat(seg_dir,new_name);
           rback = 1;
       else
           name = strcat(prefix,int2str(todo(f)),'.tif');
           fprintf('Processing %s...\n',name);
           name = strcat(seg_dir,name);
           new_name = name;
           rback = 0;
       end      
       
       img = imread(name);
       if do1st
            img = imresize(img,rfactor);
       end
       %do segmentation
       img2 = seg_blockface_em(img,wp,1,10,rback,[],[],init_obj);
       imwrite(img2,new_name,'TIFF');
   end
end


end




