function [struct] = extrai_runlength(img,mask,janela,struct)
                                   
 %
 % Extrai dados de textura atraves das matrizes run-length
 %

struct = incializa_ed(mask,struct); %inicializa estrutura de dados

nErros = 0;

fprintf('Iniciando calculo das texturas por Matriz Run-length...\n');
    
    indices = find(mask ~= 0);
    len = length(indices);
    
    for t=1:len        
        try
            w = getwindow(indices(t),img,janela);
        catch
            nErros = nErros+1;
            continue;
        end    

        ccm = grayrlmatrix(w); 
        props = grayrlprops(ccm); %matriz 4(direcoes) x 11(caracteristicas): [SRE LRE GLN RLN  RP LGRE HGRE SGLGE SRHGE LRLGE  LRHGE ]

        struct.SRE(t,:) = props(:,1)';
        struct.LRE(t,:) = props(:,2)';
        struct.GLN(t,:) = props(:,3)';
        struct.RLN(t,:) = props(:,4)';
        struct.RP(t,:) = props(:,5)';
        struct.LGRE(t,:) = props(:,6)';
        struct.HGRE(t,:) = props(:,7)';
        struct.SRLGE(t,:) = props(:,8)';
        struct.SRHGE(t,:) = props(:,9)';
        struct.LRLGE(t,:) = props(:,10)';
        struct.LRHGE(t,:) = props(:,11)';       
    end


fprintf('Numero de erros: %d\n',nErros);


%%%%%%%%%%%%%%%%%%%%%%%

function struct = incializa_ed(mask,struct)
 
indices = find(mask ~= 0);
len = length(indices);
            
struct.SRE = zeros(len,4);
struct.LRE = zeros(len,4);
struct.GLN = zeros(len,4);
struct.RLN = zeros(len,4);
struct.RP = zeros(len,4);
struct.LGRE = zeros(len,4);
struct.HGRE = zeros(len,4);
struct.SRLGE = zeros(len,4);
struct.SRHGE = zeros(len,4);
struct.LRLGE = zeros(len,4);
struct.LRHGE = zeros(len,4);    


    
    