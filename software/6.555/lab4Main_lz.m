%% Getting Started

close all;

addpath('/mit/6.555/matlab/reg/');

% Load The data
load_reg_data;

% Display the medical images
figure(655);clf;
display_image(mri,'MRI Subject 1');
figure(656);clf;
display_image(mri2,'MRI Subject 2');
figure(657);clf;
display_image(ct,'CT');
figure(658);clf;
display_image(pet,'PET');

% Display the Alien brains
figure(659);clf;
display_image(scan1,'Scan 1');
figure(660);clf;
display_image(scan2,'Scan 2');
figure(661);clf;
display_image(scan3,'Scan 3');

type sse;
type sav;


%% Alien Probbing scan1 - scan1
fixed_image  = scan1;
moving_image = scan1; 

% Set ROI
roi = ROI_ALIEN_BRAIN;

figure;
display_image(scan1,'scan1 w/ ROI');
hold on;
plot([roi(1) roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(4) roi(4) roi(3) roi(3)],'r-'); 


% Make a cell array of all objective functions you want to try out
% The @ specifies a function handle. Don't forget the @
obj_functions = {@sse,@sav,@joint_entropy,@xcorr_coeff};
  
% Specify the translations and rotations you want to probe
% For now just do dx,dy
delta_xs   = linspace(-30,30,31); 
delta_ys   = linspace(-30,30,31);
thetas     = 0;

% Set this variable to 1 to show the image transformations as we probe
ploton = -1;

% Call function 'probe'
surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);
               
% Plot Results
tIndx = 1;
[foo,cx] = min(abs(delta_xs));
[foo,cy] = min(abs(delta_ys));
sign = [1 1 1 -1];

for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,3,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,3,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,3,3);
  c = capture_region(sign(f)*surfaces{f}(:,:,tIndx),[cy;cx]);
  imagesc(delta_xs,delta_ys,c,[0 1]);
  xlabel('\delta_x');ylabel('\delta_y');
  p = 100*length(find(c(:)==1))/length(c(:));
  title(['Capture Region ' num2str(p) '%']);
end

%%  Alien Probbing scan1 - scan2 

fixed_image =  scan1;
moving_image = scan2;

% Use Original ROI
roi =  ROI_ALIEN_BRAIN;

% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,31); 
delta_ys   = linspace(-30,30,31);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% Plot the resulting surfaces
tIndx = 1;
sign = [1 1 1 -1];
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,3,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,3,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');

  % Show the alignment for each
  subplot(1,3,3);
  mi = global_extrema(sign(f)*surfaces{f});
  xi = mi{2}(1); yi = mi{1}(1);
  T_12{f} = [delta_xs(xi) delta_ys(yi) 0];
  display_alignment(scan1,image_transform(scan2,T_12{f})); axis off;
  title(['scan1 - T(scan2), T = [' num2str(T_12{f}) ' ]']);
end


%%  Alien Probbing scan1 - scan3

fixed_image =  scan1;
moving_image = scan3;

% Use Original ROI
roi =  ROI_ALIEN_BRAIN;

% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,31); 
delta_ys   = linspace(-30,30,31);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% Plot the resulting surfaces
tIndx = 1;
sign = [1 1 1 -1];
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,3,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,3,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');

  % Show the alignment for each
  subplot(1,3,3);
  mi = global_extrema(sign(f)*surfaces{f});
  xi = mi{2}(1); yi = mi{1}(1);
  T_13{f} = [delta_xs(xi) delta_ys(yi) 0];
  display_alignment(scan1,image_transform(scan3,T_13{f})); axis off;
  title(['scan1 - T(scan3), T = [' num2str(T_13{f}) ' ]']);
end
%% MRI - MRI 2 Registration

% Align MRI and MRI 2
fixed_image =  mri;
moving_image = mri2;

% Use Original ROI
roi =  ROI_MRI;

figure;
display_image(mri,'MRI w/  ROI');
hold on;
plot([roi(1) roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(4) roi(4) roi(3) roi(3)],'r-');

% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,21); 
delta_ys   = linspace(-30,30,21);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% Plot the resulting surfaces
tIndx = 1;
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,2,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,2,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
end

% Looking at our results we see all techniques have a local or global
% extrema around dx=5 to 15 and dy=0 to 10 or so. Now we will do a 3D alignment
% In this region.
delta_xs = [5:15];
delta_ys = [0:10];
thetas   = linspace(-pi/8, pi/8,9);

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

  % View the joint entropy using the volumeslicer
%volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});
              
% There seems to be a strong global min in joint entropy
mi = global_extrema(surfaces{3});
xi = mi{2}(1); yi = mi{1}(1); zi=mi{3}(1);
T_mri2 = [delta_xs(xi) delta_ys(yi) thetas(zi)]

figure;
display_alignment(mri,image_transform(mri2,T_mri2)); axis off;
colormap gray;
title(['MRI + T(MRI2), T = [' num2str(T_mri2) ' ]']);


%% MRI - MRI 2 Small ROI Registration

% Align MRI and MR 2
fixed_image =  mri;
moving_image = mri2;

% Use Small ROI
roi =  [96 141 85 155];

figure;
display_image(mri,'MRI w/ small ROI');
hold on;
plot([roi(1) roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(4) roi(4) roi(3) roi(3)],'r-');


% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,21); 
delta_ys   = linspace(-30,30,21);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% Plot the resulting surfaces
tIndx = 1;
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,2,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,2,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
end

% Looking at our results now it is hard to tell where the optimal point is.
% Joint entropy gets dx correct, and is close to 10, by dy is is hard to
% tell. For the lab you don't have to get a final alignment, but just out
% of curiosity let's search a region we know has the correct solution and
% Find the best alignment with joint entropy
delta_xs = [5:15];
delta_ys = [0:10];
thetas   = linspace(-pi/8, pi/8,9);

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

  % View the joint entropy using the volumeslicer
%volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});
              
% There seems to be a strong global min in joint entropy
mi = global_extrema(surfaces{3});
xi = mi{2}(1); yi = mi{1}(1); zi=mi{3}(1);
T_mri2 = [delta_xs(xi) delta_ys(yi) thetas(zi)]

figure;
display_alignment(mri,image_transform(mri2,T_mri2)); axis off;
colormap gray;
title(['MRI, T(MRI2) small ROI, T = [' num2str(T_mri2) ' ]']);

% As you can tell, this doesn't get the correct alignment. This shows how
% difficult registration may be if you don't have that much information.
% Normally the ROI includes the outside boundary of the brain which is a
% strong cue about whether or not you are aligned properly.

%% MRI - CT Registration
fixed_image =  mri;
moving_image = ct;

% Use Original ROI
roi =  ROI_MRI;

% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,21); 
delta_ys   = linspace(-30,30,21);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);
               
% Plot the resulting surfaces
tIndx = 1;

for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,2,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,2,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
end

% Looking at joint entropy it has a local min that seems promising at
% dx=3 and dy=12 w/ a wide valuly where dx can change with little effect
% Let's explore this region in 3D
delta_xs = [0:20];
delta_ys = [5:15];
thetas   = linspace(-pi/4, pi/4,9);

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

 % View the joint entropy using the volumeslicer
%volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});

% After doing that it seems we are right on the edge with theta = pi/8, so
% let's expand our search a little
thetas = linspace(0,pi/4,9);
surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);
 
  % View the joint entropy using the volumeslicer
%volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});
              
               
% There seems to be a strong global min in joint entropy
mi = global_extrema(surfaces{3});
xi = mi{2}(1); yi = mi{1}(1); zi=mi{3}(1);
T_ct = [delta_xs(xi) delta_ys(yi) thetas(zi)]

figure;
display_alignment(mri,image_transform(ct,T_ct)); axis off;
colormap gray;
title(['MRI + T(CT), T = [' num2str(T_ct) ' ]']);

%% MRI - PET Registration
fixed_image =  mri;
moving_image = pet;

% Use Original ROI
roi =  ROI_MRI;

% First we will do a quick translation only alignment
delta_xs   = linspace(-30,30,21); 
delta_ys   = linspace(-30,30,21);
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);
               
% Plot the resulting surfaces
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,3,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,3,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
end

% Looking at joint entropy it has a clear local minimum at dx = -12 and
% dy=-6. We will explore this area in 3D
delta_xs = [-20:-10];
delta_ys = [-10:0];
thetas   = linspace(-pi/8, pi/8,9);

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% View the joint entropy using the volumeslicer
%h = volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});
               
% There seems to be a strong global min in joint entropy again
mi = global_extrema(surfaces{3});
xi = mi{2}(1); yi = mi{1}(1); zi=mi{3}(1);
T_pet = [delta_xs(xi) delta_ys(yi) thetas(zi)]

