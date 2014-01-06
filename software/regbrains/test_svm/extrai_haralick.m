function [dados] = extrai_haralick(img,mask,janela)

% Projeto CINAPCE
%
% Calcula os paramentros de textura da imagem de hipocampo
%

%janela = 9;

indices = find(mask ~= 0);

len = length(indices);

nErros = 0;

struct = incializa_ed(len);

for t=1:len
    try
        w = getwindow(indices(t),img,janela);
    catch
        nErros = nErros+1;
        continue;
    end
    
    % 0 graus   
    ccm = graycomatrix(w,'Offset',[0 1],'Symmetric',true);
    ccm_n = normalize_ccm(ccm,0,1);
    
    struct.ASM(t,1) = grayccmfeatures(ccm_n,'ASM');
    struct.contrast(t,1) = grayccmfeatures(ccm_n,'contrast');
    struct.correlation(t,1) = grayccmfeatures(ccm_n,'correlation');
    struct.variance(t,1) = grayccmfeatures(ccm_n,'variance');
    struct.IDM(t,1) = grayccmfeatures(ccm_n,'IDM');
    struct.sum_average(t,1) = grayccmfeatures(ccm_n,'sum_average');
    struct.sum_variance(t,1) = grayccmfeatures(ccm_n,'sum_variance');
    struct.sum_entropy(t,1) = grayccmfeatures(ccm_n,'sum_entropy');
    struct.entropy(t,1) = grayccmfeatures(ccm_n,'entropy');
    struct.diff_variance(t,1) = grayccmfeatures(ccm_n,'diff_variance');
    struct.diff_entropy(t,1) = grayccmfeatures(ccm_n,'diff_entropy');
    
    % 90 graus
    ccm = graycomatrix(w,'Offset',[-1 0],'Symmetric',true);    
    ccm_n = normalize_ccm(ccm,2,1);
    
    struct.ASM(t,2) = grayccmfeatures(ccm_n,'ASM');
    struct.contrast(t,2) = grayccmfeatures(ccm_n,'contrast');
    struct.correlation(t,2) = grayccmfeatures(ccm_n,'correlation');
    struct.variance(t,2) = grayccmfeatures(ccm_n,'variance');
    struct.IDM(t,2) = grayccmfeatures(ccm_n,'IDM');
    struct.sum_average(t,2) = grayccmfeatures(ccm_n,'sum_average');
    struct.sum_variance(t,2) = grayccmfeatures(ccm_n,'sum_variance');
    struct.sum_entropy(t,2) = grayccmfeatures(ccm_n,'sum_entropy');
    struct.entropy(t,2) = grayccmfeatures(ccm_n,'entropy');
    struct.diff_variance(t,2) = grayccmfeatures(ccm_n,'diff_variance');
    struct.diff_entropy(t,2) = grayccmfeatures(ccm_n,'diff_entropy');
    
    % 45 graus
    ccm = graycomatrix(w,'Offset',[-1 1],'Symmetric',true);    
    ccm_n = normalize_ccm(ccm,1,1);
    
    struct.ASM(t,3) = grayccmfeatures(ccm_n,'ASM');
    struct.contrast(t,3) = grayccmfeatures(ccm_n,'contrast');
    struct.correlation(t,3) = grayccmfeatures(ccm_n,'correlation');
    struct.variance(t,3) = grayccmfeatures(ccm_n,'variance');
    struct.IDM(t,3) = grayccmfeatures(ccm_n,'IDM');
    struct.sum_average(t,3) = grayccmfeatures(ccm_n,'sum_average');
    struct.sum_variance(t,3) = grayccmfeatures(ccm_n,'sum_variance');
    struct.sum_entropy(t,3) = grayccmfeatures(ccm_n,'sum_entropy');
    struct.entropy(t,3) = grayccmfeatures(ccm_n,'entropy');
    struct.diff_variance(t,3) = grayccmfeatures(ccm_n,'diff_variance');
    struct.diff_entropy(t,3) = grayccmfeatures(ccm_n,'diff_entropy');
    
    % 135 graus
    ccm = graycomatrix(w,'Offset',[-1 -1],'Symmetric',true);    
    ccm_n = normalize_ccm(ccm,3,1);  
    
    struct.ASM(t,4) = grayccmfeatures(ccm_n,'ASM');
    struct.contrast(t,4) = grayccmfeatures(ccm_n,'contrast');
    struct.correlation(t,4) = grayccmfeatures(ccm_n,'correlation');
    struct.variance(t,4) = grayccmfeatures(ccm_n,'variance');
    struct.IDM(t,4) = grayccmfeatures(ccm_n,'IDM');
    struct.sum_average(t,4) = grayccmfeatures(ccm_n,'sum_average');
    struct.sum_variance(t,4) = grayccmfeatures(ccm_n,'sum_variance');
    struct.sum_entropy(t,4) = grayccmfeatures(ccm_n,'sum_entropy');
    struct.entropy(t,4) = grayccmfeatures(ccm_n,'entropy');
    struct.diff_variance(t,4) = grayccmfeatures(ccm_n,'diff_variance');
    struct.diff_entropy(t,4) = grayccmfeatures(ccm_n,'diff_entropy');
    
    struct.intensity(t) = img(indices(t));    
end

fprintf('Num. erros: %d',nErros);

dados = struct;



function struct = incializa_ed(len)
    %inicializa estrutura de dados    

    struct.ASM = zeros(len,4);
    struct.contrast = zeros(len,4);
    struct.correlation = zeros(len,4);
    struct.variance = zeros(len,4);
    struct.IDM = zeros(len,4);
    struct.sum_average = zeros(len,4);
    struct.sum_variance = zeros(len,4);
    struct.sum_entropy = zeros(len,4);
    struct.entropy = zeros(len,4);
    struct.diff_variance = zeros(len,4);
    struct.diff_entropy = zeros(len,4);
    struct.intensity = zeros(len,1);    
