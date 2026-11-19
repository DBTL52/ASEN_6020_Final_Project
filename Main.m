%% Decker Lazzeri 6020 Project Main
% This is the main code for the ASEN 6020 Final Project by Decker Lazzeri

%% Initialize
clc; clear; close all
tic
set(groot,'DefaultAxesYLimitMethod','padded')
set(groot,'DefaultAxesXLimitMethod','padded')

%% User Booleans
% Have figures in a pop-up window Boolean
figPop = true;

% Save figures Boolean
figSave = false;

% Plot Font Size
fSize = 16;
lWidth = 2;

% Section display string
secStr = ['###################################\n' ...
          '-----------  Problem %.0f  -----------\n' ...
          '###################################\n'];

% Colors
rgb = orderedcolors("gem12");

%% Make CR3BP Model
