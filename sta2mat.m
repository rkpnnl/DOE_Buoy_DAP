function [DATA]=sta2mat(filepath)

% Converts the Leosphere STA format data to Matlab format

if nargin==0
    [flpth,pth]=uigetfile({'*.sta';'*.stdsta'});
    filepath=[pth,flpth];
end

%==========================================================================
% Get relevant paramters within the file and output the data
%==========================================================================

%===== Get lidar parameters and results
PARAMS=parsersta(filepath);
data=txt2mat(filepath,PARAMS.HeaderSize+2,'InfoLevel',0);

% Get parameters from PARAMS and delete unnecessary fields
DATA=PARAMS;
fields={'i_CNR','i_Vh','i_Dir','i_W','i_stdW','i_stdVh','i_minVh','i_maxVh','i_Disp','i_Avail','HeaderSize'}; 
DATA=rmfield(DATA,fields); 
clear fields

% Date and time
Year=data(:,1); Month=data(:,2); Day=data(:,3);
Hour=data(:,4); Minute=data(:,5); Second=zeros(size(data,1),1);
DATA.time=datenum(Year,Month,Day,Hour,Minute,Second);

% Carrier-to-noise ratio
DATA.CNR=data(:,4+PARAMS.i_CNR);

% Horizontal wind speed, wind direction and vertical component of wind velocity
DATA.Vh=data(:,4+PARAMS.i_Vh);
DATA.CNR=data(:,4+PARAMS.i_CNR);
DATA.Dir=data(:,4+PARAMS.i_Dir);
DATA.W=data(:,4+PARAMS.i_W);
DATA.stdW=data(:,4+PARAMS.i_stdW);
DATA.stdVh=data(:,4+PARAMS.i_stdVh);
DATA.minVh=data(:,4+PARAMS.i_minVh);
DATA.maxVh=data(:,4+PARAMS.i_maxVh);
DATA.Disp=data(:,4+PARAMS.i_Disp);
DATA.Avail=data(:,4+PARAMS.i_Avail);
DATA.Range=PARAMS.Range;
DATA.TI=DATA.stdVh./DATA.Vh;

DATA.Type_Scenario='DBS';
DATA.Origine='sta';

end



