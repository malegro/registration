function build_blockface_volume(direc)

if direc(end) ~= '/'
    direc = [direc '/'];
end

files = dir(strcat(direc,'*.jpg'));
nFiles = length(files);

volume = [];
for f=1:nFiles
    name = strcat(direc,files(f).name);
    %img = load_nifti(name);
    img = imread(name);
    %volume = cat(3, volume, img.vol);
    volume = cat(3, volume, img);
end

mgz.vol = volume;
mgz.volres = [0.03 0.03 0.43];

MRIwrite(mgz,strcat(direc,'blockface_volume.mgz'));