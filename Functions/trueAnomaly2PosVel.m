function [r,v] = trueAnomaly2PosVel(f,mu,a,e_hat,e,h_vec)
%trueAbomaly2PosVel is a function that takes a true anomaly and the orbital
%   elements from TwoBodyPosVel2OrbitElm and calculates the position and
%   velocity vector via the two body problem solution.
%-----------------------inputs---------------------------------------------
%   f - double - true anomaly of the orbit. [deg]
%   mu - double - orbit body gravitational parameter. [km^3/s^2]
%   e_hat - (3,1) double - Eccentricity unit vector of the orbit. []
%   e - double - eccentricity magnitude of the orbit. [km]
%   h_vec - (3,1) double - angular momentum vector of the orbit [km^2/s]
%-----------------------outputs--------------------------------------------
%   r - (3,1) double - position of the spacecraft relitive to the
%       orbit body. [km]
%   v - (3,1) double - velocity of the soacecraft relitive to the
%       orbit body. [km/s]
%
% Author: Decker Lazzeri
% Last Mod: 10/10/2025

% Arguments Check
arguments
    f double {mustBeScalarOrEmpty,mustBeNonempty}
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
    a double {mustBeScalarOrEmpty,mustBeNonempty}
    e_hat (3,1) {mustBeVector}
    e double {mustBeScalarOrEmpty,mustBeNonempty}
    h_vec (3,1) {mustBeVector}
end

% Calc h and e perp unit vectors
h_hat = h_vec./norm(h_vec);
e_hatperp = cross(h_hat,e_hat);

% Velocity Vector
v = sqrt(mu/(a*(1-e^2)));
v = v.* ...
    (-sind(f).*e_hat + ...
    (e+cosd(f)).*e_hatperp);

% Position Vector
r = (a*(1-e^2))/(1+e*cosd(f));
r = r .* ...
    (cosd(f).*e_hat + ...
    sind(f).*e_hatperp);
end