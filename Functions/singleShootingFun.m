function [data] = singleShootingFun(X0,mu,tspan,namestr)
%singleShootingFun is a single shooting algorithum that finds periodic
%   orbits in the HR4BP system.
%-----------------------inputs---------------------------------------------
%   tspan - 1D array - The tspan variable to go into ODE
%   X0 - (4,1) - The inital state vector  [x;y;dx;dy]
%   m - double - distance parameter for the 3rd larger body
%   nu - double - mass parameter defining the relationship between the two
%       primaries
%   tend - double - the time at the end of the time span (for display
%       purposes)
%   namestr - string - A name that the user gives to display in command
%       window
%-----------------------outputs--------------------------------------------
%   out - struct - output structure type variable
%
% Author: Decker Lazzeri
% Last Mod: 10/24/2026
    
% Tighten Tolerances
opts = odeset('AbsTol',1e-12,'RelTol',1e-12);

% Get the inital positions/vec
InitalPos = X0;

% Make inital Phi
Phi0 = eye(4); Phi0 = Phi0(:);

% Make inital state with inital Phi
X0 = [X0;Phi0];

% Perform Shooting Algorithum
tol = 1e-6; % Set tolerance
c = 0;  % Initalize counter
deltX = ones(6,1);
warning('off', 'MATLAB:ode113:IntegrationTolNotMet');
while abs(norm(deltX)) > tol
    % Update counter
    c = c + 1;

    % Stop if we could not find a periodic orbit
    if c > 60
        warning("Could not find a Periodic Orbit")
        data.("Iteration" + c).X0 = nan(size(X0));
        data.("Iteration" + c).X = nan(size(X));
        data.("Iteration" + c).t = nan(size(t));
        data.("Iteration" + c).X0_adjust = nan(size(X0));
        data.("Iteration" + c).flag = false;
        break
    end
    lastwarn('');   % clear previous warning

    % Call ODE
    [t,X] = ode113(@(t,X) NondimenThreeBodyProblemEOMNoCont(X,mu),...
        tspan,X0,opts);

    % If we cannot meet tolerances, then stop and marked failed
    [~, warnID] = lastwarn;
    if strcmp(warnID, 'MATLAB:ode113:IntegrationTolNotMet')
        % Display ODE Failed
        fprintf(repmat('\b',1,numel('Running]')))
        fprintf('Failed]   ')

        % Display warning
        warning("Could not find a Periodic Orbit")

        % Save nan data
        data.("Iteration" + c).X0 = nan(size(X0));
        data.("Iteration" + c).X = nan(size(X));
        data.("Iteration" + c).t = nan(size(t));
        data.("Iteration" + c).X0_adjust = nan(size(X0));
        data.("Iteration" + c).flag = false;
        break
    end

    % Save Relavent Data
    data.("Iteration" + c).X0 = X0;
    data.("Iteration" + c).X = X;
    data.("Iteration" + c).t = t;
    data.("Iteration" + c).flag = true;

    % Pull out Phi
    PhiT = reshape(X(end,5:end),4,4);

    %Generating next step in iteration
    deltX = transpose(X(end,1:4)) - InitalPos;
    delX0 = (eye(4) - PhiT) \ deltX;
    InitalPos = InitalPos + delX0;
    X0 =  [InitalPos;Phi0];

    % Save adjustments
    data.("Iteration" + c).X0_adjust = InitalPos;

    % Display information
    fprintf("Iteration " + c + " Error = %.9f \n",abs(norm(deltX)));
    fprintf("   New X0 = [%.5f, %.5f, %.5f, %.5f]\n\n",...
        X0(1:4))
end

% Save number of iterations
data.Iterations = c;

% Display shooting is done
if data.("Iteration" + c).flag
    disp("#######################" + namestr +...
        " Shooting Successful #######################")
else
    disp("#######################" + namestr +...
        " Shooting Failed #######################")
end