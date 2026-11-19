function [L1,L2,L3] = L1L2L3fun(mu)
%L1L2L3fun is a function that takes a mu value and finds the accosiated L1,
%   L2, L3 x-coordinate points assuming CR3BP. The inital guesses come from
%   Theory Of Orbits by Szebehely.
%-----------------------inputs---------------------------------------------
%   mu - double - the mu value assuming CR3BP.
%-----------------------outputs--------------------------------------------
%   L1 - double - the x-coordinate of L1 (in between the two bodies)
%   L2 - double - the x-coordinate of L2 (right of right body)
%   L3 - double - the x-coordinate of L3 (left of left body)
%
% Author: Decker Lazzeri
% Last Mod: 12/3/2025

% Define function to solve
fun = @(x) Vxfun(x,mu);

% fsolve tolerance
options = optimoptions("fsolve","Display","none",...
    "FunctionTolerance",1e-25);

% L1 solve
xpriori = (1-(mu/3)^(1/3));
xpriori = fsolve(fun,xpriori,options); % Find accurate guess
[L1,~,exitflag,~] = fzero(fun,xpriori); % Refine guess
if exitflag <= 0
    warning("L1 exit flag = " + string(exitflag) + ...
                " for mu = " + string(mu))
end

% L2 solve
xpriori = (1+(mu/3)^(1/3));
xpriori = fsolve(fun,xpriori,options); % Find accurate guess
[L2,~,exitflag,~] = fzero(fun,xpriori); % Refine guess
if exitflag <= 0
    warning("L2 exit flag = " + string(exitflag) + ...
                " for mu = " + string(mu))
end
if L1 == L2
    disp("fzero L2 is equal to L1 for mu = " + string(mu))
end

% L3 solve
xpriori = (-(1 +(5/12)*mu));
xpriori = fsolve(fun,xpriori,options); % Find accurate guess
[L3,~,exitflag,~] = fzero(fun,xpriori); % Refine guess
if exitflag <= 0
    warning("L3 exit flag = " + string(exitflag) + ...
                " for mu = " + string(mu))
end

% Vx Function
function [Vx] = Vxfun(x,mu)
    Vx = -((1-mu).*(x+mu))./(((x+mu).^2).^(3/2)) - ...
        mu.*(x+mu-1)./(((x+mu-1).^2).^(3/2)) + x;
end

end