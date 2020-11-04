function Waves = Read_waves_AXYS(filename, dataLines)
%Read_waves_AXYS Import data from a text file
%  WAVES = Read_waves_AXYS(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  WAVES = Read_waves_AXYS(FILE, DATALINES) reads data for the specified row
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
opts = delimitedTextImportOptions("NumVariables", 24);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Datetime", "WaveType", "ZCN", "Havg", "Tavg", "Hmax", "Tmax", "MaxCrest", "Hsig", "Tsig", "H110", "T110", "MeanPeriod", "MeanDirection", "MeanSpread", "PeakPeriod", "PeakDirection", "PeakSpread", "TP5", "HM0", "Var21", "Var22", "Var23", "Var24"];
opts.SelectedVariableNames = ["Datetime", "WaveType", "ZCN", "Havg", "Tavg", "Hmax", "Tmax", "MaxCrest", "Hsig", "Tsig", "H110", "T110", "MeanPeriod", "MeanDirection", "MeanSpread", "PeakPeriod", "PeakDirection", "PeakSpread", "TP5", "HM0"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "double", "double", "string", "string", "string", "string"];
opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, [7, 8, 17, 18, 21, 22, 23, 24], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [7, 8, 17, 18, 21, 22, 23, 24], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Waves = readtable(filename, opts);

end