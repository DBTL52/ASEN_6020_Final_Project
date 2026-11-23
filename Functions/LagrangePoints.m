function [L1,L2,L3,L4,L5] = LagrangePoints(mu)
%LAGRANGEPOINTS generates an x-y plot of the lagrange points in a system
%where only the mass parameter is given
% - Inputs - 
%   - mu: mass parameter of a "3 body" system

%L1, L2, and L3 Locations
[XL1,XL2,XL3] = unstableLs(mu);

%L4 and L5 Locations
XL4 = (1/2) - mu;
YL4 = sqrt(3) / 2;

XL5 = (1/2) - mu;
YL5 = -sqrt(3) / 2;

% Make output
L1 = [XL1;0];
L2 = [XL2;0];
L3 = [XL3;0];
L4 = [XL4;YL4];
L5 = [XL5;YL5];
end

