function extrai_textura_hipocampo(dir_root,dir_mascaras,janela,tipo)

% Projeto CINAPCE
%
% Extrai informacoes de textura das imagens de hipocampo
%
% dir_root: diretorio das imagens que se quer extrair as texturas
% dir_mascaras: diretorio onde estao as mascaras das ROIs
% tipo: 0 - DICOM, 1 - histologia

end_mask = '_mask.bmp';
saida = strcat(dir_root,'dados_hipocampo_GD_',int2str(janela),'pts.mat');

mascaras = dir(strcat(dir_mascaras,'*',end_mask));

[r c N] = size(mascaras);

disp('Iniciando processamento...');

for i=1:r 
    mascara = mascaras(i);
    x = findstr(end_mask,mascara.name);
    nome_dcm = mascara.name(1:x-1); %quebra string p pegar nome do dicom
    nome_dcm = strcat(dir_root,nome_dcm,'.dcm');
    %nome_dcm = strcat(dir_root,nome_dcm);
    nome_mask = strcat(dir_mascaras,mascara.name);
    
    mask = imread(nome_mask);
    mask = mask(:,:,1);
    
    if(tipo == 0)
        img = gscale(dicomread(nome_dcm));
    elseif(tipo == 1)
        img = imread(strcat(nome_dcm,'.jpg'));
        img = rgb2gray(img);
        img = gscale(img);
    end
    
    fprintf('Processando arquivo: %s (%d de %d)\n', nome_dcm,i,r);
    %extrai as texturas
    dados = extrai_haralick(img,mask,janela);
    dados = extrai_gabor(img,mask,janela,dados);
    dados = extrai_dim_fractal(img,mask,janela,dados);
    dados = extrai_markov(img,mask,janela,dados);
    dados = extrai_runlength(img,mask,janela,dados);
    dados = extrai_wavelets(img,mask,janela,dados);
    
    %monta estrutura com dados
    estrut.nomes(i) = cellstr(nome_dcm);
    estrut.dados(i) = dados;
end

disp('Salvando dados...');
%salva estrutura
save(char(saida),'estrut'); 
