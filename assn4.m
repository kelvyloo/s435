%% Assignment 4
% Devin Kolarac
%
% Kelvin Lu
%
clear, close all, clc;

%% Part 2 Detecting JPEG Compression Using Blocking Artifacts
blockArtifacts1 = imread('blockArtifacts1.tif');
k1 = blockDetect(blockArtifacts1); 

blockArtifacts2 = imread('blockArtifacts2.tif');
k2 = blockDetect(blockArtifacts2); 

blockArtifacts3 = imread('blockArtifacts3.tif');
k3 = blockDetect(blockArtifacts3);