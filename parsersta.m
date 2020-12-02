function INFO=parsersta(filepath)
% - Get informations in a .sta .stdsta file  

%==========================================================================
% Get .sta .stdsta or .stacte file
%==========================================================================

if nargin==0
    [flpth,pth]=uigetfile({'*.sta';'*.stdsta'});
    filepath=[pth,flpth];
end



%==========================================================================
% Search informations in .sta .ctesta or .stacte file and construct INFO
%==========================================================================

%===== Read file to string and get informations contained in first lines
file_2_parse=fileread(filepath);                            % ??? to read file to string
file_2_parse=file_2_parse(1:min(100000,size(file_2_parse,2)));                     % to capture only one part (<10000)

%===== General informations
exp='HeaderSize=(.)*?\n';
txt=regexp(file_2_parse,exp,'tokens');
txt=txt{1};
INFO.HeaderSize=str2num(txt{:});

exp='ID System=(.)*?\n';
txt=regexp(file_2_parse,exp,'tokens');
txt=txt{1};
INFO.ID_System=txt{:};

exp='ID Client=(.)*?\n';
txt=regexp(file_2_parse,exp,'tokens');
txt=txt{1};
INFO.ID_Client=txt{:};

try
    exp='Location=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    txt=txt{1};
    INFO.Localisation=txt{:};
end

try
    % exp='GPS Location=(.)*?N(.)*?E';
    % txt=regexp(file_2_parse,exp,'tokens');
    exp='Long:(.)*?°'; Long=regexp(file_2_parse,exp,'tokens');
    exp='Lat:(.)*?°'; Lat=regexp(file_2_parse,exp,'tokens');
    LongLat=[str2double(Long{:}) str2double(Lat{:})];
    INFO.Longitude=LongLat(1);
    INFO.Latitude=LongLat(2);
catch
    INFO.Latitude=NaN;
    INFO.Longitude=NaN;
end

%===== Acquisition parameters
try
    exp='Pulses / Line of Sight=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.Pulses_per_LOS=str2double(txt{:});
catch
    reply=input('Nombres de Pulses /LOS non trouvé, entrez le Nomvre de pluses ', 's');
    INFO.Pulses_per_LOS=str2num(reply);
end

try
    exp='FFT Window Width=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.NFFT=str2double(txt{:});
end

try
    exp='Pulse Repetition Rate \(Hz\)=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.PRF=str2double(txt{:});
end
  
try
    exp='Pulse Duration \(s\)=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.PulseMode=str2double(txt{:})/1e-9;
end
  
try
    exp='ScanAngle \(°\)=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.ScanAngle=str2double(txt{:});
end
  
try
    exp='DirectionOffset \(°\)=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.DirectionOffset=str2double(txt{:});
end

try
    exp='Wavelength \(nm\)=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    INFO.Wavelength=str2double(txt{:})*1e-9;
catch
    INFO.Wavelength=1.55*1e-6;
end

try
    exp='CNRThreshold=(.)*?\n';
    txt=regexp(file_2_parse,exp,'tokens');
    txt=txt{1};
    INFO.CNR_Threshold=str2double(txt{:});
catch
    % reply=input('Entrez le CNR Threshold ', 's');
    % INFO.CNR_Threshold=str2num(reply);
end
    
exp='Altitudes \(m\)=\t(.)*?\n';
txt=regexp(file_2_parse,exp,'tokens');
altitudes=regexp(txt{:},'\t','split');
INFO.Range=str2double(altitudes{:});
INFO.Range=INFO.Range(~isnan(INFO.Range));              % to be removed if an improvement exist for 
                                                        % exp='Altitudes \(m\)=\t(.)*?\n';
                                                        % txt=regexp(file_2_parse,exp,'tokens');

%===== Time scale
exp='[\n]Timestamp(.)*[\n]*';
txt=regexp(file_2_parse,exp,'match');
txt=txt{:};

%===== Split columns
txts=regexp(txt,'\t','split');
txts(strcmp('',txts))=[];

%===== Get column indexs
Matches=regexpi(txts,'CNR \(dB\)');
INFO.i_CNR=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Wind Speed \(m/s\)');
INFO.i_Vh=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'Wind Direction \(°\)');
INFO.i_Dir=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Z-wind \(m/s\)');
INFO.i_W=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Z-wind Dispersion \(m/s\)');
INFO.i_stdW=find(~cellfun(@isempty,Matches));


Matches=regexpi(txts,'m Wind Speed Dispersion ');
INFO.i_stdVh=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Wind Speed min ');
INFO.i_minVh=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Wind Speed max ');
INFO.i_maxVh=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'Dopp Spect Broad');
INFO.i_Disp=find(~cellfun(@isempty,Matches));

Matches=regexpi(txts,'m Data Availability');
INFO.i_Avail=find(~cellfun(@isempty,Matches));






end





