function [data] = singleShootingContFun(X0,Xf,mu,tspan,namestr)
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
InitalPos = X0(1:4);

% Get inital adjoint
P_0 = X0(5:end);

% Perform Shooting Algorithum
tol = 1e-10; % Set tolerance
c = 0;  % Initalize counter
G = ones(size(InitalPos));
warning('off', 'MATLAB:ode113:IntegrationTolNotMet');
while abs(norm(G)) > tol
    % Update counter
    c = c + 1;

    % Stop if we could not find a periodic orbit
    % if c > 120
    %     warning("Could not find a Periodic Orbit")
    %     data.("Iteration" + c).X0 = nan(size(X0));
    %     data.("Iteration" + c).X = nan(size(X));
    %     data.("Iteration" + c).t = nan(size(t));
    %     data.("Iteration" + c).X0_adjust = nan(size(X0));
    %     data.("Iteration" + c).flag = false;
    %     break
    % end
    lastwarn('');   % clear previous warning

    % Call ODE
    [t,X] = ode113(@(t,X) NondimenThreeBodyProblemEOM(X,mu),...
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

    % Calculate G
    G = Xf- transpose(X(end,1:4));

    % Finite Difference
    delPj = 1e-8;
    delP = [[delPj;0;0;0],[0;delPj;0;0],[0;0;delPj;0],[0;0;0;delPj]];
    dGdP = nan(4);
    for idx = 1:length(delP)
        delX0 = X0 + [0;0;0;0;delP(:,idx)];
        [~,dX] = ode113(@(t,X) NondimenThreeBodyProblemEOM(X,mu),...
            tspan,delX0,opts);
        dG = Xf- transpose(dX(end,1:4));
        dGdP(:,idx) = (dG - G) ./  delPj;
    end

    % Update adjoint
    xi = 0.1;
    P_0 = P_0 - xi.*(dGdP \ G);
    X0 = [InitalPos;P_0];

    % Save adjustments
    data.("Iteration" + c).P_adjust = P_0;

    % Display information
    fprintf("Iteration " + c + " Error = %.9f \n",abs(norm(G)));
    fprintf("   New P0 = [%.5f, %.5f, %.5f, %.5f]\n\n",...
        P_0)
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