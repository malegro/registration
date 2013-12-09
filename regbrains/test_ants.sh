#/bin/bash

ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4  # controls multi-threading
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

if [[ ${#1} -eq 0 ]] ; then
echo usage is 
echo $0 movable.tif reference.tif output.nii.gz 
exit
fi

mov=$1
ref=$2
out=$3
outp=${out%%.*}

echo comando:
echo $0 $mov $ref $outp output prefix: $outp

antsRegistration -d 2 -r [$ref,$mov,1] \
			-m meansquares[$ref,$mov,1,32] -t affine[0.10] -c 10000x1100x100 -s 4x2x1vox -f 3x3x1 -l 1 \
			-m mattes[$ref, $mov, 1,32] -t SyN[0.15] -c 30x30x20 -s 3x3x1vox -f 4x2x2 -l 1 \
			-o [$outp]

antsApplyTransforms -d 2 -i $mov -r $ref -n linear -t ${outp}1Warp.nii.gz -t ${outp}0GenericAffine.mat -o $out
ConvertImagePixelType $out ${outp}.tif 1

echo
echo
echo view result:
echo freeview $ref ${outp}.tif
echo
echo

#-m mattes[ $ref,$mov , 1 , 32, regular, 0.1 ] -t rigid[ 0.1 ] -c [1000x1000,1.e-8,20] -s 4x2vox -f 4x2 -l 1 \
#-m mattes[$ref,$mov,1,32] -t affine[0.10] -c [10000x1100x10] -s 4x2x1vox -f 3x3x1 -l 1 \
