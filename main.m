%% Set MMDDHHmm

MMDDHHmm = '00082257';

%% get RAW Data

[imuRawData,adcRawData,rtcRawData,canRawData,gpsRawData,barRawData] = rawDataLoad(MMDDHHmm); % get all raw datas.
clear MMDDHHmm;

%% Categorize

%[accX,accY,accZ,gyroX,gyroY,gyroZ] = imuCategorize(imuRawData);
%[cbreak,accel,pitot] = adcCategorize(adcRawData);
%[SS,MM,HH] = rtcCategorize(rtcRawData);
%[latitude,longgitude] = gpsCategorize(gpsRawData);
%[baroTemp,baroPressure] = baroCategorize(barRawData);

[aMotorAngle, aMotorCurrent, aMotorTemp, aMotorTorque, aMotorVelocity, aMotorVoltage,...
 bMotorAngle, bMotorCurrent, bMotorTemp, bMotorTorque, bMotorVelocity, bMotorVoltage,...
 frontTemp, frontCurrent, frontSOC, frontVoltage,...
 backTemp, backCurrent, backSOC, backVoltgae,...
 trunkTemp, trunkCurrent, trunkSOC, trunkVoltage] = temp(canRawData);
 
 
%% Errorclear


%% Interpolation



%% Data out