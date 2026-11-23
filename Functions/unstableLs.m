function [L1,L2,L3] = unstableLs(mu)
%UNSTABLELS generates the x-positions of the three unstable lagrange
%points, where the are defined as: L1 is between primary and secondary, L2
%is right of the secondary, and L3 is left of the primary
% - Inputs - 
%   - mu: mass parameter of the primary and the secondary bodies
% - Outputs -
%   - L1: x-position of L1 lagrange point
%   - L2: x-position of L2 lagrange point
%   - L3: x-position of L3 lagrange point

    dUdx = @(x) x ...
        - ((1 - mu) * (x + mu)) ./ abs(x + mu).^3 ...
        - (mu * (x - 1 + mu)) ./ abs(x - 1 + mu).^3;

    opts = optimoptions('fsolve', 'Display', 'off');
    [L1, ~, ~] = fsolve(dUdx, 1 - (mu/3)^(1/3),opts);
    [L2, ~, ~] = fsolve(dUdx, 1 + (mu/3)^(1/3),opts);
    [L3, ~, ~] = fsolve(dUdx, -1 - (5/12)*mu,opts);

end

