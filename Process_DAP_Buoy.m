% DAP Buoy data analysis
%% Buoy 130 - Morro Bay
% Inputs
% Important note, make sure you run the DAP code to download the latest
% data

% direc_lidar = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\Lidar\'; % Location of the lidar data
% direc_buoy = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\buoy\'; % Location of the Buoy data
% direc_move = 'Y:\Data\CA_deployment\buoy130_Morrobay\'; % Move the data from local PC to server
% OutputDir = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\Figures\'; % Daily Figure Folders for each day - These need to be uploaded to DAP
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


% direc_lidar = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Humboldt (120)\Lidar\'; % Location of the lidar data
% direc_buoy = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Humboldt (120)\Buoy\'; % Location of the Buoy data
% direc_move = 'Y:\Data\CA_deployment\buoy120_Humboldt\'; % Move the data from local PC to server
% OutputDir = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Humboldt (120)\Figures\'; % Daily Figure Folders for each day - These need to be uploaded to DAP
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



