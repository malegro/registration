function [labels,treino] = carrega_dados_textura(dir_root,vetor)

% [LABELS,TREINO] = CARREGA_DADOS_TEXTURA(DIR_ROOT,VETOR)
%
% Carrega os dados de textura dos arquivos gerados na fase de extracao de
% caracteristicas e embraralha as entradas
%
% ENTRADA
% DIR_ROOT : diretorio raiz de onde estao os arquivos de dados (.mat)
%
% VETOR : numero dos paciente que deveram ser lidos
%
% SAIDA
% LABELS : labels referentes a matrix de dados
%
% TREINO : matriz de dados

% modalidades
% t1 = 1
% t1c = 2;
% flair = 3;

%dir_root = '/home/nex/LSI/Mestrado/implementacao/';

medico = 1;

percent = 0.1;

dados_tumor = [];
dados_normal = [];
  
for p=vetor
    
    p = p+1;
    
    paciente = strcat('paciente',int2str(p-1));
    dir_mascaras = strcat(dir_root,paciente,'/mascaras/');    
    nome_mask1 = strcat(dir_mascaras,paciente,'_mask',int2str(medico),'_1_2class.bmp');
    nome_mask2 = strcat(dir_mascaras,paciente,'_mask',int2str(medico),'_2_2class.bmp');
    nome_mask3 = strcat(dir_mascaras,paciente,'_mask',int2str(medico),'_3_2class.bmp');
    nome_dados = strcat(dir_root,paciente,'/',paciente,'_data.mat');
    
    %carrega mascaras
    mask(1).m = imread(nome_mask1);
    mask(1).m = mask(1).m(:,:,1);
    mask(2).m = imread(nome_mask2);
    mask(2).m = mask(2).m(:,:,1);
    mask(3).m = imread(nome_mask3);
    mask(3).m = mask(3).m(:,:,1);
    
    %todos os indices
    indices(1).ind = find(mask(1).m ~= 0);
    indices(2).ind = find(mask(2).m ~= 0);
    indices(3).ind = find(mask(3).m ~= 0);
    
    %indices soh de tumor
    indices_tumor(1).ind = find(mask(1).m == 230);
    indices_tumor(2).ind = find(mask(2).m == 230);
    indices_tumor(3).ind = find(mask(3).m == 230);
    
    %indices soh de tecido normal
    indices_normal(1).ind = find(mask(1).m == 255);
    indices_normal(2).ind = find(mask(2).m == 255);
    indices_normal(3).ind = find(mask(3).m == 255);       

    
    %carrega dados
    dados = load(nome_dados);  
    
    charac_tumor = [];
    charac_normal = [];

    
    %itera slices
    for s=1:3
        
        len_t = length(indices_tumor(s).ind);
        len_n = length(indices_normal(s).ind);
        
        nInds = floor(len_t*percent);
        inds_t = indices_uniformes(1,len_t,nInds);                
        inds_n = indices_uniformes(1,len_n,nInds);
        
        for t=inds_t
            indice_no_vetor = find(indices(s).ind == indices_tumor(s).ind(t));
            charac_tumor = cat(1,charac_tumor,dados.struct.dados(s).valores(indice_no_vetor,:));            
        end
        
        for t=inds_n
            indice_no_vetor = find(indices(s).ind == indices_normal(s).ind(t));            
            charac_normal = cat(1,charac_normal,dados.struct.dados(s).valores(indice_no_vetor,:));
        end         
    end
    
    
    %concatena dados tumor
    dados_tumor = cat(1,dados_tumor,charac_tumor);
        
    %concatena dados cerebro
    dados_normal = cat(1,dados_normal,charac_normal);

end 


classe_tumor = -1*ones(size(dados_tumor,1),1);
classe_normal = ones(size(dados_normal,1),1);

treino = cat(1,dados_tumor,dados_normal);
labels = cat(1,classe_tumor,classe_normal);

%embaralha dados
tmp = cat(2,labels,treino);
tmp2 = shuffle_matrix(tmp); 
labels = tmp2(:,1);
treino = tmp2(:,2:end);
