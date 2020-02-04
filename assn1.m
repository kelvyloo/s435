%% Assignment 1
% Kelvin Lu
% Devin Kolarac
%

close all; clear; clc
try_diff_gammas = 1;

%% Part 1
pout = imread('pout.tif');
figure
imshow(pout)
title("Pout.tif original")

% Try gamma correction gamma < 1
poutv1 = gamma_correction(double(pout), 0.5);
poutv1 = uint8(poutv1);

figure
imshow(poutv1)
title("Pout.tif \gamma = 0.5")

% Try gamma correction gamma > 1
poutv2 = gamma_correction(double(pout), 2.0);
poutv2 = uint8(poutv2);

figure
imshow(poutv2)
title("Pout.tif \gamma = 2.0")

% Compare pixel value histograms
figure
hold on
title("Pout.tif pixel histogram");
xlabel("Bin")
ylabel("Frequency")
imhist(poutv1)
imhist(poutv2)
legend("Gamma = 0.5", "Gamma = 2.0");
hold off

%%

% Trying different gammas
gammas = [0.25, 0.75, 1.0, 1.25, 1.5, 1.75];

moonPhobos = imread('MoonPhobos.tif');
if try_diff_gammas
    for i = 1:length(gammas)
        new_moonPhobos = gamma_correction(double(moonPhobos), gammas(i));
        new_moonPhobos = uint8(new_moonPhobos);

        figure
        imshow(new_moonPhobos);
        title(["MoonPhobos.tif \gamma = ", gammas(i)]);
    end
    figure
    for i = 1:length(gammas)
        new_moonPhobos = gamma_correction(double(moonPhobos), gammas(i));
        new_moonPhobos = uint8(new_moonPhobos);
        imhist(new_moonPhobos)
        hold on
    end
    title("MoonPhobos.tif pixel histogram");
    xlabel("Bin")
    ylabel("Frequency")
    hold off
end
%%
% Histogram Equalization
eq_moonPhobos = histeq(moonPhobos);

figure
imshow(eq_moonPhobos);
title("MoonPhobos.tif hist equalized");

figure
hold on
title("MoonPhobos.tif pixel histogram after equalization");
xlabel("Bin")
ylabel("Frequency")
imhist(eq_moonPhobos);
hold off

%% Part 2
moon = imread("moon.tiff");
alpha = 10.0;

figure
imshow(moon);
title("Moon.tiff Original");

% High boost, sharpening on Moon image
moon_boost = high_boost_filter(double(moon), alpha);
moon_boost = uint8(moon_boost);

figure
imshow(moon_boost);
title(["Moon.tiff \alpha = ", alpha]);

% Sharpening on outoffocuss.tiff
outoffocus = imread("outoffocus.tif");

figure
imshow(outoffocus);
title("outoffocus.tiff original");

focus_boost = high_boost_filter(double(outoffocus), alpha);
focus_boost = uint8(focus_boost);

figure
imshow(focus_boost);
title(["outoffocus.tiff \alpha = ", alpha]);

%% Part 3
p_noise1 = imread("peppersNoise1.tiff");
p_noise2 = imread("peppersNoise2.tiff");

figure
imshow(p_noise1);
title("peppersNoise1.tiff Original");

figure
imshow(p_noise2);
title("peppersNoise2.tiff Original");

avgMask3 = ones(3)/3.^2;
avgMask5 = ones(5)/5.^2;

%% Denoising with averaging filters
% peppersNoise1.tiff
p_noise1_avg3 = filter2(avgMask3, p_noise1);
p_noise1_avg5 = filter2(avgMask5, p_noise1);

figure
imshow(uint8(p_noise1_avg3));
title("peppersNoise1.tiff avg filter 3x3");

figure
imshow(uint8(p_noise1_avg5));
title("peppersNoise1.tiff avg filter 5x5");

% peppersNoise2.tiff
p_noise2_avg3 = filter2(avgMask3, p_noise2);
p_noise2_avg5 = filter2(avgMask5, p_noise2);

figure
imshow(uint8(p_noise2_avg3));
title("peppersNoise2.tiff avg filter 3x3");

figure
imshow(uint8(p_noise2_avg5));
title("peppersNoise2.tiff avg filter 5x5");

%% Denoising with median filters
% peppersNoise1.tiff
p_noise1_med3 = medfilt2(p_noise1, [3, 3]);
p_noise1_med5 = medfilt2(p_noise1, [5, 5]);

figure
imshow(uint8(p_noise1_med3));
title("peppersNoise1.tiff med filter 3x3");

figure
imshow(uint8(p_noise1_med5));
title("peppersNoise1.tiff med filter 5x5");

% peppersNoise2.tiff
p_noise2_med3 = medfilt2(p_noise2, [3, 3]);
p_noise2_med5 = medfilt2(p_noise2, [5, 5]);

figure
imshow(uint8(p_noise2_med3));
title("peppersNoise2.tiff med filter 3x3");

figure
imshow(uint8(p_noise2_med5));
title("peppersNoise2.tiff med filter 5x5");

%% Edge detection/map
Sx = [-1, 0, 1; ...
      -2, 0, 2; ...
      -1, 0, 1];

Sy = [-1, -2, -1; ...
       0,  0,  0; ...
       1,  2,  1];

threshold = 128;

% Edge map of 3x3 avg img
Gx = filter2(Sx, p_noise1_avg3);
Gy = filter2(Sy, p_noise1_avg3);
Gmag_avg = (Gx.^2 + Gy.^2).^(1/2);
edgemap_avg = Gmag_avg > threshold;

figure
imshow(edgemap_avg);
title("peppersNoise1.tiff avg 3x3 edge map");

% Edge map of 3x3 med img
Gx = filter2(Sx, p_noise1_med3);
Gy = filter2(Sy, p_noise1_med3);
Gmag_med = (Gx.^2 + Gy.^2).^(1/2);
edgemap_med = Gmag_med > threshold;

figure
imshow(edgemap_med);
title("peppersNoise1.tiff med 3x3 edge map");
