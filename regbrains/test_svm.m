function test_svm

mask_name = '040mask.tif';
train_name = '040.jpg';
test_name = '048.jpg';

mask = imread(mask_name);
train_img = imread(train_name);
test_img = imread(test_name);


%
%train
%
yiq = rgb2ntsc(train_img);
Y_train = yiq(:,:,1);
I_train = yiq(:,:,2);
Q_train = yiq(:,:,3);

R_train = double(train_img(:,:,1));
G_train = double(train_img(:,:,2));
B_train = double(train_img(:,:,3));

idx_fore = find(mask == 1);
nFore = length(idx_fore); %no. foreground pixels 
idx_back = find(mask == 0);
nBack = length(idx_back);
idx_rnd = randperm(nFore);

nFore = nFore/5;
idx_fore = idx_fore(idx_rnd(1:nFore));

fore_class = -1*ones(nFore,1);
%fore = cat(2, Y_train(idx_fore), I_train(idx_fore), Q_train(idx_fore));
%fore = cat(2,  I_train(idx_fore), Q_train(idx_fore));
%fore = cat(2, R_train(idx_fore), G_train(idx_fore), B_train(idx_fore));
%fore = cat(2, R_train(idx_fore), G_train(idx_fore), B_train(idx_fore), I_train(idx_fore), Q_train(idx_fore));

idx_rnd = randperm(nBack);
idx_back = idx_back(idx_rnd(1:nFore)); %same no. of foreground pixels
back_class = ones(nFore,1);

%back = cat(2, Y_train(idx_fore), I_train(idx_back), Q_train(idx_back));
%back = cat(2, I_train(idx_back), Q_train(idx_back));
%back = cat(2, R_train(idx_back), G_train(idx_back), B_train(idx_back));
%back = cat(2, R_train(idx_back), G_train(idx_back), B_train(idx_back), I_train(idx_back), Q_train(idx_back));

train_vec = cat(1,fore,back);
train_vec = rescale2(train_vec); %rescale to [-1,1]

labels = cat(1,fore_class,back_class);

%train SVM
model = svmtrain(labels,train_vec,'-c 1 -g 2 -b 1');

%
%test
%
yiq = rgb2ntsc(test_img);
Y_test = yiq(:,:,1);
I_test = yiq(:,:,2);
Q_test = yiq(:,:,3);

R_test = double(test_img(:,:,1));
G_test = double(test_img(:,:,2));
B_test = double(test_img(:,:,3));

%test_vec = cat(2,Y_test(:), I_test(:), Q_test(:));
%test_vec = cat(2, I_test(:), Q_test(:));
%test_vec = cat(2,R_test(:), G_test(:), B_test(:));
%test_vec = cat(2,R_test(:), G_test(:), B_test(:), I_test(:), Q_test(:));


test_vec = rescale2(test_vec);

labels_test = ones(size(test_vec,1),1);
[classes, prec, prob] = svmpredict(labels_test, test_vec, model);

[r c N] = size(test_img);
seg = zeros(r,c);
seg(classes == -1) = 1;
imshow(seg);




