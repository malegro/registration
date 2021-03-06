function plot_teste1

%
% TESTE 1:
% 3 ptos tumor
% 3 ptos sub. branca
% 3 ptos sub. cinza
% 3 ptos liquor
%

% modalidades
% t1 = 1
% t1c = 2;
% flair = 3;

mod = 2;

dir_root = '/home/nex/LSI/Mestrado/implementacao/';

% vetor de pontos [x y]
pontos.p(1).s(1).v = [178 121 165 145 183 161; %tumor
                104 135 150  75 158 171; %sub. branca
                132  60 117  74 178 182; %sub. cinza
                111  93 125 112 105 165]; %liquor
         
pontos.p(1).s(2).v = [176 117 168 162 183 137;
                99  122 141  70 153 115;
                100  65 153  63 175 176;
                116 103 108 155 129 140];
         
pontos.p(1).s(3).v = [179 121 160 140 182 152;
                105  87 98  163 149 117;
                116  76 86  176 175 177;
                114 111 109 153 131 120];
         
         
pontos.p(2).s(1).v = [109 138 74  133 86  154;
                145 127 105  75 103 189;
                122  77 128 178 84  195;
                143  94 129 104 124 149];
            
pontos.p(2).s(2).v = [73  134 106 136 91  157;            
                156 128 115  75 122 156;
                167 180 119  68 70  112
                139 106 143 150 127 134];
            
pontos.p(2).s(3).v = [78  135 104 133 93  154;
                163 151 108  75 120 163;
                146  57 152 188 101 192;
                143 135 144 120 144 135];
                
            
pontos.p(3).s(1).v = [160 172 145 183 142 174;
                112 160 109 169 151 158;
                106 168 145 157 153 160;
                135 141 124 157 124 171];
            
pontos.p(3).s(2).v = [158 173 139 173 147 188;
                110 169 116 178 150 160;
                115 181 116 177 102 185;
                136 139 134 150 122 153];
            
pontos.p(3).s(3).v = [160 170 143 175 153 187;
                92  166 104 189 170 165;
                99  181 103 174 166 165;
                103 152 129 155 131 156];

            
nPtos = 27; %3ptos/slice * 3slices * 3 paciente

ASM.v(1).ptos = zeros(nPtos,4); %tumor
ASM.v(2).ptos = zeros(nPtos,4); %sub. branca
ASM.v(3).ptos = zeros(nPtos,4); %sub. cinza
ASM.v(4).ptos = zeros(nPtos,4); %liquor

correlacao.v(1).ptos = zeros(nPtos,4);
correlacao.v(2).ptos = zeros(nPtos,4);
correlacao.v(3).ptos = zeros(nPtos,4);
correlacao.v(4).ptos = zeros(nPtos,4);

entropia.v(1).ptos = zeros(nPtos,4);
entropia.v(2).ptos = zeros(nPtos,4);
entropia.v(3).ptos = zeros(nPtos,4);
entropia.v(4).ptos = zeros(nPtos,4);

IDM.v(1).ptos = zeros(nPtos,4); %tumor
IDM.v(2).ptos = zeros(nPtos,4); %sub. branca
IDM.v(3).ptos = zeros(nPtos,4); %sub. cinza
IDM.v(4).ptos = zeros(nPtos,4); %liquor

contraste.v(1).ptos = zeros(nPtos,4);
contraste.v(2).ptos = zeros(nPtos,4);
contraste.v(3).ptos = zeros(nPtos,4);
contraste.v(4).ptos = zeros(nPtos,4);

media.v(1).ptos = zeros(nPtos,4);
media.v(2).ptos = zeros(nPtos,4);
media.v(3).ptos = zeros(nPtos,4);
media.v(4).ptos = zeros(nPtos,4);

count = 1;
  