figure;
display_alignment(mri,image_transform(pet,T_pet)); axis off;
colormap gray;
title(['MRI + T(PET), T = [' num2str(T_pet) ' ]']);

%% Coarse-to-Fine
D = 8;
% Downsample the images. Use the 'bilinear' option so that imresize
% uses a lowpass filter.
mri_d = imresize(mri,1/D,'bilinear',20);
mri2_d = imresize(mri2,1/D,'bilinear',20);
figure;
subplot(1,2,1); display_image(mri_d,'MRI Downsampled');
subplot(1,2,2); display_image(mri2_d, 'MRI2 Downsampled');

% Align MRI and MRI_Trunc downsampled
fixed_image =  mri_d;
moving_image = mri2_d;

% Use Original ROI
roi =  ROI_MRI/D;

% First we will do a quick translation only alignment
delta_xs   = -4:4; 
delta_ys   = -4:4;
thetas     = 0;

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% Plot the resulting surfaces
tIndx = 1;
for f=1:length(obj_functions)
  figure(655+f); clf; set(gcf,'Position',[1 1 1200 300]);
  subplot(1,2,1);
  surf(delta_xs,delta_ys,surfaces{f}(:,:,tIndx)); colormap default; colorbar;
  xlabel('\delta_x');ylabel('\delta_y'); zlabel(func2str(obj_functions{f}),'interpreter','none');
  title(['Probe surface using ' func2str(obj_functions{f})],'interpreter','none');
  
  subplot(1,2,2);
  contour(delta_xs,delta_ys,surfaces{f}(:,:,tIndx),100,'lineWidth',1);colormap default;
  [mis,mxs] = local_extrema(surfaces{f}(:,:,tIndx));
  [gmi,gmx] = global_extrema(surfaces{f}(:,:,tIndx));
  hold on;
  plot(delta_xs(mxs{2}),delta_ys(mxs{1}),'kx','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(mis{2}),delta_ys(mis{1}),'ko','lineWidth',2,'MarkerSize',8);
  plot(delta_xs(gmx{2}),delta_ys(gmx{1}),'kd','lineWidth',2,'MarkerSize',12);
  plot(delta_xs(gmi{2}),delta_ys(gmi{1}),'ks','lineWidth',2,'MarkerSize',12);
  xlabel('\delta_x');ylabel('\delta_y');
  title(['Probe surface contours using ' func2str(obj_functions{f})],'interpreter','none');
end

% Looking at our resultsit's there are a few global extrema, most show up
% around dx in the range from 0 to 2 and dy between -1 and 1. 
% So let's do a coarse search over the 3D space in that area.
delta_xs = [0:2];
delta_ys = [-1:1];
thetas   = linspace(-pi/8, pi/8,9);

surfaces = probe(fixed_image, moving_image, roi, obj_functions, ...
                 delta_xs,delta_ys,thetas,ploton);

% View the joint entropy using the volumeslicer
%volumeslicer(surfaces{3},'DimNames',{'dy','dx','theta'},'DimRanges',{delta_ys,delta_xs,thetas});
              
% It's not so easy to see in the volume slicer tool. It doesn't look so
% smooth. Let's just get the global minimum
mi = global_extrema(surfaces{3});
xi = mi{2}(1); yi = mi{1}(1); zi=mi{3}(1);
T_d = [delta_xs(xi) delta_ys(yi) thetas(zi)]
T_d2 = T_d .* [D D 1];

figure;
subplot(2,1,1);
display_alignment(mri_d,image_transform(mri2_d,T_d)); axis off;
colormap gray;
title(['Coarse MRI + T(MRI 2), T = [' num2str(T_d) ' ]']);
subplot(2,1,2);
display_alignment(mri,image_transform(mri2,T_d2)); axis off;
colormap gray;
title(['Coarse MRI + T(MRI 2) in Full Res, T = [' num2str(T_d2) ' ]']);

% This was achieved with much less computation. This gives a decent 
% alignment, but not that great. We could further

%% Automated search

% For this use the entire image as the ROI
roi =  ROI_MRI;

% This is my wrapper function
type wrapper.m

% Next try MRI CT
opt = optimset('Display','iter');
T_ct_search = fminsearch6555(@(x) wrapper(x,mri,ct,@joint_entropy,roi),[30 30 0],[5 5 pi/16],opt)

figure;
display_alignment(mri,image_transform(ct,T_ct_search)); axis off;
colormap gray;
title(['MRI + T(CT) search, T = [' num2str(T_ct_search) ' ]']);
