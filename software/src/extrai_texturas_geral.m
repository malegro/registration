function extrai_texturas_geral

%
% EXTRAI_TEXTURAS_GERAL
%
% Extrai dados de textura das imagens 
%


dir_root = '/home/maryana/LSI/Mestrado/implementacao/';

fprintf('\n# Iniciando processo de extracao de texturas #\n');

tic;

for i=0:10
    paciente = strcat('paciente',int2str(i)); 
    %paciente = strcat('teste',int2str(i)); 
    
    dir_mascaras = strcat(dir_root,paciente,'/mascaras/');
    dir_normalizado = strcat(dir_root,paciente,'/normalizado/');
    
    saida = strcat(dir_root,paciente,'/',paciente,'_data.mat');
    
    nome_mask1 = strcat(dir_mascaras,paciente,'_mask_1_2class.bmp');
    nome_mask2 = strcat(dir_mascaras,paciente,'_mask_2_2class.bmp');
    nome_mask3 = strcat(dir_mascaras,paciente,'_mask_3_2class.bmp');
    
    nome_flair_1 = strcat(dir_normalizado,paciente,'_FLAIR_1.dcm');
    nome_flair_2 = strcat(dir_normalizado,paciente,'_FLAIR_2.dcm');
    nome_flair_3 = strcat(dir_normalizado,paciente,'_FLAIR_3.dcm');
    
    nome_t1_1 = strcat(dir_normalizado,paciente,'_T1_1.dcm');
    nome_t1_2 = strcat(dir_normalizado,paciente,'_T1_2.dcm');
    nome_t1_3 = strcat(dir_normalizado,paciente,'_T1_3.dcm');
    
    nome_t1c_1 = strcat(dir_normalizado,paciente,'_T1c_1.dcm');
    nome_t1c_2 = strcat(dir_normalizado,paciente,'_T1c_2.dcm');
    nome_t1c_3 = strcat(dir_normalizado,paciente,'_T1c_3.dcm');
    
    %carrega imagens
    mask1 = imread(nome_mask1);
    mask1 = mask1(:,:,1);
    mask2 = imread(nome_mask2);
    mask2 = mask2(:,:,1);
    mask3 = imread(nome_mask3);
    mask3 = mask3(:,:,1);
    
    flair1 = gscale(dicomread(nome_flair_1));
    flair2 = gscale(dicomread(nome_flair_2));
    flair3 = gscale(dicomread(nome_flair_3));
    
    t11 = gscale(dicomread(nome_t1_1));
    t12 = gscale(dicomread(nome_t1_2));
    t13 = gscale(dicomread(nome_t1_3));
    
    t1c1 = gscale(dicomread(nome_t1c_1));
    t1c2 = gscale(dicomread(nome_t1c_2));
    t1c3 = gscale(dicomread(nome_t1c_3));
    
    %monta estrutura temporaria
    
    T1 = cat(3,t11,t12,t13);
    T1c = cat(3,t1c1,t1c2,t1c3);
    FLAIR = cat(3,flair1,flair2,flair3);
    mask = cat(3,mask1,mask2,mask3);
    
    img_strut.T1 = T1;
    img_strut.T1c = T1c;
    img_strut.FLAIR = FLAIR;
    img_strut.mask = mask;      
    
    
    try
        load(saida);
    catch
        struct = [];
    end
    
    %calcula texturas        
    
    fprintf('\n -- Processando %s --\n',paciente);

     struct = extrai_haralick(img_strut); %texturas de haralick    
 
     struct = extrai_runlength(img_strut,struct); %texturas de matriz run-length
     
     struct = extrai_wavelets(img_strut,struct); %texturas wavelet
     
     struct = extrai_dim_fractal(img_strut,struct); %texturas de dimensao fractal
 
     struct = extrai_markov(img_strut,struct); %texturas por MRF
     
    struct = extrai_gabor(img_strut,struct); %texturas por filtros de Gabor    
                     
   %salva dados no disco                         
   save(char(saida),'struct'); 
end

tempo = toc;

fprintf('\n# Processo de extracao de texturas finalizado. Tempo gasto: %1.4f (horas) #\n',(tempo/3600));
    
    








    