for p=0:0
    
    p = p+1;
    
    paciente = strcat('paciente',int2str(p-1));
    dir_mascaras = strcat(dir_root,paciente,'/mascaras/');    
    nome_mask1 = strcat(dir_mascaras,paciente,'_mask_1_2class.bmp');
    nome_mask2 = strcat(dir_mascaras,paciente,'_mask_2_2class.bmp');
    nome_mask3 = strcat(dir_mascaras,paciente,'_mask_3_2class.bmp');
    nome_dados = strcat(dir_root,paciente,'/',paciente,'_data2.mat');
    
    %carrega mascaras
    mask(1).m = imread(nome_mask1);
    mask(1).m = mask(1).m(:,:,1);
    mask(2).m = imread(nome_mask2);
    mask(2).m = mask(2).m(:,:,1);
    mask(3).m = imread(nome_mask3);
    mask(3).m = mask(3).m(:,:,1);
    
    %carrega dados
    dados = load(nome_dados);
    
    
    indices(1).ind = find(mask(1).m ~= 0);
    indices(2).ind = find(mask(2).m ~= 0);
    indices(3).ind = find(mask(3).m ~= 0);    
    
    
    for s=1:3
        coords = pontos.p(p).s(s).v;
        coords_tumor = coords(1,:);
        coords_sb = coords(2,:);
        coords_sc = coords(3,:);
        coords_l = coords(4,:);
        
        for i=1:2:5            
            %ptos tumor
            x = coords_tumor(i);
            y = coords_tumor(i+1);            
            indice = sub2ind(size(mask(s).m),y,x);
            indice_no_vetor = find(indices(s).ind == indice);
            
            ASM.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).ASM(indice_no_vetor,:); 
            IDM.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).IDM(indice_no_vetor,:); 
            correlacao.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).correlation(indice_no_vetor,:);
            entropia.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).entropy(indice_no_vetor,:);
            contraste.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).contrast(indice_no_vetor,:);
            media.v(1).ptos(count,:) = dados.struct.mri(mod).s(s).sum_average(indice_no_vetor,:);
            
            %ptos sb
            x = coords_sb(i);
            y = coords_sb(i+1);            
            indice = sub2ind(size(mask(s).m),y,x);
            indice_no_vetor = find(indices(s).ind == indice);            
            
            ASM.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).ASM(indice_no_vetor,:); 
            IDM.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).IDM(indice_no_vetor,:); 
            correlacao.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).correlation(indice_no_vetor,:);
            entropia.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).entropy(indice_no_vetor,:);
            contraste.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).contrast(indice_no_vetor,:);
            media.v(2).ptos(count,:) = dados.struct.mri(mod).s(s).sum_average(indice_no_vetor,:);
            
            %ptos sc
            x = coords_sc(i);
            y = coords_sc(i+1);            
            indice = sub2ind(size(mask(s).m),y,x);
            indice_no_vetor = find(indices(s).ind == indice);
            
            ASM.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).ASM(indice_no_vetor,:); 
            IDM.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).IDM(indice_no_vetor,:); 
            correlacao.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).correlation(indice_no_vetor,:);
            entropia.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).entropy(indice_no_vetor,:);
            contraste.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).contrast(indice_no_vetor,:);
            media.v(3).ptos(count,:) = dados.struct.mri(mod).s(s).sum_average(indice_no_vetor,:);
            
            %ptos liquor
            x = coords_l(i);
            y = coords_l(i+1);            
            indice = sub2ind(size(mask(s).m),y,x);
            indice_no_vetor = find(indices(s).ind == indice);
            
            ASM.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).ASM(indice_no_vetor,:);
            IDM.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).IDM(indice_no_vetor,:); 
            correlacao.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).correlation(indice_no_vetor,:);
            entropia.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).entropy(indice_no_vetor,:);
            contraste.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).contrast(indice_no_vetor,:);            
            media.v(4).ptos(count,:) = dados.struct.mri(mod).s(s).sum_average(indice_no_vetor,:);
                        
            count = count+1;
        end        
    end
end 


%plot

