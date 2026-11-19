function [output] = L123Fun(mu,L,tspan)
%L123Fun is a function that takes in the mu and L location for the L1, L2,
% and/or L3 point in the CR3BP and calculates the trajectory via ODE45.
%-----------------------inputs---------------------------------------------
%   mu - double - the mu value assuming CR3BP
%   L - (1xm) double - the x-coordinate location of the L point
%   tspan - (1xn) double - tspan to be used in ODE45
%-----------------------outputs--------------------------------------------
%   output - struct - x and y coordinates of the trajectory labeled as
%       "xCorrdinatesm" and "yCorrdinatesm" where m is the number of L 
%       points given.
%
% Author: Decker Lazzeri
% Last Mod: 12/3/2025

v0 = [0;0];
% Set tolerances and event
opts = odeset('RelTol',2.22045e-14,'AbsTol',1e-14);
for i = 1:length(L)
    r0 = [L(i);0];
    X0 = [r0;v0];
    % ODE45 Call
    [~,X] = ode45(@(t,X) ThreeBodyProblemEOM(X,mu),tspan,X0,opts);
    output.("xCorrdiantes" + string(i)) = X(:,1);
    output.("yCorrdiantes" + string(i)) = X(:,2);
end
end
