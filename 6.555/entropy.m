function [entropy_score,histogram] = entropy(image,bcount)
% ENTROPY  Image entropy estimation using histogramming
%  ENTROPY_SCORE = ENTROPY(IMAGE) estimates the entropy of an
%  image using histogramming. IMAGE is a matrix. The
%  output ENTROPY_SCORE defines the entropy of the input image.
%
%  ENTROPY_SCORE = ENTROPY(IMAGE,BUCKET_COUNT) uses the optional
%  input argument BUCKET_COUNT, which specifies the number of buckets to be used
%  for the histogramming operation. If not specified, the default value of
%  BUCKET_COUNT is 32. Note: this number should be a power of two! 

% Input argument checking
%------------------------
if ~exist('bcount')
    bcount = 32;
end;

shift = 8 - log2(bcount);

image = floor(image);

% Prepare the histogram: 
% Reorganize the intensites into a single number for MATLAB's
% 1D histogram function (assume intensities scaled 0 ... 255)
composite =   bitshift(image1, -shift); 

edges = [0 : bcount-1];

histogram = histc(composite(:), edges);
histogram(1) = 0; % get rid of bg/bg pixels

sh = sum(histogram);
histogram = histogram * (1 / (sh + (sh==0)));

entropy_score = -sum(histogram.*log2(histogram + (histogram==0)));
