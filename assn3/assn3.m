%% Assignment 3
% Kelvin Lu
%
% Devin Kolarac
%
clear, close all, clc;
%% Part 1 Least Significant Bit Data Hiding
show_imgs = 0;

% For part 1.1
baboon = imread("baboon.tif");
peppers = imread("peppers.tif");

% For part 1.2
wmk1 = imread("LSBwmk1.tiff");
wmk2 = imread("LSBwmk2.tiff");
wmk3 = imread("LSBwmk3.tiff");

% For part 1.3
barbara = imread("Barbara.bmp");
%% PART 1.1
for i = 0:7
    baboon_bp = getBitPlane(baboon, i);
    peppers_bp = getBitPlane(peppers, i);
    
    if ~show_imgs
        continue
    end
    
    figure
    imshow(baboon_bp);
    title(["Baboon Bit Plane ", i]);
    
    figure
    imshow(peppers_bp);
    title(["Peppers Bit Plane ", i]);
end

%% Part 1.2
for i = 0:7
    wmk1_bp = getBitPlane(wmk1, i);
    wmk2_bp = getBitPlane(wmk2, i);
    wmk3_bp = getBitPlane(wmk3, i);
    
    if ~show_imgs
        continue
    end
    
    figure
    imshow(wmk1_bp);
    title(["wmk1 Bit Plane ", i]);
    
    figure
    imshow(wmk2_bp);
    title(["wmk2 Bit Plane ", i]);
    
    figure
    imshow(wmk3_bp);
    title(["wmk3 Bit Plane ", i]);
end

%% Part 1.3
for i = 7:-1:0
    pep_and_barb = mergeNBitPlanes(peppers, barbara, i);
    bab_and_barb = mergeNBitPlanes(baboon, barbara, i);
    
    if ~show_imgs
        continue
    end
    
    figure
    imshow(pep_and_barb);
    title(["Peppers & Barbara with ", i+1, " merged layers"]);
    
    figure
    imshow(bab_and_barb);
    title(["Baboon & Barbara with ", i+1, " merged layers"]); 
end

%% Part 2 Yeung-Mintzer Watermarking
seed = 435;

%% Part 2.1
barb_watermark = getBitPlane(barbara, 7);

pep_and_barb_ym = yeungMintzer_encode(peppers, barb_watermark, seed);
bab_and_barb_ym = yeungMintzer_encode(baboon, barb_watermark, seed);

ym_pep_wm = getBitPlane(pep_and_barb_ym, 0);
ym_bab_wm = getBitPlane(bab_and_barb_ym, 0);

figure
imshow(ym_pep_wm);
title("Watermark on LSB Plane of Peppers using Yeung-Mintzer");

figure
imshow(ym_bab_wm);
title("Watermark on LSB Plane of Baboon using Yeung-Mintzer");

pep_lsb_psnr = psnr(pep_and_barb_ym, peppers);
bab_lsb_psnr = psnr(bab_and_barb_ym, baboon);

fprintf("PSNRs simple watermark merge: %.3f %.3f\n", pep_lsb_psnr, bab_lsb_psnr);

pep_wm_psnr = psnr(pep_and_barb_ym, peppers);
bab_wm_psnr = psnr(bab_and_barb_ym, baboon);

fprintf("PSNRs using Yeung-Mintzer %.3f %.3f\n", pep_wm_psnr, bab_wm_psnr);

%% Part 2.2
watermark1 = yeungMintzer_decode(pep_and_barb_ym, seed);
watermark2 = yeungMintzer_decode(bab_and_barb_ym, seed);

figure
imshow(watermark1);
title("Watermark from Peppers decoded using Yeung-Mintzer");

figure
imshow(watermark2);
title("Watermark from Baboon decoded using Yeung-Mintzer");

%% Part 2.3