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
r = 0.1;
r_0 = [-mu-r;0];
v_circ = sqrt((1-mu)/r)-r;
t_f = 2.*pi.*sqrt((r^3)/(1-mu));
X0 = [r_0;0;v_circ];
out = singleShootingFun(X0,mu,[0 t_f]," Circle");

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
% Show plot in figure pop-up
if figPop == 0; set(gcf,'Visible','off'); end
% Save figure
if figSave == 1
    figName = get(gcf,"Name");
    saveas(gcf, pwd + "\Figures\" + figName + ".png")
end

%% L4
% Inital conditions
c = out.Iterations;
X0 = transpose(out.("Iteration" + c).X(end,1:4));
P_0 = [0;0;0;-0.01];    % Adjoint control transformation
X0 = [X0;P_0];

% Final Conditions
r_f = L4;   v_f = [0;0];
Xf = [r_f;v_f];

% Run Single shooting
out = singleShootingContFun(X0,Xf,mu,linspace(0,pi,200),"test");

c = out.Iterations;
x = out.("Iteration" + c).X(:,1);
y = out.("Iteration" + c).X(:,2);
dx = out.("Iteration" + c).X(:,3);
dy = out.("Iteration" + c).X(:,4);
time = out.("Iteration" + c).t;
u = nan(length(time),2);
for idx = 1:length(time)
    X = transpose(out.("Iteration" + c).X(idx,:));
    [~,u(idx,:)] = NondimenThreeBodyProblemEOM(X,mu);
end
figure()
plot(x,y)
hold on
quiver(x,y,u(:,1),u(:,2))
EarthX = -mu;
MoonX = 1-mu;
scatter(EarthX,0)
scatter(MoonX,0)
scatter(L4(1),L4(2))
hold off
grid on
axis equal

% Show plot in figure pop-up
if figPop == 0; set(gcf,'Visible','off'); end
% Save figure
if figSave == 1
    figName = get(gcf,"Name");
    saveas(gcf, pwd + "\Figures\" + figName + ".png")
end

figure()
tiledlayout(2,2)
nexttile
plot(time,dx)
subtitle("dx")
nexttile
plot(time,dy)
subtitle("dy")
nexttile
plot(time,u(:,1))
subtitle("ux")
nexttile
plot(time,u(:,2))
subtitle("uy")


% Show plot in figure pop-up
if figPop == 0; set(gcf,'Visible','off'); end
% Save figure
if figSave == 1
    figName = get(gcf,"Name");
    saveas(gcf, pwd + "\Figures\" + figName + ".png")
end