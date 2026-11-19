function [dX] = ThreeBodyProblemEOM(X,mu)
%ThreeBodyProblemEOM is a function used in ASEN 5050 CPHW3 in the
%   ode45 funciton to model circular restricted three body problem.
%-----------------------inputs---------------------------------------------
%   X - (12,1) double - state vector that takes the form of X = [r;v;phi] 
%       where r is the (2,1) position vector [km], v is the (2,1) velocity 
%       vector [km/s], and phi is the (9,1) vectorized state transition 
%       matrix.
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
    X (42,1)
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
end

% Extract X variables
x = X(1);   y = X(2);   z = X(3);
dx = X(4);  dy = X(5);  dz = X(6);

% Extract Phi
Phi = X(7:end);
Phi = reshape(Phi,6,6);

% Calculate V derivatives
dVdx = x + ((mu-1)*(x+mu))/(((x+mu)^2+y^2)^(3/2)) - ...
    mu*(x+mu-1)/(((x+mu-1)^2+y^2)^(3/2));

dVdy = y + (mu-1)*y/((y^2+(mu+x)^2)^(3/2)) - mu*y/((y^2+(mu+x-1)^2)^(3/2));

% Calc acceleration terms
xaccel = 2*v + dVdx;
yaccel = -2*u + dVdy;

% Differentals
dx = u;
dy = v;
du = xaccel;
dv = yaccel;

% Make output
dX = [dx;dy;du;dv];
end