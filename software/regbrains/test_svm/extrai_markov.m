function [struct] = extrai_markov(img,mask,janela,struct)

%
% Calcula os parametros de textura por um campo aleatorio de markov
% gaussiano, utilizando Estimativa dos Minimos Quadrados
%

ordens = 1:5;
nErros = 0;

struct = aloca_espaco(struct,ordens,mask);

fprintf('Iniciando calculo das texturas por Markov (MRF)...\n');

for o = ordens
    
    fprintf('calculando ordem %d\n',o);

    indices = find(mask ~= 0);
    len = length(indices);
                
    for t=1:len
            
        try
            w = getwindow(indices(t),img,janela);
        catch
            nErros = nErros+1;
            continue;
        end            
        theta = markov_calcula_theta(w,o); %calcula parametros para a janela w, referente a ordem o
        struct.markov.ordem(o).theta(t,:) = theta(:);            
    end
end

fprintf('Numero de erros: %d\n',nErros);


function [struct] = aloca_espaco(struct,ordens,mask)

    nViz = [2 4 6 10 12]; %no. ve vizinhos de acordo com a ordem (ordem = indice do vetor)
    
    for o = ordens
        indices = find(mask ~= 0);
        len = length(indices);            
        struct.markov.ordem(o).theta = zeros(len,nViz(o)+1); %nViz(o)+1 = n de vizinhos + a variancia
    end

    