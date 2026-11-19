function [a,eccen,omegaTilda] = circRes3BPPosVel2OrbElm(x,y,dx,dy,t)
%circRes3BPPosVel2OrbElm is a function that takes in elements of the state
%   vector in the CR3BP and time and finds the semi-major axis,
%   eccentricity, and Longitude of Periapsis in the inertial frame.
%-----------------------inputs---------------------------------------------
%   x - (nx1) double - the x-coordinates in the rotating frame
%   y - (nx1) double - the y-coordinates in the rotating frame
%   dx - (nx1) double - the velocity in the x direction in the rotating
%       frame
%   dy - (nx1) double - the vecloity in the y direction in the rotating
%       frame
%   t - (nx1) double - the time at each step
%-----------------------outputs--------------------------------------------
%   a - (nx1) double - semi-major axis in the inertial frame
%   eccen - (nx1) double - eccentricity in the inertial frame
%   omegaTilda - (nx1) double - longitude of periapsis in the inertial 
%       frame
%
% Author: Decker Lazzeri
% Last Mod: 12/3/2025

% Preallocation
a = nan(length(t),1);
eccen = nan(length(t),1);
omegaTilda = nan(length(t),1);
mu = 1;
for i = 1:length(t)
    % Make r and v vec
    r = [x(i);y(i)];
    v = [dx(i); dy(i)];

    % Make transformation matrix
    T = [cos(t(i)), -sin(t(i)); sin(t(i)), cos(t(i))];
    
    % Transform
    r_inertial = T*r;
    v_inertial = T*[v(1) - r(2) ; v(2) + r(1)];
    r_inertial = [r_inertial;0];
    v_inertial = [v_inertial;0];
    
    % Find orbital Elements
    % Angular momentum & Eccentricity vectors
    h_vec = cross(r_inertial,v_inertial);
    e_vec = (1/mu) .* cross(v_inertial,h_vec) ...
        - (r_inertial./norm(r_inertial));
    
    % Eccentricity Mag
    eccen(i) = norm(e_vec);
    
    if eccen < 1e-14
        eccen(i) = 0;
        e_vec = r_inertial;
    end
    
    % Orbit Parameter
    p = (norm(h_vec)^2)/mu;
    
    % Semi-major axis
    a(i) = p/(1-(eccen(i)^2));
    
    % Omegatilda
    omegaTilda(i) = atan2d(e_vec(2),e_vec(1));
end
end