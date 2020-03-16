%% ECES 434 Assignment 5
% Kelvin Lu
%
% Devin Kolarac
close all, clear, clc;
%% Part 1: Detecting Image Contrast Enhancement

for i = 1:5
    img_name = sprintf("imageCE%d.tif", i);
    img = imread(img_name);
    
    figure
    hold on
    title([img_name, "Histogram"]);
    imhist(img);
    hold off
end

gamma = [0.7, 1.3];

for i = 1:length(gamma)
    for j = 1:3
        img_name = sprintf("unaltIm%d.tif", j);
        img = imread(img_name);
        
        new_img = gamma_correction(double(img), gamma(i));
        new_img = uint8(new_img);
        img_label = sprintf("Gamma %.1f", gamma(i));

        figure
        hold on
        title([img_name, "Histogram"]);
        imhist(img);
        imhist(new_img);
        legend("Unaltered", img_label);
        hold off
    end
end

%% Part 2: Detecting Image Resampling and Resizing