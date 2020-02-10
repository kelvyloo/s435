%% Assignment 2
% Devin Kolarac
% Kelvin Lu

close all; clear; clc

%% Part I
% Load peppers and baboon images
imPeppers = imread('peppers.tif');
imBaboon= imread('baboon.tif');

% For each quality factor...
qFactors = [90 70 50 30 10];
psnrs = zeros(2, length(qFactors));
filesizes = zeros(2, length(qFactors));

figure(1)
hold on
grid on
title('Peppers Filesize & PSNR vs Q Factor');
ylabel('Filesize (Bytes)');
xlabel('PSNR');

figure(2)
hold on
grid on
title('Baboon Filesize & PSNR vs Q Factor');
ylabel('Filesize (Bytes)');
xlabel('PSNR');

for i = 1 : length(qFactors)
    % Save current peppers image with the ith quality factor
    imwrite(imPeppers, strcat('peppers',int2str(qFactors(i)),'.jpg'),'Quality',qFactors(i));
    
    % Get the image and calculate its PSNR
    jpgPeppers = imread(strcat('peppers',int2str(qFactors(i)),'.jpg'));
    psnrs(1, i) = round(psnr(jpgPeppers, imPeppers));
    
    % Get the image's size
    imDir = dir(strcat('peppers',int2str(qFactors(i)),'.jpg'));
    filesizes(1, i) = imDir.bytes;
    
    % Show image
    figure
    imshow(uint8(jpgPeppers));
    
    % Plot PSNR and Filesize
    figure(1)
    scatter(psnrs(1, i), filesizes(1, i));

    % Save current baboon image with the ith quality factor
    imwrite(imBaboon, strcat('baboon',int2str(qFactors(i)),'.jpg'),'Quality',qFactors(i));
    
    % Get the image and calculate its PSNR
    jpgBaboon = imread(strcat('baboon',int2str(qFactors(i)),'.jpg'));
    psnrs(2, i) = round(psnr(jpgBaboon,imBaboon));
    
    % Get the image's size
    imDir = dir(strcat('baboon',int2str(qFactors(i)),'.jpg'));
    filesizes(2, i) = imDir.bytes;
    
    % Plot PSNR and filesize
    figure(2)
    scatter(psnrs(2, i), filesizes(1, i));
    
    % Show image
    figure
    imshow(uint8(jpgBaboon));
end

figure(1)
legend(string(qFactors), 'Location', 'southeast');
hold off

figure(2)
legend(string(qFactors), 'Location', 'southeast');
hold off

%% PART 1 QUESTIONS
% *What is the relationship between the image’s file size and its quality?*
%
% The images' file size and quality are directly proportional. As the
% quality of the image increases, so does the file size and vice versa.
%
% *What distortions are introduced by JPEG compression? Why do you think
% they occur?*
%
% JPEG compression reduces the bit depth of each pixel. This is due to the
% fact that as its decoded, depending on the quality factor, more
% information will be lost so as the quality factor decreases the bit depth
% per pixel will decrease.
%
% *At what quality factor do these distortions become unacceptably strong?*
%
% Quality factor 10 - the images have very noticeable pixelation and
% contouring that occurs which are not in the higher quality images.

%% Part II
% Implement an encoder/decoder
I = im2double(imBaboon);
%   1. Segment the image into 8 × 8 pixel blocks.
for i = 1:2
    cell{i} = [8*ones(1,64), []];
end
pixelBlocks = mat2cell(I, cell{:});
%   2. Compute the DCT of each block.
pixelBlocksDct = mat2cell(dct2(I),cell{:});
%   3. Quantize these DCT coefficients using a user specified quantization table Q
%   4. Reorder each block of quantized DCT coefficients into a one-dimensional sequence using
%      zig-zag scanning. You can use ZigzagMtx2Vector.m that is provided to you to perform
%      zig-zag scanning and use Vector2ZigzagMtx.m for reconstructing the matrix from a zig-zag
%      scanned sequence.
pixelVector = cell2mat(pixelBlocksDct)';
pixelVector = pixelVector(:)';
zigzagPixels = Vector2ZigzagMtx(pixelVector);
%   5. Encode the resulting sequence. For Entropy Encoding, use the JPEG entropy encode.m
%      module provided. This function will read a matrix, in which each row represents a
%      vectorized DCT block, write a bit stream whose filename is always named as JPEG.jpg,
%      and return the length of this file. JPEG entropy encode.m is an interface for generating
%      a text file, JPEG DCTQ ZZ.txt, and running jpeg entropy encode.exe. For the entropy
%      decoding, use JPEG entropy decode.m, which performs the inverse functionality.
% The decoder should reconstruct the image by performing each of these steps in reverse

%% Part III
luminanceMatrix = [
    [16 11 10 16 24 40 51 61]
    [12 12 14 19 26 58 60 55]
    [14 13 16 24 40 57 69 56]
    [14 17 22 29 51 87 80 62]
    [18 22 37 56 68 109 103 77]
    [24 35 55 64 81 104 113 92]
    [49 64 78 87 103 121 120 101]
    [72 92 95 98 112 100 103 99]
];

% Encode peppers.tif with the encoder and record the image's size and PSNR
% change. Next, change the table and encode the image. Is it possible to 
% achieve both a lower file size and a higher PSNR? 
