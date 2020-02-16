%% Assignment 3
% Kelvin Lu
%
% Devin Kolarac
%
clear, close all, clc;
show_imgs = 1;
%% Part 1 Least Significant Bit Data Hiding
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
for i = 0:7
    pep_and_barb = mergeNBitPlanes(peppers, barbara, i);
    bab_and_barb = mergeNBitPlanes(baboon, barbara, i);
    
    if ~show_imgs
        continue
    end
    
    figure
    imshow(pep_and_barb);
    title(["Peppers & Barbara with ", i, " merged layers"]);
    
    figure
    imshow(bab_and_barb);
    title(["Baboon & Barbara with ", i, " merged layers"]); 
end