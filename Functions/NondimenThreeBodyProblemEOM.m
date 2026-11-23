function [dX] = NondimenThreeBodyProblemEOM(X,mu)
%ThreeBodyProblemEOM is a function used in ASEN 5050 CPHW3 in the
%   ode45 funciton to model circular restricted three body problem.
%-----------------------inputs---------------------------------------------
%   X - (8,1) double - state vector that takes the form of where r is the 
%       (2,1) position vector, v is the (2,1) velocity vector, and p is 
%       the (4,1) Adjoints.
%   mu - double - orbit body gravitational parameter. [km^3/s^2]
%-----------------------outputs--------------------------------------------
%   dX - (12,1) double - derivative of the state vector that takes the form 
%       of X = [dr;dv;dphi] where dr is the (2,1) position vector 
%       derivative [km/s], dv is the (2,1) velocity vector derivative 
%       [km/s^2], and dphi is the (9,1) state transition matrix derivative.
%
% Author: Decker Lazzeri
% Last Mod: 11/21/2026

% Arguments
arguments
    X (8,1)
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
end

% Extract State Variables
x = X(1);   y = X(2);   dx = X(3);  dy = X(4);

% Extract Adjoints
p_r = X(5:6);   p_v = X(7:8);

% Make control law
u = -p_v;

% Calculate V derivatives
[Vx,Vy,Vxx,Vyy,Vxy] = getPartials(x,y,mu);

% Calculate adjoints differentals
dp_r = -transpose(p_v) * [Vxx, Vxy; Vxy, Vyy];
dp_v = -p_r + transpose(p_v) * [0,2;-2,0];

% Calc acceleration terms
ddx = 2*dx + Vx + u(1);
ddy = -2*dy + Vy + u(2);

% Make output
dX = [dx;dy;ddx;ddy;dp_r;dp_v];
end