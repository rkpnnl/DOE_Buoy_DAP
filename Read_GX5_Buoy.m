function IMU_130 = Read_GX5_Buoy(filename, dataLines)
%Read_GX5_Buoy Import data from a csv file
%  IMU_130_202009282100 = Read_GX5_Buoy(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  IMU_130_202009282100 = Read_GX5_Buoy(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [3, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 16);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Flag", "IMUWeek", "GTime", "XAccel", "YAccel", "ZAccel", "XGyro", "YGyro", "ZGyro", "XMag", "YMag", "ZMag", "Pre", "Roll", "Pitch", "Yaw"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
IMU_130 = readtable(filename, opts);

% Convert GTime to Matlab Time
Num_days = IMU_130.IMUWeek*7;
curr_day = datenum(1980,1,6,0,0,0) + Num_days;
curr_vec = datevec(curr_day);
GPS_time = datenum(curr_vec(:,1),curr_vec(:,2),curr_vec(:,3),0,0,IMU_130.GTime);
IMU_130.GPS_time = GPS_time;
IMU_130.mtime = gps2utc(GPS_time); % UTC Time


    function date1 = gps2utc(date0)
    %GPS2UTC Convert GPS time tags to UTC(GMT) time accounting for leap seconds
    %   GPS2UTC(date) corrects an array of GPS dates(in any matlab format) for
    %   leap seconds and returns an array of UTC datenums where:
    %   UTC = GPS - steptime
    %   Currently step times are through Jan 1 2009, but need to be added below
    %   as they are instuted. All input dates must be later than the start of
    %   GPS time on Jan 6 1980 00:00:00
    
    %% ADD NEW LEAP DATES HERE:
    stepdates = [...
        'Jan 6 1980'
        'Jul 1 1981'
        'Jul 1 1982'
        'Jul 1 1983'
        'Jul 1 1985'
        'Jan 1 1988'
        'Jan 1 1990'
        'Jan 1 1991'
        'Jul 1 1992'
        'Jul 1 1993'
        'Jul 1 1994'
        'Jan 1 1996'
        'Jul 1 1997'
        'Jan 1 1999'
        'Jan 1 2006'
        'Jan 1 2009'
        'Jan 1 2012'
        'Jan 1 2015'
        'Jan 1 2016'];
    %% Convert Steps to datenums and make step offsets
    stepdates = datenum(stepdates)'; %step date coversion
    steptime = (0:length(stepdates)-1)'./86400; %corresponding step time (sec)
    %% Arg Checking
    if ~isnumeric(date0) %make sure date0 are datenums, if not try converting
        date0 = datenum(date0); %will error if not a proper format
    end
    if ~isempty(find(date0 < stepdates(1)))%date0 must all be after GPS start date
        error('Input dates must be after 00:00:00 on Jan 6th 1980') 
    end
    %% Array Sizing
    sz = size(date0);
    date0 = date0(:);
    date0 = repmat(date0,[1 size(stepdates,2)]);
    stepdates = repmat(stepdates,[size(date0,1) 1]);
    %% Conversion
    date1 = date0(:,1)   - steptime(sum((date0 - stepdates) >= 0,2));
    %% Reshape Output Array
    date1 = reshape(date1,sz);
    end


end