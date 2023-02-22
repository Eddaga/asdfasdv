function [imuRawData,adcRawData,rtcRawData,canRawData,gpsRawData,barRawData] = rawDataLoad(MMDDHHmm)

fileID = fopen(strcat(MMDDHHmm,'.BIN_00.subdata'),'r');  % IMU data (00)
a00imuRawData = fread(fileID,'uint8');
imuRawData = a00imuRawData;
fclose(fileID);

fileID = fopen(strcat(MMDDHHmm,'.BIN_01.subdata'),'r');  % ADC data (01)
a01adcRawData = fread(fileID,'uint8');
adcRawData = a01adcRawData;
fclose(fileID);

fileID = fopen(strcat(MMDDHHmm,'.BIN_02.subdata'),'r');  % RTC data (02)
a02rtcRawData = fread(fileID,'uint8');
rtcRawData = a02rtcRawData;
fclose(fileID);

fileID = fopen(strcat(MMDDHHmm,'.BIN_03.subdata'),'r');  % CAN data (03)
a03canRawData = fread(fileID,'uint8');
canRawData = a03canRawData;
fclose(fileID);

fileID = fopen(strcat(MMDDHHmm,'.BIN_04.subdata'),'r');  % GPS data (04)
a04gpsRawData = fread(fileID,'uint8');
gpsRawData = a04gpsRawData;
fclose(fileID);

fileID = fopen(strcat(MMDDHHmm,'.BIN_05.subdata'),'r');  % BAR data (05)
a05barRawData = fread(fileID,'uint8');
barRawData = a05barRawData;
fclose(fileID);

end



