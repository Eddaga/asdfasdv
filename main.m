function main
%% Set MMDDHHmm
MMDDHHmm = '00082257';
nameTag = ["tick", ...
           "braek", "accel", "pitot", ...
           "baroTemp", "baroPressure", ... % baro
           "aMotorAngle", "aMotorC", "aMotorTemp", "aMotorTorque", "aMotorVelocity", "aMotorV", ... % can
           "bMotorAngle", "bMotorC", "bMotorTemp", "bMotorTorque", "bMotorVelocity", "bMotorV", ... % can
           "frontAVGTemp", "frontC", "frontSOC", "frontV", ... % can
           "backAVGTemp",  "backC",  "backSOC",  "backV", ... % can
           "trunkAVGTemp", "trunkC", "trunkSOC", "trunkV", ... % can
           "latitude", "longitude", ... %gps
           "AccX", "AccY", "AccZ", "GyroX", "GyroY", "GyroZ", "TempData", ... % imu
           "sec", "min", "hour"]; % rtc

%% get RAW Data
[rawDataIMU,rawDataADC,rawDataRTC,rawDataCAN,rawDataGPS,rawDataBAR] = rawDataLoad(MMDDHHmm); % get all raw datas.

%% Categorize
cgdADCdata  = adcCategorize(rawDataADC);
cgdBARdata  = baroCategorize(rawDataBAR);
cgdCANdata  = canCategorize(rawDataCAN);
cgdGPSdata  = gpsCategorize(rawDataGPS);
cgdIMUdata  = imuCategorize(rawDataIMU);
cgdRTCdata  = rtcCategorize(rawDataRTC);

%% Errorclear



%% Interpolation
ipdData = interpolation(cgdADCdata, cgdBARdata, cgdCANdata, cgdGPSdata, cgdIMUdata, cgdRTCdata);

%% Plotting
ipdPlot(ipdData,nameTag);

%% Data out
dataOut(ipdData,nameTag,MMDDHHmm);
end