function [h_vec,e_vec,e,a,i,Energy,RAAN,omega,f,tp,orbitType] =...
    TwoBodyPosVel2OrbitElm(r0,v0,t0,mu)
%TwoBodyPosVel2OrbitElm is a function that takes in inital position and 
%   velocity vector at a specified time and finds the orbital elements of
%   the orbit via the two body problem solution. If the orbital element
%   does not exist, it is asigned NaN.
%-----------------------inputs---------------------------------------------
%   r0 - (3,1) double - position of the spacecraft relitive to the 
%       orbit body. [km]
%   v0 - (3,1) double - velocity of the spacecraft relitive to the 
%       orbit body. [km/s]
%   t0 - double - time during when r0 and v0 where measured. [sec]
%   mu - double - orbit body gravitational parameter. [km^3/s^2]
%-----------------------outputs--------------------------------------------
%   h_vec - (3,1) double - angular momentum vector of the orbit [km^2/s]
%   e_vec - (3,1) double - eccentricity vector of the orbit. [km]
%   e - double - Eccentricity of the orbit. [km]
%   a - double - semi-major axis of the orbit. [km]
%   i - double - inclination of the orbit. [deg]
%   Energy - double - Specific energy of the orbit. [(km/s)^2]
%   RAAN - double - Right Accention of the Accending Node of the orbit.
%       [deg]
%   omega - double - Argument of Periapsis of the orbit. [deg]
%   f - double - true anomaly at time t0. [deg]
%   tp - double - the time of periapsis of the orbit. [sec]    
%   orbitType - string - The type of orbit (Circular, Elliptic, Hyperbolic,
%       Parabolic)
%
% Author: Decker Lazzeri
% Last Mod: 10/14/2025

% Arguments Check
arguments
    r0 (3,1)
    v0 (3,1)
    t0 double {mustBeScalarOrEmpty,mustBeNonempty}
    mu double {mustBeScalarOrEmpty,mustBeNonempty}
end

% Calc integrals of motion
h_vec = cross(r0,v0);                           % Angular Momentum
e_vec = (1/mu) .* cross(v0,h_vec) - (r0./norm(r0));   % Eccentricity

% Eccentricity
e = norm(e_vec);

% Statement of orbit type
if e < 1e-14
    orbitType = "Circular";
    e = 0;
    e_vec = r0;
elseif e < 1
    orbitType = "Elliptic";
elseif e == 1
    orbitType = "Parabolic";
elseif e > 1
    orbitType = "Hyperbolic";
else
    warning("Negitive Eccentricity, check inputs")
    return
end
9
h_hat = h_vec./norm(h_vec);
e_hat = e_vec./norm(e_vec);

% Orbit Parameter
p = (norm(h_vec)^2)/mu;

% Semi-major axis
a = p/(1-(e^2));

% Inclination
i = acosd(dot(h_hat,[0;0;1]));

% Energy
Energy = .5*norm(v0)^2 - mu/norm(r0);

% Right Accention of the Accending Node
if i ~= 0 || i ~= 180
    node_vec = cross([0;0;1],h_hat)./norm(cross([0;0;1],h_hat));
    RAAN = atan2d(dot([0;1;0],node_vec),dot([1;0;0],node_vec));

    perpNode_vec = cross(h_hat,node_vec);
    
    % Argument of Periapsis
    if e ~= 0
        omega = atan2d(dot(e_vec,perpNode_vec),dot(e_vec,node_vec));
    else
        omega = nan;
    end
else
    RAAN = nan;
end

% True Anomaly
e_hatperp = cross(h_hat,e_hat);
f = atan2d(dot(r0,e_hatperp),dot(r0,e_hat));

% Eccentric Anomaly and Time of Pariapsis
if orbitType == "Elliptic"
    E = 2*atan2(sqrt(1-e)*tand(f/2),sqrt(1+e));
    tp = t0 - sqrt((a^3)/mu)*(E-e*sin(E));

elseif orbitType == "Parabolic"
    tp = t0 - .5*sqrt(p^3/mu)*tand(f/2)*(1+(1/3)*tand(f/2)^2);

elseif orbitType == "Hyperbolic"
    F = 2*atanh((sqrt(e-1)*tand(f/2))/sqrt(e+1));
    tp = t0 + sqrt(abs(a)^3/mu)*(F-e*sin(F));
elseif orbitType == "Circular"
    tp = t0;
end
end