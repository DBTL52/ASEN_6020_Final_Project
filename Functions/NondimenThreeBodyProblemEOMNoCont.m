function [dX] = NondimenThreeBodyProblemEOMNoCont(X,mu)
%ThreeBodyProblemEOM is a function used in ASEN 5050 CPHW3 in the
%   ode45 funciton to model circular restricted three body problem.
%-----------------------inputs---------------------------------------------
%   X - (20,1) double - state vector that takes the form of where r is the 
%       (2,1) position vector, v is the (2,1) velocity vector, and p is 
%       the (16,1) Phi.
%   mu - double - orbit body gravitational parameter. [km^3/s^2]
%-----------------------outputs--------------------------------------------
%   dX - (20,1) double - derivative of the state vector that takes the form 
%       of X = [dr;dv;dphi] where dr is the (2,1) position vector 
%       derivative [km/s], dv is the (2,1) velocity vector derivative 
%       [km/s^2], and dphi is the (9,1) state transition matrix derivative.
%
% Author: Decker Lazzeri
% Last Mod: 11/21/2026

% Arguments
arguments
    X (20,1)
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
end

% Extract State Variables
x = X(1);   y = X(2);   dx = X(3);  dy = X(4);

% Pull out Phi
Phi = X(5:end);
Phi = reshape(Phi,4,4);

% Calculate V derivatives
[Vx,Vy,Vxx,Vyy,Vxy] = getPartials(x,y,mu);

% Find dPhi
Gamma = [0 0 1 0; 0 0 0 1; Vxx Vxy 0 2; Vxy Vyy -2 0];
dPhi = Gamma * Phi;
dPhi = dPhi(:);

% Calc acceleration terms
ddx = 2*dy + Vx;
ddy = -2*dx + Vy;

% Make output
dX = [dx;dy;ddx;ddy;dPhi];
end