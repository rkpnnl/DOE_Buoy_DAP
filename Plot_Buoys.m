function [] = Plot_Buoys(direc_buoy, direc_lidar, direc_move,site, OutputDir, zip_exe, idate)

% Plot the data from the Buoy and DL

% Inputs
% direc_lidar = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\Lidar\';
% direc_buoy = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\buoy\';
% direc_move = 'Y:\Data\CA_deployment\buoy130_Morrobay\';
% OutputDir = 'C:\Users\kris439\Desktop\Work\Lidar Buoy Science\Buoy Lidar\Morro Bay\DAP data\Figures\'; % Daily Figure Folders for each day
% site - location of the buoy data
% idate = Date to be plotted (matlab format)
warning off
mkdir(OutputDir); % Create the director if does not exist

%% Plot surface met characteristics

% Plot GIll WS, WD, cup winds and direction
% Subplot 1
dircon_gill = dir([direc_buoy '*.gill.csv']);
dircon_cup = dir([direc_buoy '*.wind.csv']);

% Pick the relevant file from the input date

for i = 1:length(dircon_gill)
    ind_gill = find(dircon_gill(i).name == '.');
    date_gill = dircon_gill(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_gill_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

for i = 1:length(dircon_cup)
    ind_cup = find(dircon_cup(i).name == '.');
    date_cup = dircon_cup(i).name(ind_cup(3)+1:ind_cup(4)-1); % string
    % convert to matlab time
    date_cup_mat(i) = datenum(str2num(date_cup(1:4)),str2num(date_cup(5:6)),str2num(date_cup(7:8)),0,0,0);
end

ind_gill = find(date_gill_mat == idate);
ind_cup = find(date_cup_mat == idate);


% Read the data
if(~isempty(ind_cup))
    disp(['Reading the Cup Anemometer file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_cup(ind_cup).name];
    winds_temp = abs(txt2mat(filename)); % For compatability with 2016b
    winds.HWSAvg = winds_temp(:,7); % Wind Speed
    winds.HWSDir = winds_temp(:,8); % Wind Direction
    winds.Datetime = datetime(winds_temp(:,1),winds_temp(:,2),winds_temp(:,3),winds_temp(:,4),winds_temp(:,5),winds_temp(:,6));
%     winds = Read_winds_AXYS([direc_buoy dircon_cup(ind_cup).name]);
else
    disp(['No cup dataset available on - ' datestr(idate)])
end

if(~isempty(ind_gill))
    disp(['Reading the Gill Sonic file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_gill(ind_gill).name];
    Gill_temp = abs(txt2mat(filename)); % For compatability with 2016b
    Gill.HWSAvg = Gill_temp(:,7);% Wind Speed
    try
        Gill.HWSDir = Gill_temp(:,9);% Wind Direction
    catch
        Gill.HWSDir = Gill_temp(:,8);% Wind Direction if Gust data is not available
    end
    Gill.Datetime = datetime(Gill_temp(:,1),Gill_temp(:,2),Gill_temp(:,3),Gill_temp(:,4),Gill_temp(:,5),Gill_temp(:,6));
%     Gill = Read_Gill_avg([direc_buoy dircon_gill(ind_gill).name]);
else
    disp(['No Gill Sonic dataset available on - ' datestr(idate)])
    
end

% Plot the data
figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
subplot(3,1,1)
yyaxis left

if(~isempty(ind_cup))
    
    plot(winds.Datetime,winds.HWSAvg,'LineWidth',2)
    ylabel("$\rm \bar U\ (ms^{-1}) $",'Interpreter','Latex')
    hold on
    yyaxis right
    plot(winds.Datetime,winds.HWSDir,'LineWidth',2)
    ylabel("$\rm \bar \theta\ (degrees) $",'Interpreter','Latex')
    legend(["$\rm \bar U\ Cup$" "$\rm \bar \theta\ Cup$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
    title({['Surface Met at ' site ' on ' datestr(winds.Datetime(1),'yyyy/mm/dd')], ""},'Fontsize',14,'Interpreter','latex')
    
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_wind_file = [direc_buoy dircon_cup(ind_cup).name];
        movefile(direc_wind_file,[direc_move 'buoy\']);
    end
    
end

if(~isempty(ind_gill))
    
    yyaxis left
    plot(Gill.Datetime,Gill.HWSAvg,'LineWidth',2)
    hold on
    yyaxis right
    plot(Gill.Datetime,Gill.HWSDir,'LineWidth',2)
    legend(["$\rm \bar U\ Gill$" "$\rm \bar \theta\ Gill$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
    title({['Surface Met Parameters at ' site], ""},'Fontsize',14,'Interpreter','latex')
    
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_gill_file = [direc_buoy dircon_gill(ind_gill).name];
        movefile(direc_gill_file,[direc_move 'buoy\']);
    end

end

if(~isempty(ind_cup) && ~isempty(ind_gill))
    legend(["$\rm \bar U\ Cup$" "$\rm \bar U\ Gill$" "$\rm \bar \theta\ Cup$" "$\rm \bar \theta\ Gill$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
end

set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');



% Plot Relative Humidity, Pressure
% Subplot 2
dircon_rh = dir([direc_buoy '*.rh.csv']);
dircon_pres = dir([direc_buoy '*.pressure.csv']);


% Pick the relevant file from the input date

for i = 1:length(dircon_rh)
    ind_gill = find(dircon_rh(i).name == '.');
    date_gill = dircon_rh(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_rh_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

for i = 1:length(dircon_pres)
    ind_cup = find(dircon_pres(i).name == '.');
    date_cup = dircon_pres(i).name(ind_cup(3)+1:ind_cup(4)-1); % string
    % convert to matlab time
    date_pres_mat(i) = datenum(str2num(date_cup(1:4)),str2num(date_cup(5:6)),str2num(date_cup(7:8)),0,0,0);
end

ind_rh = find(date_rh_mat == idate);
ind_pres = find(date_pres_mat == idate);

% Read the data
if(~isempty(ind_pres))
    disp(['Reading the Pressure file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_pres(ind_pres).name];
    P_temp = abs(txt2mat(filename)); % For compatability with 2016b
    Pres.PresAvg = P_temp(:,7);% Pressure
    Pres.Datetime = datetime(P_temp(:,1),P_temp(:,2),P_temp(:,3),P_temp(:,4),P_temp(:,5),P_temp(:,6));
%     Pres = Read_Pres_AXYS([direc_buoy dircon_pres(ind_pres).name]);
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_pres_file = [direc_buoy dircon_pres(ind_pres).name];
        movefile(direc_pres_file,[direc_move 'buoy\']);
    end

else
     disp(['No Pressure sensor dataset available on - ' datestr(idate)])
end
if(~isempty(ind_rh))
    disp(['Reading the RH file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_rh(ind_rh).name];
    RH_temp = abs(txt2mat(filename)); % For compatability with 2016b
    rh.RH = RH_temp(:,7);% Relative Humidity
    rh.Datetime = datetime(RH_temp(:,1),RH_temp(:,2),RH_temp(:,3),RH_temp(:,4),RH_temp(:,5),RH_temp(:,6));
%     rh = Read_RH_AXYS([direc_buoy dircon_rh(ind_rh).name]);
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_rh_file = [direc_buoy dircon_rh(ind_rh).name];
        movefile(direc_rh_file,[direc_move 'buoy\']);
    end
else
    
    disp(['No RH sensor dataset available on - ' datestr(idate)])
end

% Plot the data
subplot(3,1,2)

if(~isempty(ind_pres))

    yyaxis left
    plot(Pres.Datetime,Pres.PresAvg,'LineWidth',2)
    ylabel("$\rm \bar P\ (bar) $",'Interpreter','Latex')
    legend(["$\rm Pressure $" ],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
end

hold on

if(~isempty(ind_rh))
    yyaxis right
    plot(rh.Datetime,rh.RH,'LineWidth',2)
    ylabel("$\rm \bar {RH}\ (\%) $",'Interpreter','Latex')
    legend(["$\rm Relative\ Humidity$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
end

set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');

if(~isempty(ind_pres) && ~isempty(ind_rh))
    legend(["$\rm Pressure $" "$\rm Relative\ Humidity$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
end


% Plot Air Temperature, & Sea Surface Temperature
% Subplot 3
dircon_temp = dir([direc_buoy '*.temperature.csv']);
dircon_sst = dir([direc_buoy '*.surfacetemp.csv']);


% Pick the relevant file from the input date

for i = 1:length(dircon_temp)
    ind_gill = find(dircon_temp(i).name == '.');
    date_gill = dircon_temp(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_temp_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

for i = 1:length(dircon_sst)
    ind_cup = find(dircon_sst(i).name == '.');
    date_cup = dircon_sst(i).name(ind_cup(3)+1:ind_cup(4)-1); % string
    % convert to matlab time
    date_sst_mat(i) = datenum(str2num(date_cup(1:4)),str2num(date_cup(5:6)),str2num(date_cup(7:8)),0,0,0);
end

ind_temp = find(date_temp_mat == idate);
if(~isempty(dircon_sst))
    ind_sst = find(date_sst_mat == idate);
else
    ind_sst = [];
end

if(~isempty(ind_temp))
    disp(['Reading the Temperature file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_temp(ind_temp).name];
    T_temp = (txt2mat(filename)); % For compatability with 2016b
    temp.TempAvg = T_temp(:,7);% Relative Humidity
    temp.Datetime = datetime(T_temp(:,1),abs(T_temp(:,2)),abs(T_temp(:,3)),T_temp(:,4),T_temp(:,5),T_temp(:,6));
    clear T_temp
%     temp = Read_temp_AXYS([direc_buoy dircon_temp(ind_temp).name]);
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_temp_file = [direc_buoy dircon_temp(ind_temp).name];
        movefile(direc_temp_file,[direc_move 'buoy\']);
    end
else
    
    disp(['No Air Temperature sensor dataset available on - ' datestr(idate)])
end

if(~isempty(ind_sst))
    disp(['Reading the SST file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    
    filename = [direc_buoy dircon_sst(ind_sst).name];
    T_temp = (txt2mat(filename)); % For compatability with 2016b
    SST.SST = T_temp(:,7);% Relative Humidity
    SST.Datetime = datetime(T_temp(:,1),abs(T_temp(:,2)),abs(T_temp(:,3)),T_temp(:,4),T_temp(:,5),T_temp(:,6));
%     SST = Read_sst_AXYS([direc_buoy dircon_sst(ind_sst).name]);
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_sst_file = [direc_buoy dircon_sst(ind_sst).name];
        movefile(direc_sst_file,[direc_move 'buoy\']);
    end
    
else
    disp(['No SST sensor dataset available on - ' datestr(idate)])
end

% Plot the data
subplot(3,1,3)

if(~isempty(ind_temp))

    yyaxis left
    plot(temp.Datetime,temp.TempAvg,'LineWidth',2)
    xlabel("UTC Time",'Interpreter','Latex')
    ylabel("$\rm \bar T_{air}\ (^oC) $",'Interpreter','Latex')
    legend(["$\rm Air\ Temperature$"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
    
end

if(~isempty(ind_sst))

    yyaxis right
    plot(SST.Datetime,SST.SST,'LineWidth',2)
    ylabel("$\rm \bar {SST}\ (^oC) $",'Interpreter','Latex')
    legend(["$\rm Sea\ Surface\ Temperature $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')

end

set(gcf,'color','white')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');

if(~isempty(ind_sst) && ~isempty(ind_temp))
    legend(["$\rm Air\ Temperature$" "$\rm Sea\ Surface\ Temperature $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w')
end

disp(['Saving the Met Figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
% Save the figure
fig_filename = [OutputDir dircon_cup(end).name(1:end-4) '.rh.pressure.airtemp.sst.jpg'];
saveas(gcf,fig_filename,'jpeg')
close(gcf)


%% Plot Waves data
dircon_waves = dir([direc_buoy '*.waves.csv']);
% Pick the relevant file from the input date

for i = 1:length(dircon_waves)
    ind_gill = find(dircon_waves(i).name == '.');
    date_gill = dircon_waves(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_waves_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

ind_waves = find(date_waves_mat == idate);

if(~isempty(ind_waves))
   disp(['Reading the Waves file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])   
   filename = [direc_buoy dircon_waves(ind_waves).name];
   Waves_temp = (txt2mat(filename)); % For compatability with 2016b
   Waves.Datetime = datetime(Waves_temp(:,1),abs(Waves_temp(:,2)),abs(Waves_temp(:,3)),Waves_temp(:,4),Waves_temp(:,5),Waves_temp(:,6));
   Waves.Havg = Waves_temp(:,9);
   Waves.Hsig = Waves_temp(:,12);
   Waves.Hmax = Waves_temp(:,11);
   Waves.Tavg = Waves_temp(:,10);
   Waves.Tsig = Waves_temp(:,13);
   Waves.MeanPeriod = Waves_temp(:,16);
   Waves.MeanDirection = Waves_temp(:,17);
%     Waves = Read_waves_AXYS([direc_buoy dircon_waves(ind_waves).name]);

    % Plot the data
    % Significant wave height
    % Significant wave time period
    % Maximum wave height
    % Mean Wave Direction
    % Mean wave period

    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    subplot(3,1,1)
    plot(Waves.Datetime,Waves.Havg,'LineWidth',2)
    hold on
    plot(Waves.Datetime,Waves.Hsig,'LineWidth',2)
    plot(Waves.Datetime,Waves.Hmax,'LineWidth',2)
    title(['Average Wave statistics at ' site],'Fontsize',14,'Interpreter','latex')
    colormap(brewermap([],'*spectral'))
    ylabel("$\rm Wave\ H\ (m) $",'Interpreter','Latex')

    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');
    legend(["$\rm H_{avg}$" "$\rm H_{sig} $" "$\rm H_{max} $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    set(gcf,'color','white')

    subplot(3,1,2)
    plot(Waves.Datetime,Waves.Tavg,'LineWidth',2)
    hold on
    plot(Waves.Datetime,Waves.Tsig,'LineWidth',2)

    ylabel("$\rm Wave\ T\ (secs) $",'Interpreter','Latex')

    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');
    legend(["$\rm T_{avg}$" "$\rm T_{sig} $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)


    subplot(3,1,3)
    yyaxis left
    plot(Waves.Datetime,Waves.MeanPeriod,'LineWidth',2)
    ylabel("$\rm Wave\ \bar T\ (secs) $",'Interpreter','Latex')
    xlabel("UTC Time",'Interpreter','Latex')
    
    yyaxis right
    plot(Waves.Datetime,Waves.MeanDirection,'LineWidth',2)
    ylabel("$\rm Wave\ \bar \phi\ (deg) $",'Interpreter','Latex')


    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');
    legend(["$\rm \bar T_{mean}$" "$\rm \bar \phi\ (deg) $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    if(direc_move ~= 'x')      
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_waves_file = [direc_buoy dircon_waves(ind_waves).name];
        movefile(direc_waves_file,[direc_move 'buoy\']);
        disp(['Saving Waves Figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    end
    % Save the figure
    fig_filename = [OutputDir dircon_waves(ind_waves).name(1:end-4) '.height.period.direction.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)

end

%% Plot Conductivity
dircon_cond = dir([direc_buoy '*.conductivity.csv']);

% Pick the file
for i = 1:length(dircon_cond)
    ind_gill = find(dircon_cond(i).name == '.');
    date_gill = dircon_cond(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_cond_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

ind_cond = find(date_cond_mat == idate);

if(~isempty(ind_cond))
    disp(['Reading the Conductivity file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    
    filename = [direc_buoy dircon_cond(ind_cond).name];
    cond_temp = abs(txt2mat(filename)); % For compatability with 2016b
    coductivity.ConductivitySiemensm = cond_temp(:,8); % Wind Speed
    coductivity.SurfaceTemperatureC = cond_temp(:,7); % Wind Direction
    coductivity.Datetime = datetime(cond_temp(:,1),cond_temp(:,2),cond_temp(:,3),cond_temp(:,4),cond_temp(:,5),cond_temp(:,6));

%     coductivity = Read_conduc_AXYS([direc_buoy dircon_cond(ind_cond).name]);
    
    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    yyaxis left
    plot(coductivity.Datetime,coductivity.ConductivitySiemensm,'LineWidth',2)
    ylabel("$\rm Conductivity\ (S\ m^{-1}) $",'Interpreter','Latex')
    yyaxis right
    plot(coductivity.Datetime,coductivity.SurfaceTemperatureC,'LineWidth',2)
    ylabel("$\rm SST\ (^o C) $",'Interpreter','Latex')
    title(['Average Ocean Conductivity and temprature estimates at ' site],'Fontsize',14,'Interpreter','latex')
    xlabel("UTC Time",'Interpreter','Latex')
    set(gcf,'color','white')
    legend(["$\rm Conductivity (S\ m^{-1})$" "$\rm \bar SST\ (^o C) $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)

    
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on','XGrid','on','XMinorGrid','on','YGrid','on','YMinorGrid','on');
%     legend(["$\rm \bar T_{mean}$" "$\rm \bar \phi\ (deg) $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    if(direc_move ~= 'x') 
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_cond_file = [direc_buoy dircon_cond(ind_cond).name];
        movefile(direc_cond_file,[direc_move 'buoy\']);
    end
    disp(['Saving the Conductivity figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])

    % Save the figure
    fig_filename = [OutputDir dircon_waves(ind_cond).name(1:end-4) '.conductivity.sst.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)
    
end

%% Plot Currents
dircon_curr = dir([direc_buoy '*.currents.csv']);

% Pick the file
for i = 1:length(dircon_curr)
    ind_gill = find(dircon_curr(i).name == '.');
    date_gill = dircon_curr(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_curr_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

ind_curr = find(date_curr_mat == idate);

if(~isempty(ind_curr))
    disp(['Reading the Ocean Currents file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy dircon_curr(ind_curr).name];
    ctemp = txt2mat(filename);
    currents.vel = ctemp(:,11:2:end);
    currents.direc = ctemp(:,12:2:end);
    currents.binsize = ctemp(:,8);
    currents.blankdist = ctemp(:,10);
    currents.Nobins = ctemp(:,7);
    currents.Datetime = datetime(ctemp(:,1),abs(ctemp(:,2)),abs(ctemp(:,3)),ctemp(:,4),ctemp(:,5),ctemp(:,6));

    Range = currents.blankdist + currents.binsize*(1:currents.Nobins);
    
%     currents = Read_currents_AXYS([direc_buoy dircon_curr(ind_curr).name]);
    
%     vel = currents{:,6:2:end};
%     direc = currents{:,7:2:end};
%     binsize = nanmedian(currents{:,3});
%     blankdist = nanmedian(currents{:,5});
%     HeadDepth = nanmedian(currents{:,4});
%     Nobins = nanmedian(currents{:,2});
%     Range = blankdist + binsize*(1:Nobins);
    
    % Filter the data
    currents.direc(currents.vel > 2000) = NaN;
    currents.vel(currents.vel > 2000) = NaN;
    
    
    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    subplot(2,1,1)
    pcolor(currents.Datetime,-Range(1,:),currents.vel')
    c = colorbar;
    c.Label.String = '$\rm Current\ Velocity\ (mm\ s^{-1})$';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    shading flat
    ylabel("$\rm Depth\ (m) $",'Interpreter','Latex')
    title(['Average Ocean Current Velocity and Direction at ' site],'Fontsize',14,'Interpreter','latex')
    xlabel("UTC Time",'Interpreter','Latex')
    set(gcf,'color','white')
    
     set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','off','YMinorTick','off','XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
    legend(["$\rm Current\ Velocity\ (mm\ s^{-1})$"],'Interpreter','Latex','Location','southwest','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    
    subplot(2,1,2)
    pcolor(currents.Datetime,-Range(1,:),currents.direc')
    
    c = colorbar;
    c.Label.String = '$\rm Current\ Direction\ (deg)$';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    shading flat
    ylabel("$\rm Depth\ (m) $",'Interpreter','Latex')
    xlabel("UTC Time",'Interpreter','Latex')
    colormap('HSV')
    
     set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
    'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
    'TickLabelInterpreter','latex','XMinorTick','off','YMinorTick','off','XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
    
    legend(["$\rm Current\ Direction\ (degrees)$"],'Interpreter','Latex','Location','southwest','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    
    disp(['Moving the Ocean Currents file to archive from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    if(direc_move ~= 'x')  
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_curr_file = [direc_buoy dircon_curr(ind_curr).name];
        movefile(direc_curr_file,[direc_move 'buoy\']);
    end
    disp(['Saving Currents Figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])

    % Save the figure
    fig_filename = [OutputDir dircon_curr(ind_curr).name(1:end-4) '.velocity.direction.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)
end

%% Plot the lidar data
direc_lidar_sta = dir([direc_lidar '*.sta.7z']);

% Pick the file
for i = 1:length(direc_lidar_sta)
    ind_gill = find(direc_lidar_sta(i).name == '.');
    date_gill = direc_lidar_sta(i).name(ind_gill(3)+1:ind_gill(4)-1); % string
    % convert to matlab time
    date_lidsta_mat(i) = datenum(str2num(date_gill(1:4)),str2num(date_gill(5:6)),str2num(date_gill(7:8)),0,0,0);
end

ind_lid = find(date_lidsta_mat == idate);

if(~isempty(ind_lid))
    disp(['Reading the Lidar file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    
    file_lid_7z = [direc_lidar direc_lidar_sta(ind_lid).name];
    [~,~] = system(['"' zip_exe '"' ' -y x ' '"' file_lid_7z '"' ' -o' '"' direc_lidar '"']);
%     [status,cmdout] = system( ['"C:\Program Files\7-Zip\7z.exe" x -o',file_lid_7z,' ',file7z] );
    
    file_lid_sta = file_lid_7z(1:end-3);
    
    % Read the Lidar data (STA data)
    Alldata = sta2mat([file_lid_sta]);
    
    % Filter the data based on Availability
    Alldata.Vh(Alldata.Avail < 10) = NaN;
    Alldata.Dir(Alldata.Avail < 10) = NaN;
    Alldata.W(Alldata.Avail < 10) = NaN;
    Alldata.TI(Alldata.Avail < 10) = NaN;
    
    
    % Plot the winds and direction (vectors) (Time x Height)
    % Plot daily availability plot
    
    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    
    subplot(2,1,1)
    a1 = size(Alldata.Vh,2); % Number of ranges
    %%Velocity and direction
    Um=-Alldata.Vh.*sind(Alldata.Dir);
    Vm=-Alldata.Vh.*cosd(Alldata.Dir);
    VVm = Alldata.Vh;
    
    %%Normalize Um and Vm
    for i=1:size(Um,1)
        for j = 1:size(Um,2)
            Umn(i,j)=Um(i,j)./norm([Um(i,j) Vm(i,j)]);
            Vmn(i,j)=Vm(i,j)./norm([Um(i,j) Vm(i,j)]);
        end
    end
    
    %%create x/y grid 24x60
    [x,y] = meshgrid(linspace(0,1,size(Alldata.time,1)),linspace(0,1,a1)); % a1 is the range length
    
    %%plot Wind speed and wind direction matrix's on xy grid with quiver
    axis([0 1 0 1])
    contourf(x,y,VVm',0:1:30);hold on % creates contour colormap with 1m/s increments upto 30 m/s
    shading flat
    colormap(brewermap([],'*spectral'))
    quiver(x(:,1:5:end),y(:,1:5:end),Umn(1:5:end,:)',Vmn(1:5:end,:)',0.5,'color','k','LineWidth',1.5)
    axis([-0.009 1.012 -0.005 1.005])
    
    %%Manipulate Labels
    nLabelsY=a1; %(60/nLabelsY must be integer NOT float)
%     yticklabs = cellstr(num2str(Alldata.Range));
    set(gca,'ytick',linspace(0,2,nLabelsY),'yticklabels',Alldata.Range(1:2:end)) %{yticklabs{1:1:end}})
    set(gca,'xtick',linspace(0,0.8696,6),'xticklabels',sprintfc('%g',[0:4:23]))
    caxis([0 15]);
    xlabel({'UTC\ Hour\ of\ the\ Day'},'Interpreter','latex','FontName','Times New Roman');
    set(gcf,'color','white')
    ylabel({'Height\ ASL\ (m)'},'Interpreter','latex','FontName','Times New Roman');
    c = colorbar;
    c.Label.String = '$\rm Wind\ Speed\ (ms^{-1})$';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
        'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','out',...
        'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on');
    grid off
    title(['Average wind speed and direction at ' site ' on ' datestr(Alldata.time(1),'dd-mmm-yyyy')],'Fontsize',14,'Interpreter','latex')
    legend(["$\rm Wind\ Speed\ Contours\ (0.5\ ms^{-1}) $", "$\rm Wind\ Direction (degrees) $"],'Interpreter','Latex','Location','Best','Orientation','Vertical','EdgeColor','w','FontSize',14)

    subplot(2,1,2)
    plot(Alldata.Range,nanmean(Alldata.Avail),'LineWidth',2,'color','r')
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
        'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','out',...
        'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on');
    grid on
    xlabel({'$\rm Height\ ASL\ (m)$'},'Interpreter','latex','FontName','Times New Roman');
    ylabel({'$\rm Availability\ (\%)$'},'Interpreter','latex','FontName','Times New Roman');
    legend(["$\rm Lidar\ Data\ Availability $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)

    if(direc_move ~= 'x')
        disp(['Moving the Lidar files to archive for ' site ' on ' datestr(idate,'yyyy/mm/dd')])
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_lid_file = [direc_lidar direc_lidar_sta(ind_lid).name]; % Move the 7zip files sta files
        movefile(direc_lid_file,[direc_move 'Lidar\']);
    end
    
    if(direc_move ~= 'x')
        % Also move the stdsa, rtd, stdsta
        direc_lid_file_stdsta = [file_lid_7z(1:end-6) 'stdsta.7z'];
        movefile(direc_lid_file_stdsta,[direc_move 'Lidar\']);

        direc_lid_file_rtd = [file_lid_7z(1:end-6) 'rtd.7z'];
        movefile(direc_lid_file_rtd,[direc_move 'Lidar\']);

        direc_lid_file_rtd = [file_lid_7z(1:end-6) 'stdrtd.7z'];
        movefile(direc_lid_file_rtd,[direc_move 'Lidar\']);
    end
    
    try
        % delete the unzipped sta files
        delete(file_lid_7z(1:end-3));
    catch
        laster
    end
    
    disp(['Saving the Lidar Winds & Direction figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])

    % Save the figure
    fig_filename = [OutputDir direc_lidar_sta(ind_lid).name(1:end-3) '.Winds.Direction.Availability.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)
    
    
    % Plot the time series WS at select heights (Time x Height)
    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    r1 = find(Alldata.Range == 40);
    r2 = find(Alldata.Range == 90);
    r3 = find(Alldata.Range == 140);
    r4 = find(Alldata.Range == 200);
    
    plot(Alldata.time,Alldata.Vh(:,[r1 r2 r3 r4]),'Linewidth',2)
    
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
        'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','out',...
        'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on');
    datetick('x','yyyy-mm-dd HH:MM')
    xlabel({'$\rm UTC\ Time\ $'},'Interpreter','latex','FontName','Times New Roman');
    ylabel({'$\rm Wind\ Speed\ (ms^{-1})$'},'Interpreter','latex','FontName','Times New Roman');
    set(gcf,'color','white')
    legend(["$\rm 40\ m\ $" "$\rm 90\ m\ $" "$\rm 140\ m\ $" "$\rm 200\ m\ $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    
%     yyaxis right
%     plot(Alldata.time,Alldata.Dir(:,[r1 r2 r3 r4]),'--','Linewidth',2)
%     ylabel({'$\rm Wind\ Direction\ (deg)$'},'Interpreter','latex','FontName','Times New Roman');
%     legend(["$\rm 40\ m\ $" "$\rm 90\ m\ $" "$\rm 140\ m\ $" "$\rm 200\ m\ $"],'Interpreter','Latex','Location','Best','Orientation','Horizontal','EdgeColor','w','FontSize',14)
    disp(['Saving the Figure Winds at offshore Hub-height from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    
    % Save the figure
    fig_filename = [OutputDir direc_lidar_sta(ind_lid).name(1:end-3) '.Winds.Hub.Heights.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)
    
end


%% Plot the IMU data from GX5 - Daily


% Plot the lidar data
direc_gnss_bin = dir([direc_buoy '*.gnss.bin']);
direc_imu_bin = dir([direc_buoy '*.imu.bin']);
warning off

% Pick the file
for i = 1:length(direc_gnss_bin)
    ind_gnss = find(direc_gnss_bin(i).name == '.');
    date_gnss = direc_gnss_bin(i).name(ind_gnss(3)+1:ind_gnss(4)-1); % string
    % convert to matlab time
    date_gnss_mat(i) = datenum(str2num(date_gnss(1:4)),str2num(date_gnss(5:6)),str2num(date_gnss(7:8)),0,0,0);
end

ind_imu = find(date_gnss_mat == idate); % These files are 30-min files - so should have atleast 24*2 files on a given day

if(~isempty(ind_imu))
%     No_samples = [];Time = [];GNSS_all = [];
    for i = 1:length(ind_imu)
        disp(['Reading the IMU/GNSS file ' num2str(i) '/' num2str(length(ind_imu))])
        filename = direc_imu_bin(ind_imu(i)).name;
        [IMU] = Read_IMU_bin([direc_buoy filename],site);
        
%         filename = direc_gnss_bin(ind_imu(i)).name;
%         [GNSS] = Read_GNSS_bin([direc_buoy filename]);
        
        % Plot the histogram of Pitch, Roll
        figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
        histogram(IMU.rpy(:,1)*180/pi,'DisplayStyle','stairs','FaceAlpha',0.5,'EdgeColor','k','LineStyle','-', 'LineWidth',2)
        hold on
        histogram(IMU.rpy(:,2)*180/pi,'DisplayStyle','stairs','FaceAlpha',0.5,'EdgeColor','r','LineStyle','-', 'LineWidth',2)
        
        set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
        'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','out',...
        'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on');
        xlabel({'$\rm Buoy\ Motion\ (deg)$'},'Interpreter','latex','FontName','Times New Roman');
        ylabel({'$\rm PDF\ $'},'Interpreter','latex','FontName','Times New Roman');
        set(gcf,'color','white')
        grid on
        roll_mean = nanmean(IMU.rpy(:,1)*180/pi);
        pitch_mean = nanmean(IMU.rpy(:,2)*180/pi);
        rlen = strcat('$\dot \theta_{roll} \ [deg, \bar \theta_{r} = ','',num2str(round(roll_mean*1000)/1000),' \ deg] $');
        plen = strcat('$\dot \theta_{pitch} \ [deg, \bar \theta_{p} = ',num2str(round(pitch_mean*1000)/1000),' \ deg] $');
        legend([ rlen, plen,""],'Interpreter','Latex','Location','Best','Orientation','vertical','EdgeColor','w','FontSize',12)
        title({['Buoy Motion Histogram at ' site ' on ' datestr(IMU.mtime(1))], ""},'Fontsize',14,'Interpreter','latex')
        
        % Save the figure
        fig_filename = [OutputDir direc_imu_bin(ind_imu(i)).name(1:end-4) '.roll.pitch.histogram.jpg'];
        saveas(gcf,fig_filename,'jpeg')
        close(gcf)
        
        
        % Plot a sample time series of Roll & Pitch - first 1 min
        
        figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
        k = length(IMU.mtime);
        plot(IMU.mtime(1:k/10),IMU.rpy(1:k/10,1)*180/pi,'r-', 'LineWidth',2)
        hold on
        plot(IMU.mtime(1:k/10),IMU.rpy(1:k/10,2)*180/pi,'k-', 'LineWidth',2)
        daterotatelabel('MM:SS',45)
        
        set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold',...
        'GridAlpha',0.1,'LineWidth',2,'MinorGridAlpha',0.2,'TickDir','in',...
        'TickLabelInterpreter','latex','XMinorTick','on','YMinorTick','on');
        xlabel({'','','$\rm UTC\ Time\ [MM:SS] $'},'Interpreter','latex','FontName','Times New Roman');
        ylabel({'$\rm Buoy\ Motion\ [deg]$'},'Interpreter','latex','FontName','Times New Roman');
        set(gcf,'color','white')
        grid on
        legend([ "$\dot \theta_{roll}$", "$\dot \theta_{pitch}$"],'Interpreter','Latex','Location','Best','Orientation','vertical','EdgeColor','w','FontSize',12)
        title({['Sample Buoy Motion at ' site ' on ' datestr(IMU.mtime(1))]},'Fontsize',14,'Interpreter','latex')
        
        disp(['Saving the IMU figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])

        % Save the figure
        fig_filename = [OutputDir direc_imu_bin(ind_imu(i)).name(1:end-4) '.roll.pitch.timeseries.jpg'];
        saveas(gcf,fig_filename,'jpeg')
        close(gcf)
        
%         % Keep sample count
%         No_samples = [No_samples length(IMU.mtime)];
%         Time = [Time IMU.mtime(1)];
%         GNSS_all = [GNSS_all [GNSS.position(1,1),GNSS.position(1,2)]];
        
        % Move the data
        if(direc_move ~= 'x')
            % Move the processed data into an Archive Folder on Lidar-buoy share drive
            direc_imu_file = [direc_buoy direc_imu_bin(ind_imu(i)).name]; % Move the 7zip files sta files
            
            movefile(direc_imu_file,[direc_move 'Lidar\']);
            direc_gnss_file = [direc_buoy direc_gnss_bin(ind_imu(i)).name]; % Move the 7zip files sta files
            movefile(direc_gnss_file,[direc_move 'Lidar\']);
            disp(['Moving the IMU file to Lidar archive ' site ' on ' datestr(idate,'yyyy/mm/dd')])
        end
        
    end % for loop
   
end % if statement


% GPS plots
% Plot the lidar data
direc_gps = dir([direc_buoy '*.gps.csv']);
warning off

% Pick the file
for i = 1:length(direc_gps)
    ind_gps = find(direc_gps(i).name == '.');
    date_gps = direc_gps(i).name(ind_gps(3)+1:ind_gps(4)-1); % string
    % convert to matlab time
    date_gps_mat(i) = datenum(str2num(date_gps(1:4)),str2num(date_gps(5:6)),str2num(date_gps(7:8)),0,0,0);
end

ind_gps = find(date_gps_mat == idate); % These files are 30-min files - so should have atleast 24*2 files on a given day

if(~isempty(ind_gps))
    disp(['Reading the GPS file from ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    filename = [direc_buoy direc_gps(ind_gps).name];
    GPS_temp = txt2mat(filename);
    GPS.Long = GPS_temp(:,8); % Wind Speed
    GPS.Lat = GPS_temp(:,7); % Wind Direction
    GPS.Datetime = datetime(GPS_temp(:,1),GPS_temp(:,2),GPS_temp(:,3),GPS_temp(:,4),GPS_temp(:,5),GPS_temp(:,6));

%     GPS = Read_GPS_AXYS(filename);
    
    % Plot the location of the buoy on USA map
    figure('Renderer', 'painters', 'Position', [100 100 1200 600],'visible','off')
    latlim = [30 42];
    lonlim = [-127 -115];
    geobubble(GPS.Lat,GPS.Long)
    geobasemap colorterrain
    geolimits(latlim,lonlim)
    set(gca,'FontName','Times New Roman','FontSize',14);
    set(gcf,'color','white')
    title({['Location of ' site ' Buoy Lidar on ' datestr(GPS.Datetime(1),'yyyy/mm/dd')]});
    
    disp(['Saving the GPS figure from ' site ' on ' datestr(idate,'yyyy/mm/dd')])

    % Save the figure
    fig_filename = [OutputDir direc_gps(ind_gps).name(1:end-4) '.map.gps.jpg'];
    saveas(gcf,fig_filename,'jpeg')
    close(gcf)
    
    % Move the data
    if(direc_move ~= 'x')
        % Move the processed data into an Archive Folder on Lidar-buoy share drive
        direc_gps_file = [direc_buoy direc_gps(ind_gps).name]; 
        movefile(direc_gps_file,[direc_move 'buoy\']);
        disp(['Moving the GPS file to Buoy archive for ' site ' on ' datestr(idate,'yyyy/mm/dd')])
    end
end
% Calculate turbulence using advaned corrections from new IMU - Later!


% Additional codes
%         ax = usamap(latlim, lonlim);
%         axis off
%         getm(gca,'MapProjection');
%         states = shaperead('usastatehi',...
%         'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
%         
%         faceColors = makesymbolspec('Polygon',...
%         {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
%         geoshow(ax,states,'SymbolSpec',faceColors);
%         
%         for k = 1:numel(states)
%             labelPointIsWithinLimits = ...
%             latlim(1) < states(k).LabelLat &&...
%             latlim(2) > states(k).LabelLat &&...
%             lonlim(1) < states(k).LabelLon &&...
%             lonlim(2) > states(k).LabelLon;
%             if labelPointIsWithinLimits
%                 textm(states(k).LabelLat,...
%                 states(k).LabelLon, states(k).Name,...
%                 'HorizontalAlignment','center')
%             end
%         end
%         
%         hold on
%         textm(GNSS.position(1,1),GNSS.position(1,2),' X Buoy Lidar ',...
%         'fontweight','bold','Rotation',270)      
