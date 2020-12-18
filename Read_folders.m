function Folders = Read_folders(filename, dataLines)
%Read_folders Import data from a text file
%  MORROBAYFOLDERS = Read_folders(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  MORROBAYFOLDERS = Read_folders(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  MorroBayFolders = Read_folders("C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\MorroBay_Folders.txt", [1, Inf]);


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["'", "-", "="];

% Specify column names and types
opts.VariableNames = ["direc_lidar", "VarName2", "name", "month", "day", "Var6", "Var7", "Var8"];
opts.SelectedVariableNames = ["direc_lidar", "VarName2", "name", "month", "day"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, ["direc_lidar", "VarName2", "name", "Var6", "Var7", "Var8"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["direc_lidar", "VarName2", "name", "Var6", "Var7", "Var8"], "EmptyFieldRule", "auto");

% Import the data
Folders = readtable(filename, opts);

% %% Input handling
% 
% % If dataLines is not specified, define defaults
% if nargin < 2
%     dataLines = [1, Inf];
% end
% 
% %% Setup the Import Options
% opts = delimitedTextImportOptions("NumVariables", 4);
% 
% % Specify range and delimiter
% opts.DataLines = dataLines;
% opts.Delimiter = ["'", "/", "="];
% 
% % Specify column names and types
% opts.VariableNames = ["directory", "VarName2", "name", "Misc","day", "VarName6"];
% opts.VariableTypes = ["string", "string", "string", "double", "double", "string"];
% 
% opts = setvaropts(opts, ["directory", "VarName2", "VarName6"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["directory", "VarName2", "VarName6"], "EmptyFieldRule", "auto");
% 
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% opts.ConsecutiveDelimitersRule = "join";
% 
% % Import the data
% Folders = readtable(filename, opts);

end