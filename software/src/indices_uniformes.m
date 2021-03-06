function indices = indices_uniformes(m,n,nInd)

%
% INDICES = INDICES_UNIFORMES(M,N,NIND)
%
% Retorna um vetor com NIND indices (quase) uniformemente espacados, dentro do
% intervalo [M,N]
%

if m <= 0 || n <= 0 || (m > n)
    error('M e N devem ser maiores que zero. M deve ser menor que N.');
end

intervalo = n-m;

if nInd > intervalo
    error('Numero de indices deve ser menor que o intervalo.');
end

gap = intervalo/nInd;
gap = ceil(gap);
indices = m:gap:n; 

len = length(indices);
if len < nInd
    nFalta = nInd - len;
    nNovosIndices = 0;
    while(nNovosIndices < nFalta)
        num = uniformrandint(m,n);
        if(~isempty(find(indices == num)))
            continue;
        end
        indices(length(indices)+1) = num;
        nNovosIndices = nNovosIndices+1;
    end
elseif len > nInd
        diff = len-nInd;
        len = len-diff;
        indices = indices(1:len);
end