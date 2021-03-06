function compute_texture(dir_root,dir_masks,window)

if dir_root(end) ~= '/'
    dir_root = [dir_root '/']; 
end

if dir_masks(end) ~= '/'
    dir_masks = [dir_masks '/']; 
end

ext_mask = '_mask.tif';
ext_img = '.jpg';

files = dir(strcat(dir_root,'*',ext_img));
nFiles = length(files);

for i=1:nFiles
  
    name = files(i).name;
    img_name = strcat(dir_root,name);
    
    idx_tmp = strfind(name,ext_img);    
    mask_name = name(1:idx_tmp - 1);
    mask_name = strcat(dir_masks,mask_name,ext_mask);
    
    saida = strcat(dir_root,'texture_',name,'_',int2str(window),'pts.mat');
    
    img = imread(img_name);
%     mask = imread(mask_name);
%     mask = mask(:,:,1);

    [r c N] = size(img);
    mask = ones(r,c);
    
    
    fprintf('Processing file: %s (%d of %d)\n', img_name,i,nFiles);
    %extrai as texturas
    dados = extrai_haralick(img,mask,window);
    dados = extrai_gabor(img,mask,window,dados);
    dados = extrai_dim_fractal(img,mask,window,dados);
    dados = extrai_markov(img,mask,window,dados);
    dados = extrai_runlength(img,mask,window,dados);
    dados = extrai_wavelets(img,mask,window,dados);
    
    %monta estrutura com dados
    estrut.name = cellstr(img_name);
    estrut.data = dados;
    
    disp('Saving data file...');
    %salva estrutura
    save(char(saida),'estrut'); 
    clear 'estrut';
    clear 'dados';
end





