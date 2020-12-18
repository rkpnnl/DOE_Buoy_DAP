% This code processes the data as downloaded from the DAP for the Morro Bay
% and Humboldt locations

% Inputs
% Two text files are used as inputs (MorroBay_Folders.txt and Humboldt.txt)
% Please follow the steps to input the folder locations, date to process,
% and location to process.

% The code reads in the two text files in the opereating folder and processes the data requested
% If no date is inputted into the text files, the code will look for any data avaialble the
% previous day (For example, If Today is - Dec 18, 2020, the code will look
% for any avaibale data on Dec 17, 2020).

% Written by Raghu Krishnamurthy, PNNL
% Email: raghu@pnnl.gov



%% Buoy 130 - Morro Bay
Folders = Read_folders('MorroBay_Folders.txt');
direc_lidar = Folders.name{1};
direc_buoy = Folders.name{2};
direc_move = Folders.name{3};
OutputDir = Folders.name{4};
zip_exe = Folders.name{5};
year = str2num(Folders.name{6});
month = Folders.month(6);
day = Folders.day(6);
if(~isempty(year) || ~isnan(month) || ~isnan(day))
    idate = datenum(year,month,day,0,0,0);   
else
    idate = datenum(date)-1; % Date to be plotted (matlab format) - Yesterday's data collected on the DAP
end

site = 'Morro Bay'; % location of the buoy data

% Read and plot the data
disp(['Creating plots for site ' site ' on ' datestr(idate)])
Plot_Buoys(direc_buoy, direc_lidar, direc_move,site, OutputDir, zip_exe, idate);


%% Buoy 120 - Humboldt
Folders = Read_folders('Humboldt_Folders.txt');
site = 'Humboldt'; % location of the buoy data

direc_lidar = Folders.name{1};
direc_buoy = Folders.name{2};
direc_move = Folders.name{3};
OutputDir = Folders.name{4};
zip_exe = Folders.name{5};
year = str2num(Folders.name{6});
month = Folders.month(6);
day = Folders.day(6);
if(~isempty(year) || ~isnan(month) || ~isnan(day))
    idate = datenum(year,month,day,0,0,0);   
else
    idate = datenum(date)-1; % Date to be plotted (matlab format) - Yesterday's data collected on the DAP
end

% Read and plot the data
disp(['Creating plots for site ' site ' on ' datestr(idate)])
Plot_Buoys(direc_buoy, direc_lidar, direc_move,site, OutputDir, zip_exe, idate);


% % Build a standalone application
% mcc -m Process_DAP_Buoy.m -a ./DAP_codes/*.m -o DAP_Buoy_Plots -R -nojvm -logfile DAP_log -v -w enable 



