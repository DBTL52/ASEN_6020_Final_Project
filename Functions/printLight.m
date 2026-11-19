function printLight(fig,fileName)
%printLight is a function that MATLAB doesn't have for some reason. It
%   allows the users to print out figures as png's without flashbanging
%   them in dark mode. It does this by making the figure invisible,
%   switching to light mode, saving, switching back to dark mode, and then
%   making the figure visible again.
%-----------------------inputs---------------------------------------------
%   fig - the MATLAB figure that is to be saved. [If saving multiple
%         figures, use gcf as the input]
%   fileName - the file path that the figure is to be saved to.
%
% Author: Decker Lazzeri
% Last Mod: 12/2/2025

% Incase the user wants to use windowsize
pause(1)
% Making the figure invisible if required
if fig.Visible == "on"
    fig.Visible = "off";
end

% Setting to light and saving
fig.Theme = "light";
% Pause to make sure the fig is saved in light before switching to dark.
%pause(1)
saveas(fig, fileName + ".png")
% Pause to make sure the fig is saved in light before switching to dark.
%pause(1)
fig.Theme = "dark";

% Bringing the figure back up
fig.Visible = "on";
end