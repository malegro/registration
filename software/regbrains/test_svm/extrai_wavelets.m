function [struct] = extrai_wavelets(img, mask, janela, struct)                                   
%function [struct] = extrai_wavelets(img, mask, janela)

 %
 % Extrai dados de textura via wavelets, calculando energia para cada
 % imagens de detalhe 
 % 
  
 levels = 2;
 
 wavelets = {'db4', 'coif3','sym2','bior5.5'}; 
% wavelets = {'db4', 'db10','db20','coif2','coif3','coif5','sym2','sym8','sym20','bior1.5','bior3.3','bior5.5'};
 
 nWaves = length(wavelets);
 
 countWave = 1;
 
 nErros = 0;
 
 fprintf('Iniciando calculo das texturas por Wavelets...\n');

 for wi=1:nWaves %itera wavelets
     
     wave = wavelets(wi);
     wave = char(wave);
     
     fprintf('calculando %s\n',wave);     
     
     indices = find(mask ~= 0);
     len = length(indices);

     for t=1:len %itera pixeis        
                          
             try
                w = getwindow(indices(t),img,janela);
             catch
                nErros = nErros+1;
                continue;
             end
             [C,S] = wavedec2(w,levels,wave);
             [Ea,Eh,Ev,Ed] = wenergy2(C,S);
             
             count = countWave;
             
             for l=1:levels
                 struct.wavelets(t,count) = Eh(l);
                 struct.wavelets(t,count+1) = Ev(l);
                 struct.wavelets(t,count+2) = Ed(l);
                 count = count+3;
             end
             
     end     
     countWave = countWave+3*levels;     
 end
 
 fprintf('Numero de erros: %d\n',nErros);
 
 
 % aloca espaco na estrutura de dados
 function [struct] = aloca_espaco(struct,wavelets,levels,mask) 
     
     nWaves = length(wavelets);  
     rows = length(find(mask ~= 0));
     cols = nWaves*3*levels;
         
     struct.wavelets = zeros(rows,cols);   
     struct.wavelets = zeros(rows,cols);
     struct.wavelets = zeros(rows,cols);
     
                    