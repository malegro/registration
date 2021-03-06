function [features] = extrai_selecao_caracteristicas(vetor,N)

% [FEATURES] = EXTRAI_SELECAO_CARACTERISTICAS(VETOR,N)
%
% Roda algoritmo que realiza selecao das caracteristicas mais relevantes
%
% VETOR : vetor com numero dos pacientes que devem ser considerados
% N : numero de caracteristicas que se quer
%

% modalidades
% t1 = 1
% t1c = 2;
% flair = 3;

dir_root = '/home/maryana/LSI/Mestrado/implementacao/';

[labels,treino] = carrega_dados_textura(dir_root,vetor); %carrega os dados dos arquivos

treino = rescale2(treino);

%discretiza matrix de dados em 3 estados
treino = discretiza(treino,1);

%seleciona caracteristicas
features = mrmr_mid_d(treino, labels, N);