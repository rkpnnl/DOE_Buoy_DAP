% Read GNSS *.bin files

function [GNSS] = Read_GNSS_bin(filename)

% Read the raw *.bin files for GNSS files
% Written by: R Krishnamurthy, PNNL


% Define the strucutures (and the order) that make up a single data packet
% header = struct('sync1',uint8(0),'sync2',uint8(0),'max_packet_size',uint8(0),'payload_size',uint8(0)); % 4 bytes
% utc_time = struct('packet_descriptor',uint8(0),'fdescriptor',uint8(0),'year',uint16(0.0),'month',uint8(0.0),'day',uint8(0),'hour',uint8(0),'minute',uint8(0),'second',uint8(0),'msec',uint32(0),'flag',uint16(0)); %15 bytes
% position = struct('packet_descriptor',uint8(0),'fdescriptor',uint8(0),'lat',double(0.0),'lon',double(0.0),'height_ellipsoid',double(0),'height_msl',double(0),'horz_acc',single(0),'vert_acc',single(0),'flag',uint16(0));% 44 bytes
% velocity = struct('packet_descriptor',uint8(0),'fdescriptor',uint8(0),'north',single(0.0),'east',single(0.0),'down',single(0),'speed',single(0),'gnd_speed',single(0),'heading',single(0),'speed_err',single(0),'head_err',single(0),'flag',uint16(0));%36 bytes
% gps_time = struct('packet_descriptor',uint8(0),'fdescriptor',uint8(0),'tow',double(0.0),'week_number',uint16(0.0),'flag',uint16(0.0)); % 14 bytes
% chksum = struct('msb',uint8(0),'lsb',uint8(0)); % 2 bytes
% packet_size = 109; %without checksum

% Open the file for reading, making sure to swap bytes if the current host is little endian
fileID = fopen(filename,'r','ieee-be');

%% Run through the file and pick out each data packet based on allocated bytes
% Packet descriptor, fdescriptors and certain flags are not saved
i=1; % counter
while(~feof(fileID))
    
    h1 = fread(fileID,4,'*ubit8'); % Header information
    if(~isempty(h1))
        
        g1 = fread(fileID,2,'*ubit8'); % Packet_descriptor and fdescriptor for utc
        GNSS.utc(i,1) = fread(fileID,1,'uint16'); % Year
        GNSS.utc(i,2:6) = fread(fileID,5,'uint8'); % month, day, hour, minute, seconds
        GNSS.utc(i,7) = fread(fileID,1,'uint32'); % milli-seconds
        g1 = fread(fileID,1,'uint16'); % Flag for utc
        
        g1 = fread(fileID,2,'*ubit8'); % Packet_descriptor and fdescriptor for position
        GNSS.position(i,1:4) = fread(fileID,4,'double'); % lat, lon, ht_ellipsoid, ht_msl
        GNSS.position(i,5:6) = fread(fileID,2,'single');
        g1 = fread(fileID,1,'uint16'); % Flag for position
        
        g1 = fread(fileID,2,'*ubit8'); % Packet_descriptor and fdescriptor for velocity
        GNSS.vel(i,1:8) = fread(fileID,8,'single'); % north, east, down, speed, gnd_speed, heading
        g1 = fread(fileID,1,'uint16'); % Flag for velocity
        
        g1 = fread(fileID,2,'*ubit8');% Packet_descriptor and fdescriptor for GPS time
        GNSS.tow(i,1) = fread(fileID,1,'double'); % seconds
        GNSS.week_number(i,1)  = fread(fileID,1,'uint16'); % Week number
        GNSS.flag(i,1)  = fread(fileID,1,'uint16'); % flag 
        
        g1 = fread(fileID,2,'*ubit8'); % checksum
        i = i +1; % next packet
    end
end
clear g1 h1 i
%% Close the file
fclose(fileID);


%% Convert GPS Time to Matlab Time for processing
Num_days = GNSS.week_number*7;
curr_day = datenum(1980,1,6,0,0,0) + Num_days;
curr_vec = datevec(curr_day);
GPS_time = datenum(curr_vec(:,1),curr_vec(:,2),curr_vec(:,3),0,0,GNSS.tow(:));
GNSS.mtime = gps2utc(GPS_time); % UTC Time

function date1 = gps2utc(date0)
    %GPS2UTC Convert GPS time tags to UTC(GMT) time accounting for leap seconds
    %   GPS2UTC(date) corrects an array of GPS dates(in any matlab format) for
    %   leap seconds and returns an array of UTC datenums where:
    %   UTC = GPS - steptime
    %   Currently step times are through Jan 1 2016, but need to be added below
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

