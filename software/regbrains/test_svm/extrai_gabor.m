function [struct] = extrai_gabor(img,mask,janela,struct)

parametros = [[0.05; 0.05; 0; 0] [0.05; 0.05; 45; 0] [0.05; 0.05; 90; 0] [0.05; 0.025; 0; 0] [0.05; 0.025; 45; 0] [0.05; 0.025; 90; 0]];

nCanais = size(parametros,2);
banco = [];

%monta banco de filtros
for c=1:nCanais
    G = gaborfilter2(parametros(1,c),parametros(2,c),parametros(3,c),parametros(4,c));
    banco = cat(3,banco,G);
end

nFiltros = size(banco,3);

nErros = 0;

struct = aloca_espaco(mask,struct,banco);

fprintf('Iniciando calculo das texturas por Filtros de Gabor...\n');


 indices = find(mask ~= 0);
 len = length(indices);    
    
for t=1:len
    try
        w = getwindow(indices(t),img,janela);
    catch
        nErros = nErros+1;
        continue;
    end
        
    for f=1:nFiltros
        G = banco(:,:,f);
        filtrado = conv2(double(w),double(G),'same');
        en = energia_media(filtrado);
        struct.gabor(t,f) = en;
    end
end


fprintf('Numero de erros: %d\n',nErros);



% aloca espaco
function struct = aloca_espaco(mask,struct,banco)

N = size(banco,3);

indices = find(mask ~= 0);
len = length(indices);
struct.gabor = zeros(len,N);
