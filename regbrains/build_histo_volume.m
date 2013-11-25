function build_histo_volume(direc)

if direc(end) ~= '/'
    direc = [direc '/'];
end

files = dir(strcat(direc,'dramms*.nii'));
nFiles = length(files);

volume = [];
for f=1:nFiles
    name = strcat(direc,files(f).name);
    img = load_nifti(name);
    volume = cat(3, volume, img.vol);
end

mgz.vol = volume;

MRIwrite(mgz,strcat(direc,'histo_volume.mgz'));