function register_histo2block(root_dir)

%
% Used in full brain histology registration.
% Registers the histology slices to their corresponding block face slices.
% Uses mri_robust_register
%
% ROOT_DIR : case base directory
%

if root_dir(end) ~= '/'
    root_dir = [root_dir '/'];
end

bf_dir = strcat(root_dir,'blockface/seg/');
histo_dir = strcat(root_dir,'histology/seg/');

%bf_base = strcat(root_dir,'blockface/');
histo_base = strcat(root_dir,'histology/');

tmp_bf_dir = strcat(bf_dir,'mgz/');
tmp_histo_dir = strcat(histo_dir,'mgz/');
histo_reg_dir = strcat(histo_base,'reg1/');
histo_reg_dir2 = strcat(histo_base,'reg2/');
tmp_dir = strcat(root_dir,'tmp/');

mkdir(tmp_bf_dir);
mkdir(tmp_histo_dir);
mkdir(histo_reg_dir);
mkdir(tmp_dir);

ext = '*.tif';
%histo_ext = '*.jpg';

files = dir(strcat(bf_dir,ext));
nFiles = length(files); %blockface and histo files should have the same name.

doNifti = 1;
doRobustReg = 1;
doDRAMMS = 0;

for f = 1:nFiles
    
    fprintf('\nProcessing %s.\n',files(f).name);
    
    close all;
    
    name = files(f).name;
    idx = strfind(name,'.');
    nii_name = strcat(name(1:idx(1)),'mgz');
    
    %------------------
    % convert to MGZ
    %------------------
    if doNifti == 1
        
        fprintf('Converting images to MGZ...\n');
        
        %convert blockface
        command = sprintf('mri_convert %s %s', strcat(bf_dir,name), strcat(tmp_bf_dir,nii_name));
        [status_bf, result_bf] = system(command);
        %convert histo
        command = sprintf('mri_convert %s %s', strcat(histo_dir,name), strcat(tmp_histo_dir,nii_name));        
        [status_h, result_h] = system(command);
        
        if status_bf ~=0 || status_h ~= 0
             fprintf('Could no convert %s.\n', name);
             return;
        end       
        
    end
    
    %-------------------------
    % run mri_robust_register
    %-------------------------
    if doRobustReg == 1
        histo_img = strcat(tmp_histo_dir,nii_name); %histology
        bf_img = strcat(tmp_bf_dir,nii_name); %blockface
        result_img1 = strcat(histo_reg_dir,'mrr_',nii_name);
        lta_name = strcat(histo_reg_dir,files(f).name,'.lta');

        %command = sprintf('mri_robust_register --mov %s --dst %s --lta %s --mapmov %s --iscale --satit',histo_img,bf_img,lta_name,result_img1);
        
        command = sprintf('mri_robust_register --mov %s --dst %s --cost ROBENT --radius 7 --satit --iscale --lta %s --mapmov %s  --affine --minsize 130',histo_img,bf_img,lta_name,result_img1);
        
        %mri_robust_register --mov ../../histology/seg/mgz/220.mgz --dst ../../220.mgz --cost ROBENT --satit --iscale --lta ../../220.tif.lta --mapmov ../../mrr_220.mgz  --affine

        fprintf('Running mri_robust_register...\n');

        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running MRI_ROBUST_REGISTER in file %s.\n', files(f).name);
            disp(result);
            return;
        end
        
        % Show result    
        img1 = MRIread(result_img1);
        img2 = MRIread(bf_img);
        display_alignment(gscale(img1.vol),gscale(img2.vol));
        
    end
    
    %------------
    % run DRAMMS
    %------------    
%     if doDRAMMS == 1
%         def_img = strcat(histo_reg_dir2,'def_',nii_name,'.gz');
%         result_img2 = strcat(histo_reg_dir2,'dramms_',nii_name);
%         command = sprintf('/autofs/space/erdos_003/users/lzollei/my_stuff/software/DRAMMS/dramms-1.4.0/bin/dramms -S %s -T %s -O %s -D %s -a 0 -w 1 -x 2 -y 2 -g 0.1', result_img1, bf_img, result_img2, def_img);
% 
%         fprintf('Running DRAMMS...\n');
% 
%         [status, result] = system(command);
%         if status ~= 0
%             fprintf('Error running DRAMMS in file %s.\n', files(f).name);
%             disp(result);
%             return;
%         end    
% 
%         % Show result    
%         img1 = load_nifti(result_img2);
%         img2 = load_nifti(bf_img);
%         display_alignment(gscale(img1.vol),gscale(img2.vol));
%     end
    
end


end

