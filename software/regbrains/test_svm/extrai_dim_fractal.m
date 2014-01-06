function [struct] = extrai_dim_fractal(img,mask,janela,struct)

%
% Extrai informacoes de textura por dimensao fractal
%

nErros = 0;

struct = aloca_espaco(struct,mask); %aloca espacao

fprintf('Iniciando calculo das texturas por Dimensao Fractal...\n');
   
indices = find(mask ~= 0);
len = length(indices);
    
for t=1:len
    try
        w = getwindow(indices(t),img,janela);
    catch
        nErros = nErros+1;
        continue;
    end
        
        FD = PTPSA(w);
        struct.fractal(t) = FD;        
end
    

 
fprintf('Numero de erros: %d\n',nErros);



%aloca espaco na estrutura de dados
function [struct] = aloca_espaco(struct,mask)

rows = length(find(mask ~= 0));
cols = 1;         
struct.fractal = zeros(rows,cols);
  