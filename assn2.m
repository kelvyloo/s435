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
% Load desired image as double
im_in = double(imread('baboon.tif'));

% 8x8 discrete cosine transform matrix for loaded image
D = dctmtx(8);

% Block sizes
S = [8 8];

% Image dimensions
[rowN, colN]= size(im_in);

% Compute the DCT of the image in pixel blocks of 8x8
dct = @(block)D * block.data * D';
pixelBlock = blockproc(im_in, S, dct);

% User specified quantization table
Q = [ 
     16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99
    ];

% Quantize image with DCT coefficients
quant = @(block)(block.data) ./ Q;
pixelBlockQuant = round(blockproc(pixelBlock, S, quant));

% Reorder each block of quantized DCT coefficients
% pixelZigzag = Vector2ZigzagMtx(pixelBlockQuant(:));
% pixelEntropy = JPEG_entropy_encode(rowN,colN,64,Q,pixelZigzag)

% Dequantize image with DCT coefficients
dequant = @(block) Q .* block.data;
pixelBlockDequant = blockproc(pixelBlockQuant, S, dequant);

% Compute the inverse DCT of the image
invdct = @(block) round(D' * block.data * D);
im_out = blockproc(pixelBlockDequant, S, invdct);

% Show images
figure();
imshow(uint8(im_in));
title('Original image');
figure();
imshow(uint8(im_out));
title('Dequantized image');

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