%grafico 1
% plot(ASM.v(1).ptos(:),correlacao.v(1).ptos(:),'rx');
% hold on;
% plot(ASM.v(2).ptos(:),correlacao.v(2).ptos(:),'bo');
% plot(ASM.v(3).ptos(:),correlacao.v(3).ptos(:),'g+');
% plot(ASM.v(4).ptos(:),correlacao.v(4).ptos(:),'kd');
% 
% xlabel('Energia'); ylabel('Correlação');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% hold off;
% 
% %grafico 2
% figure;
% plot(contraste.v(1).ptos(:),entropia.v(1).ptos(:),'rx');
% hold on;
% plot(contraste.v(2).ptos(:),entropia.v(2).ptos(:),'bo');
% plot(contraste.v(3).ptos(:),entropia.v(3).ptos(:),'g+');
% plot(contraste.v(4).ptos(:),entropia.v(4).ptos(:),'kd');
% 
% xlabel('Contraste'); ylabel('Entropia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% hold off;
% 
% %grafico 3
% figure;
% plot(media.v(1).ptos(:),entropia.v(1).ptos(:),'rx');
% hold on;
% plot(media.v(2).ptos(:),entropia.v(2).ptos(:),'bo');
% plot(media.v(3).ptos(:),entropia.v(3).ptos(:),'g+');
% plot(media.v(4).ptos(:),entropia.v(4).ptos(:),'kd');
% 
% xlabel('Soma das médias'); ylabel('Entropia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% hold off;
% 
% %grafico 4
% figure;
% plot(media.v(1).ptos(:),contraste.v(1).ptos(:),'rx');
% hold on;
% plot(media.v(2).ptos(:),contraste.v(2).ptos(:),'bo');
% plot(media.v(3).ptos(:),contraste.v(3).ptos(:),'g+');
% plot(media.v(4).ptos(:),contraste.v(4).ptos(:),'kd');
% 
% xlabel('Soma das médias'); ylabel('Contraste');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% hold off;
% 
% 
% %grafico 5
% figure;
% plot(IDM.v(1).ptos(:),entropia.v(1).ptos(:),'rx');
% hold on;
% plot(IDM.v(2).ptos(:),entropia.v(2).ptos(:),'bo');
% plot(IDM.v(3).ptos(:),entropia.v(3).ptos(:),'g+');
% plot(IDM.v(4).ptos(:),entropia.v(4).ptos(:),'kd');
% 
% xlabel('Homogeneidade'); ylabel('Entropia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% hold off;

%grafico 3D
% figure;
% plot3(correlacao.v(1).ptos(:),entropia.v(1).ptos(:),media.v(1).ptos(:),'rx');
% hold on;
% plot3(correlacao.v(2).ptos(:),entropia.v(2).ptos(:),media.v(2).ptos(:),'bo');
% plot3(correlacao.v(3).ptos(:),entropia.v(3).ptos(:),media.v(3).ptos(:),'g+');
% plot3(correlacao.v(4).ptos(:),entropia.v(4).ptos(:),media.v(4).ptos(:),'kd');
% 
% xlabel('Correlação'); ylabel('Entropia'); zlabel('Soma das Médias');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% grid on;
% %axis square;
% hold off;
% 
% 
% %grafico 3D
% figure;
% plot3(media.v(1).ptos(:),contraste.v(1).ptos(:),ASM.v(1).ptos(:),'rx');
% hold on;
% plot3(media.v(2).ptos(:),contraste.v(2).ptos(:),ASM.v(2).ptos(:),'bo');
% plot3(media.v(3).ptos(:),contraste.v(3).ptos(:),ASM.v(3).ptos(:),'g+');
% plot3(media.v(4).ptos(:),contraste.v(4).ptos(:),ASM.v(4).ptos(:),'kd');
% 
% xlabel('Soma das médias'); ylabel('Contraste'); zlabel('Energia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% grid on;
% %axis square;
% hold off;

%grafico 3D
figure;
plot3(media.v(1).ptos(:),correlacao.v(1).ptos(:),IDM.v(1).ptos(:),'rx');
hold on;
plot3(media.v(2).ptos(:),correlacao.v(2).ptos(:),IDM.v(2).ptos(:),'bo');
plot3(media.v(3).ptos(:),correlacao.v(3).ptos(:),IDM.v(3).ptos(:),'g+');
plot3(media.v(4).ptos(:),correlacao.v(4).ptos(:),IDM.v(4).ptos(:),'kd');

xlabel('Soma das médias'); ylabel('Correlação'); zlabel('Homogeneidade');
legend('tumor','s. branca', 's. cinza', 'líquor');
grid on;
%axis square;
hold off;


% %grafico 3D
% figure;
% plot3(entropia.v(1).ptos(:),contraste.v(1).ptos(:),ASM.v(1).ptos(:),'rx');
% hold on;
% plot3(entropia.v(2).ptos(:),contraste.v(2).ptos(:),ASM.v(2).ptos(:),'bo');
% plot3(entropia.v(3).ptos(:),contraste.v(3).ptos(:),ASM.v(3).ptos(:),'g+');
% plot3(entropia.v(4).ptos(:),contraste.v(4).ptos(:),ASM.v(4).ptos(:),'kd');
% 
% xlabel('Entropia'); ylabel('Contraste'); zlabel('Energia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% grid on;
% %axis square;
% hold off;
% 
% %grafico 3D
% figure;
% plot3(entropia.v(1).ptos(:),correlacao.v(1).ptos(:),ASM.v(1).ptos(:),'rx');
% hold on;
% plot3(entropia.v(2).ptos(:),correlacao.v(2).ptos(:),ASM.v(2).ptos(:),'bo');
% plot3(entropia.v(3).ptos(:),correlacao.v(3).ptos(:),ASM.v(3).ptos(:),'g+');
% plot3(entropia.v(4).ptos(:),correlacao.v(4).ptos(:),ASM.v(4).ptos(:),'kd');
% 
% xlabel('Entropia'); ylabel('Correlacao'); zlabel('Energia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% grid on;
% %axis square;
% hold off;
% 
% 
% %grafico 3D
% figure;
% plot3(entropia.v(1).ptos(:),IDM.v(1).ptos(:),ASM.v(1).ptos(:),'rx');
% hold on;
% plot3(entropia.v(2).ptos(:),IDM.v(2).ptos(:),ASM.v(2).ptos(:),'bo');
% plot3(entropia.v(3).ptos(:),IDM.v(3).ptos(:),ASM.v(3).ptos(:),'g+');
% plot3(entropia.v(4).ptos(:),IDM.v(4).ptos(:),ASM.v(4).ptos(:),'kd');
% 
% xlabel('Entropia'); ylabel('Homogeneidade'); zlabel('Energia');
% legend('tumor','s. branca', 's. cinza', 'líquor');
% grid on;
% %axis square;
% hold off;
% 
end




