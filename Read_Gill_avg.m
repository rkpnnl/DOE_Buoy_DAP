function Gill = Read_Gill_avg(filename, dataLines)
%Read_Gill_avg Import data from a text file
%  GILL = Read_Gill_avg(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  GILL = Read_Gill_avg(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.

% Written by R. Krishnamurthy. PNNL. 10.12.2020

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 19);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Datetime", "HWSAvg", "HWSDir", "Var4", "Var5", "Var6", "HWSGust", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"];
opts.SelectedVariableNames = ["Datetime", "HWSAvg", "HWSDir"];
opts.VariableTypes = ["datetime", "double", "double", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, [4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Gill = readtable(filename, opts);

end