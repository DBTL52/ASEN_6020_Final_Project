function [X,U,t] = RK4CR3BPODE(EOMfuncHandel,controlFunctionHandel,...
    X0,tmax,tstep)
%RK4CR3BPODE is a RK4 integrator that includes control and EOM based on the
%   function handels given.
%-----------------------inputs---------------------------------------------
%   EOMfuncHandel - func - Function handel for S/C EOM 
%       [inputs: (State Vector Xn, control torque u)]
%   controlFunctionHandel - func - Function handel for S/C control Law
%       [inputs: (State Vector Xn, time t)]
%   X0 - (4,1) - Attitude state vector [x,y,dx,dy]
%   tmax - double - The end time of integration
%   tstep - double - The delta time step used by the RK4
%-----------------------outputs--------------------------------------------
%   X - (N,4) - State vector at every N time step
%   U - (N,3) - 3D control law toruqe applied at every N time step
%   t - (N,1) - Time vector with every N time step
%
% Author: Decker Lazzeri
    
    % Time array
    tn = transpose(0:tstep:tmax-tstep);
    Xn = X0;
    
    % Preallocate X
    n = size(tn,1);
    X = nan(n+1,6);
    U = nan(n+1,3);
    X(1,:) = X0;
    U(1,:) = zeros(1,3);
    for idx = 1:n
        % Control Law if req
        u = controlFunctionHandel(Xn,tn(idx));

        % ODE RK4
        k1 = tstep.*EOMfuncHandel(Xn,u);
        k2 = tstep.*EOMfuncHandel(Xn + k1./2,u);
        k3 = tstep.*EOMfuncHandel(Xn + k2./2,u);
        k4 = tstep.*EOMfuncHandel(Xn + k3,u);

        % Save new step's state vector
        Xn = Xn + (1/6).*(k1 + 2.*k2 + 2.*k3 + k4);
        if norm(Xn(1:3)) > 1
            Xn(1:3) = -Xn(1:3)./(norm(Xn(1:3))^2);
        end
        % Save current tn data
        X(idx+1,:) = Xn;
        U(idx+1,:) = u;
    end
    % Save time
    t = [tn;tmax];
end