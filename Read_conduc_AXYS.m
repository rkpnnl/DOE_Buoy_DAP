function coductivity = Read_conduc_AXYS(filename, dataLines)
%Read_conduc_AXYS Import data from a text file
%  CODUCTIVITY = Read_conduc_AXYS(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  CODUCTIVITY = Read_conduc_AXYS(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
% Written by R. Krishnamurthy. PNNL. 10.12.2020

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Datetime", "SurfaceTemperatureC", "ConductivitySiemensm"];
opts.VariableTypes = ["datetime", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
coductivity = readtable(filename, opts);

end