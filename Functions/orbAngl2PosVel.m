function [r,v] = orbAngl2PosVel(rp,i,RAAN,omega,e,mu)
%orbAngl2PosVel is a function that takes the orbital element angles
%   inclination, right ascension of the ascending node, and argument of
%   periapsis and calculates the position and velocity vector using the two
%   body problem solution.
%-----------------------inputs---------------------------------------------
%   rp - double - magnitude of the radius at periapsis. [km]
%   i - double - inclination of the orbt. [deg]
%   RAAN - double - right ascension of the ascending node of the orbit.
%       [deg]
%   omega - double - argument of periapsis of the orbit. [deg]
%   e - double - magnitude of the eccentricity of the orbit. 
%   mu - double - orbit body gravitational parameter. [km^3/s^2]
%-----------------------outputs--------------------------------------------
%   r - (3,1) double vector - position of the spacecraft relitive to the
%       orbit body. [km]
%   v - (3,1) double vector - velocity of the soacecraft relitive to the
%       orbit body. [km/s]
%
% Author: Decker Lazzeri
% Last Mod: 10/03/2025

% Arguments Check
arguments
    rp double {mustBeScalarOrEmpty,mustBeNonempty}
    i double {mustBeScalarOrEmpty,mustBeNonempty}
    RAAN double {mustBeScalarOrEmpty,mustBeNonempty}
    omega double {mustBeScalarOrEmpty,mustBeNonempty}
    e double {mustBeScalarOrEmpty,mustBeNonempty}
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
end

% Calculate Eccentricity unit vector
e_hat = [cosd(omega)*cosd(RAAN) - cosd(i)*sind(omega)*sind(RAAN);...
    cosd(omega)*sind(RAAN) + cosd(i)*sind(omega)*cosd(RAAN);...
    sind(omega)*sind(i)];

% Calculate angular momentum unit vector
h_hat = [sind(RAAN)*sind(i); -cosd(RAAN)*sind(i); cosd(i)];

% Calculate semi-major axis
a = rp/(1-e);

% Calculate postion and velocity
[r,v] = trueAnomaly2PosVel(0,mu,a,e_hat,e,h_hat);
end