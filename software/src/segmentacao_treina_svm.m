function [model] = segmentacao_treina_svm(pacientes,caracteristicas,percent,medico)

%
% TESTE 1:
% 3 ptos tumor
% 3 ptos sub. branca
% 3 ptos sub. cinza
% 3 ptos liquor
%

% modalidades
% t1 = 1
% t1c = 2;
% flair = 3;

if (percent >=1 || percent <= 0)
   error('A percentagem do conjunto de treino deve ser: 0 < percent < 1');
end


dir_root = '/home/nex/LSI/Mestrado/implementacao/';

dados_tumor = [];
dados_normal = [];
  
for p=pacientes
    
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
    
    %aloca vetores
    charac_tumor = [];
    charac_normal = [];
    
    %carrega dados
    dados = load(nome_dados);    

    %itera slices
    for s=1:3
        
        len_t = length(indices_tumor(s).ind);
        len_n = length(indices_normal(s).ind);
        
        nInds = floor(len_t*percent); %pega PERCENT porcento dos pontos de tumor
        inds_t = indices_uniformes(1,len_t,nInds);
        inds_n = indices_uniformes(1,len_n,nInds);
        
        for t=inds_t
            indice_no_vetor = find(indices(s).ind == indices_tumor(s).ind(t));           
            charac_tumor = cat(1,charac_tumor,dados.struct.dados(s).valores(indice_no_vetor,caracteristicas));
        end
        
        for t=inds_n
            indice_no_vetor = find(indices(s).ind == indices_normal(s).ind(t));
            charac_normal = cat(1,charac_normal,dados.struct.dados(s).valores(indice_no_vetor,caracteristicas));
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

treino = rescale2(treino);

%faz busca de parametro (isso demora)
%[bestc bestg] = svm_grid_search(labels,treino,percent);
bestc = 1; bestg = 2;
%bestc = 11.3137; bestg = 0.707107;

%treina SVM
model = svmtrain(labels,treino,['-t 2 -c' num2str(bestc) '-g ' num2str(bestg)]);
