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
% Load desired image
im_in = imread('baboon.tif');

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

% Run implemented encoder
[len, im] = diyEncoder(im_in, Q);

% Run implemented decoder
im = diyDecoder(im, Q);

% % Dequantize image with DCT coefficients
% dequant = @(block) Q .* block.data;
% im = blockproc(im, size(Q), dequant);
% 
% % Compute the inverse DCT of the image
% invdct = @(block) idct2(block.data);
% im = blockproc(im, size(Q), invdct);

% Show images
figure();
imshow(uint8(im_in));
title('Original image');
figure();
imshow(uint8(im));
title('Dequantized image');

%% Part IIIA
% Standard liminance quantization matrix
luminanceMatrix = [
    [16 11 10 16 24  40  51  61 ]
    [12 12 14 19 26  58  60  55 ]
    [14 13 16 24 40  57  69  56 ]
    [14 17 22 29 51  87  80  62 ]
    [18 22 37 56 68  109 103 77 ]
    [24 35 55 64 81  104 113 92 ]
    [49 64 78 87 103 121 120 101]
    [72 92 95 98 112 100 103 99 ]
];

% Load desired image
imPeppers = imread('peppers.tif');

% Run implemented encoder
[len, im] = diyEncoder(imPeppers, luminanceMatrix);

im = diyDecoder(im, luminanceMatrix);

im = uint8(im);
im_psnr = psnr(im, imPeppers)

imPeppersDir = dir('peppers.tif');
imPeppersSize = imPeppersDir.bytes

imwrite(im,'peppers.jpg');
imDir = dir('peppers.jpg');
imSize = imDir.bytes

%% Part IIIB
qFactor = 100
luminanceMatrix = qMatGenerator(qFactor)

% Load desired image
imPeppers = imread('peppers.tif');
figure
imshow(imPeppers);

% Run implemented encoder
[len, im] = diyEncoder(imPeppers, luminanceMatrix);

im = diyDecoder(im, luminanceMatrix);

im = uint8(im);
figure
imshow(im);
im_psnr = psnr(im, imPeppers)

imPeppersDir = dir('peppers.tif');
imPeppersSize = imPeppersDir.bytes

imwrite(im,'peppersMod.jpg');
imDir = dir('peppersMod.jpg');
imSize = imDir.bytes
%% PART 3 QUESTIONS
% *Is it possible to achieve both a lower file size and a higher PSNR?*