function dispLaTeX(object,name,digitnum,variablename,unit)
%dispLaTeX will display a object in the command window and make a .TEX 
%   file that can be used in a LaTeX document for math representation.
%-----------------------inputs---------------------------------------------
%   object - - The MatLab Table/Matrix/Vector that the user wants a .TEX
%       file for.
%   name - string - The name of the .TEX file and the reference name if it
%       is a table. LaTeX: \ref{tab:name}
%   digitnum - double - the number of digits after the decimal that is
%       required. (only for matrix and vector)
%   variablename - cell array of strings - the variable that the matrix 
%       or vector is equal to. SEE BELOW FOR EXAMPLE
%   unit - string - The units of the matrix or vector if wanted. If no unit
%       is wanted, leave empty.
%-----------------------outputs--------------------------------------------
%   name.tex - .tex file - .tex file saved into "Math" folder.
%
% References:
%   [1]: mathworks.com/matlabcentral/fileexchange/69063-matlab-table-to-...
%           latex-conversor
%
% Last Mod: 10/27/2025

%% Examples
% Table (Table type that is called table) 
%   Input: dispLaTeX(Table,"TableFile")
%
% Matrix (Matrix that is called Mat, display two digits after decimal, 
%   equal to M)
%   Input: dispLaTeX(Mat,"MatFile",2,{"M"})
%
% Vector (Vector that is called dX, display two digits after decimal, equal
%   to [deltax;deltay;deltaz]
%   Input: dispLaTeX(dX,"dX",2,{"\\delta x","\\delta y","\\delta z"})

%% Tips
%   - To use LaTeX math symbols you need to add another "\", IDK exactly
%       why.
%   - To use in your Overleaf doc use the following for an "example.tex" 
%       file in your Overleaf: \input{example}
%   - This function will overwrite .tex files if the "name"s are the same.

arguments
    object 
    name (1,1) string 
    digitnum double {mustBeScalarOrEmpty} = []
    variablename cell = {""}
    unit string = ""
end
%% Prep filename
filename = 'Math\' + name + '.tex';

%% Start of function
if istable(object)  % Table
    % Display
    disp(object)
    % Based on MATLAB Table to LaTeX conversor by Victor Martinez Cagigal
    %   [1]
    % Parameters
    n_col = size(object,2);
    col_spec = char(zeros(1,n_col));    %Preallocation
    for c = 1:n_col
        col_spec(c) = 'l'; 
    end
    col_spec = [col_spec(1) '|' col_spec(2:end)];   %Add vert line
    col_names = strjoin(object.Properties.VariableNames, ' & ');

    % Writing header
    fileID = fopen(filename, 'w');
    fprintf(fileID, '\\begin{table}[H] \n');
    fprintf(fileID, '   \\centering \n');
    fprintf(fileID, '   {\\rowcolors{2}{gray!20}{} \n');
    fprintf(fileID, '       \\begin{tabular}{%s}\n', col_spec);
    fprintf(fileID, '       %s \\\\ \n', col_names);
    fprintf(fileID, '       \\hline \n');
    
    % Writing the data
    for row = 1:size(object,1)
        temp = cell(1,n_col);
        for col = 1:n_col
            value = object{row,col};
            if isstruct(value)
                error('Table must not contain structs.'); 
            end
            while iscell(value)
                value = value{1,1}; 
            end
            if isinf(value)
                value = '$\infty$'; 
            end
            temp{1,col} = num2str(value);
        end
        fprintf(fileID, '       %s \\\\ \n', strjoin(temp, ' & '));
        clear temp;
    end
    
    % Closing the file
    fprintf(fileID, '       \\hline \n');
    fprintf(fileID, '       \\end{tabular}} \n');
    fprintf(fileID, '   \\caption{%s} \n',object.Properties.Description);
    fprintf(fileID, '   \\label{tab:%s} \n',name);
    fprintf(fileID, '\\end{table}');
    fclose(fileID);

elseif ismatrix(object) && size(object,1) > 1 && size(object,2) > 1  % Matrix
    % Check if the extra variables are filled
    if isempty(digitnum)
        warning("dispLaTeX requires digitnum to be filled for a Matrix")
        return
    end
    if isempty(variablename)
        warning("dispLaTeX requires variablename to be " + ...
            "filled for a Matrix")
        return
    end
    if ~iscell(variablename)
        warning("dispLaTeX requires variablename to be a cell " + ...
            "array for a Matrix")
        return
    end
    % Display
    formatSpec = "%." + num2str(digitnum,'%.0f') + "f";
    disp(num2str(object,formatSpec))

    % Write matrix
    fileID = fopen(filename, 'w');
    fprintf(fileID,'\\begin{align*}\n');
    variablename = string(variablename);
    fprintf(fileID,'    %s &= \\begin{bmatrix}\n', variablename);
    [rows, cols] = size(object);
    format_str = sprintf('  %%.%df & ', digitnum);
    format_str_end = sprintf('  %%.%df \\\\\\\\\\n',digitnum);
    for i = 1:rows
        for j = 1:cols
            if j < cols
                fprintf(fileID,format_str, object(i,j));
            else
                fprintf(fileID,format_str_end, object(i,j));
            end
        end
    end
    fprintf(fileID,'    \\end{bmatrix} \n');
    if unit ~= ""
        fprintf(fileID,"    " + unit + " \n");
    end
    fprintf(fileID,'\\end{align*}');
    fclose(fileID);
elseif isvector(object)  % vector
    % Check if the extra variables are filled
    if isempty(digitnum)
        warning("dispLaTeX requires digitnum to be filled for a vector")
        return
    end
    if isempty(variablename)
        warning("dispLaTeX requires variableChar to be " + ...
            "filled for a vector")
        return
    end
    % Make into a collum vector
    if isrow(object)
        object = object';
    end
    if ~iscell(variablename)
        warning("dispLaTeX requires variablename to be a cell " + ...
            "array for a vector")
        return
    end
    % Check the variablename size
    if size(variablename) > 1
        if size(variablename) ~= length(object)
            warning("Check variable cell array is the same length " + ...
                "as the vector")
            return
        end
    end
    % Display
    formatSpec = "%." + num2str(digitnum,'%.0f') + "f";
    disp(num2str(object,formatSpec))

    % Write variable vector
    fileID = fopen(filename, 'w');
    fprintf(fileID,'\\begin{align*}\n');
    fprintf(fileID,'    \\begin{bmatrix}\n');
    rows = length(object);
    if length(variablename) > 1
        for i = 1:rows
            temp = string(variablename(i)) + " \\\\ \n";
            fprintf(fileID,temp);
        end
    else
        temp = string(variablename) + " \\\\ \n";
        fprintf(fileID,temp);
    end
    fprintf(fileID,'    \\end{bmatrix} \n');
    fprintf(fileID,'    &= \\begin{bmatrix}\n');
    rows = length(object);
    format_str = sprintf('  %%.%df \\\\\\\\\\n',digitnum);
    for i = 1:rows
        fprintf(fileID,format_str, object(i));
    end
    fprintf(fileID,'    \\end{bmatrix} \n');
    if unit ~= ""
        fprintf(fileID,"    " + unit + " \n");
    end
    fprintf(fileID,'\\end{align*}');
    fclose(fileID);
end
% End of function
end