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

% Add function foulder
addpath("Functions")

%% System Parameters
mu = 0.0122;
[L1,L2,L3,L4,L5] = LagrangePoints(mu);

%% Find circular orbit
r = 0.02;
r_0 = [-mu-r;0];
v_circ = sqrt((1-mu)/r)-r;
t_f = 2.*pi.*sqrt((r^3)/(1-mu));
X0 = [r_0;0;v_circ];
out = singleShootingFun(X0,mu,[0 t_f],"test");

c = out.Iterations;
x = out.("Iteration" + c).X(:,1);
y = out.("Iteration" + c).X(:,2);
figure()
plot(x,y)
hold on
EarthX = -mu;
MoonX = 1-mu;
scatter(EarthX,0)
scatter(MoonX,0)
hold off
grid on
axis equal
