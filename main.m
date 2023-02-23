%% Set MMDDHHmm

MMDDHHmm = '00082257';

%% get RAW Data

[rawDataIMU,rawDataADC,rawDataRTC,rawDataCAN,rawDataGPS,rawDataBAR] = rawDataLoad(MMDDHHmm); % get all raw datas.
clear MMDDHHmm;

%% Categorize

[cgdIMUdata]  = imuCategorize(rawDataIMU);
[cgdADCdata]  = adcCategorize(rawDataADC);
[cgdRTCdata]  = rtcCategorize(rawDataRTC);
[cgdGPSdata]  = gpsCategorize(rawDataGPS);
[cgdBARData]  = baroCategorize(rawDataBAR);
[cgdCANData]  = canCategorize(rawDataCAN);

%% Errorclear



%% Interpolation

ipdData = interpolation();

%% Plotting


%% Data out