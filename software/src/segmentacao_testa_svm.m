function segmentacao_testa_svm(model,pacientes,caracteristicas,medico)


% modalidades
% t1 = 1
% t1c = 2;
% flair = 3;


dir_root = '/home/nex/LSI/Mestrado/implementacao/';


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
    
    %carrega dados
    dados = load(nome_dados);     
    
    fprintf('Classificando imagens do %s...\n', paciente);
    
    %itera slices
    for s=1:3
        teste = dados.struct.dados(s).valores(:,caracteristicas);
        
        teste = rescale2(teste);               
        saida = zeros(size(mask(s).m));
        %saida2 = saida;
        
        %monta vetor de labels pra fazer estatistica
        labels = ones(size(teste,1),1); 
        for w=1:size(labels,1)
            if mask(s).m(indices(s).ind(w)) == 230
                labels(w) = -1;
            end
        end
        
        fprintf('Slice %d: ',s);
        
        [classificacao, precisao, probabilidades] = svmpredict(labels, teste, model);
        saida(indices(s).ind(classificacao == -1)) = 255;
        %saida2(indices(s).ind(classificacao == 1)) = 255;
        
        
        imwrite(saida,strcat(dir_root,paciente,'/resultado/',paciente,'_saida_',int2str(s),'_medico',int2str(medico),'_tumor.bmp'),'BMP');        
        %imwrite(saida2,strcat(dir_root,paciente,'/resultado/',paciente,'_saida_',int2str(s),'_normal.bmp'),'BMP');
    end
    
end 
