function eigenvalueAnalysis(data)

% Pull out the stable X and time
n = data.Iterations;
X = data.("Iteration" + n).X;
t = data.("Iteration" + n).t;

% Grid numer
grd = 1;

% Preallocation
vals = nan(length(X),4);

% Perform analysis
for idx = 1:grd:length(X)
    % Pull out Phi
    Phi = reshape(X(idx,5:end),4,4);

    % Find the eigenvalues
    val = eig(Phi);

    % Save results
    vals(idx,:) = transpose(val);
end
vals = rmmissing(vals); % remove skipped entries

% Update t
c = t(1:grd:length(X));

% Plot
theta = linspace(0,2*pi); x = cos(theta); y = sin(theta);
plot(x,y,'k--','LineWidth',2)
colormap jet
hold on
for idx = 1:4
    scatter(real(vals(:,idx)),imag(vals(:,idx)),[],c,'filled')
end
hold off
cb = colorbar('WestOutside');
cb.Limits = [0 t(end)];
cb.Label.String = "Time";
cb.Label.Interpreter = "latex";
xlabel("Real Component", Interpreter="latex")
ylabel("Imaginary Component", Interpreter="latex")
grid on
axis square