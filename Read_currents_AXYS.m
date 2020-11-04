function currents = Read_currents_AXYS(filename, dataLines)
%Read_currents_AXYS Import data from a text file
%  CURRENTS = Read_currents_AXYS(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  CURRENTS = Read_currents_AXYS(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
% Written by R. Krishnamurthy. PNNL. 10.12.2020


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 105);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Datetime", "NumberOfBins", "BinSpacing", "HeadDepth", "BlankingDistance", "Vel1mms", "Dir1deg", "Vel2mms", "Dir2deg", "Vel3mms", ...
    "Dir3deg", "Vel4mms", "Dir4deg", "Vel5mms", "Dir5deg", "Vel6mms", "Dir6deg", "Vel7mms", "Dir7deg", "Vel8mms", "Dir8deg", "Vel9mms", "Dir9deg", ...
    "Vel10mms", "Dir10deg", "Vel11mms", "Dir11deg", "Vel12mms", "Dir12deg", "Vel13mms", "Dir13deg", "Vel14mms", "Dir14deg", "Vel15mms", "Dir15deg", ...
    "Vel16mms", "Dir16deg", "Vel17mms", "Dir17deg", "Vel18mms", "Dir18deg", "Vel19mms", "Dir19deg", "Vel20mms", "Dir20deg", "Vel21mms", "Dir21deg", ...
    "Vel22mms", "Dir22deg", "Vel23mms", "Dir23deg", "Vel24mms", "Dir24deg", "Vel25mms", "Dir25deg", "Vel26mms", "Dir26deg", "Vel27mms", "Dir27deg", ...
    "Vel28mms", "Dir28deg", "Vel29mms", "Dir29deg", "Vel30mms", "Dir30deg", "Vel31mms", "Dir31deg", "Vel32mms", "Dir32deg", "Vel33mms", "Dir33deg", ...
    "Vel34mms", "Dir34deg", "Vel35mms", "Dir35deg", "Vel36mms", "Dir36deg", "Vel37mms", "Dir37deg", "Vel38mms", "Dir38deg", "Vel39mms", "Dir39deg", ...
    "Vel40mms", "Dir40deg", "Vel41mms", "Dir41deg", "Vel42mms", "Dir42deg", "Vel43mms", "Dir43deg", "Vel44mms", "Dir44deg", "Vel45mms", "Dir45deg", ...
    "Vel46mms", "Dir46deg", "Vel47mms", "Dir47deg", "Vel48mms", "Dir48deg", "Vel49mms", "Dir49deg", "Vel50mms", "Dir50deg"];

opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double",...
    "double", "double"];

opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
currents = readtable(filename, opts);

end