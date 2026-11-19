function [Xstable,Xunstable] = stabilityManifold(x,y,mu,A)
%stabilityManifold is a function that takes a x,y location of a L point in
%   the CR3BP, mu, and a displacement from that L point. Then it calculates
%   the linerized inital condition of the stable and unstable manifoilds.
%-----------------------inputs---------------------------------------------
%   x - double - the x-coordinates of the L point
%   y - double - the y-coordinates of the L point
%   mu - double - the mu value assuming CR3BP
%   A - double - the x displacement from the L point
%-----------------------outputs--------------------------------------------
%   Xstable - (8x1) double - two linerized inital conditions of the 
%       stability manifoild that start at either side of the L point. One 
%       side is 1-4 and the other side is 5-8.
%   Xunstable - (8x1) double - two linerized inital conditions of the 
%       unstable manifoild that start at either side of the L point. One 
%       side is 1-4 and the other side is 5-8.
%
% Author: Decker Lazzeri
% Last Mod: 12/3/2025

% PDF page 129
% Diagonal Terms (Vzz = 0)
Vxx = - (1-mu) / ((x+mu)^2+y^2)^(3/2) + ...
    (3*(1-mu)*(x+mu)^2) / ((x+mu)^2+y^2)^(5/2) + ...
    - mu / ((x+mu-1)^2+y^2)^(3/2) + ...
    (3*mu*(x+mu-1)^2) / ((x+mu-1)^2+y^2)^(5/2) + ...
    1;
Vyy = - (1-mu) / (y^2+(mu+x)^2)^(3/2) + ...
    (3*(1-mu)*y^2) / (y^2 + (mu+x)^2)^(5/2) + ...
    - mu / (y^2+(mu+x-1)^2)^(3/2) + ...
    (3*mu*y^2) / (y^2 + (mu+x-1)^2)^(5/2)+ ...
    1;
% Off-diagonal Terms (Vxz = Vyz = 0)
Vxy = (3*(1-mu)*(mu+x)*y) / (y^2+(mu+x)^2)^(5/2) + ...
    (3*mu*(mu+x-1)*y)/(y^2+(mu+x-1)^2)^(5/2); % Will be equal to Vyx
% Find the roots of the charicterisic equations
lambdaSquared = roots([1 (4-Vxx-Vyy) (Vxx*Vyy - Vxy^2)]);
% + lambda -> Unstable | - lambda -> Stable
unstableLambda = sqrt(lambdaSquared(lambdaSquared > 0));
stableLambda = -unstableLambda;
% Eigenvector coefficent
stableSlope = (stableLambda^2-Vyy) / (2*stableLambda-Vxy);
unstableSlope = (unstableLambda^2-Vyy) / (2*unstableLambda-Vxy);
% Find X = [dx;dy;dx';dy']
Xstable = A.*[1;stableSlope;stableLambda;stableLambda*stableSlope];
Xunstable = ...
    A.*[1;unstableSlope;unstableLambda;unstableLambda*unstableSlope];
% Expand X to have both "sides" of the manifolds
Xstable = [Xstable ; -Xstable];
Xunstable = [Xunstable ; -Xunstable];
% Move displacements to the L point
Xstable(1) = Xstable(1) + x; Xstable(5) = Xstable(5) + x;
Xunstable(1) = Xunstable(1) + x; Xunstable(5) = Xunstable(5) + x;
end