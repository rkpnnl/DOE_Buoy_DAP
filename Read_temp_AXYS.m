function Temp = Read_temp_AXYS(filename, dataLines)
%Read_temp_AXYS Import data from a text file
%  TEMP = Read_temp_AXYS(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  TEMP = Read_temp_AXYS(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
% Written by R. Krishnamurthy. PNNL. 10.12.2020


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Datetime", "TempAvg", "Var3", "Var4", "Var5"];
opts.SelectedVariableNames = ["Datetime", "TempAvg"];
opts.VariableTypes = ["datetime", "double", "string", "string", "string"];
opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, [3, 4, 5], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [3, 4, 5], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Temp = readtable(filename, opts);

end