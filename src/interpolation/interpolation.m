function result = interpolation(ADC, BAR, CAN, GPS, IMU, RTC)

%% choose sampling rate
srADC = 10; srBAR = 70; srCAN = 100; srGPS = 1000; srIMU = 10; srRTC = 1000;
sr = [srADC srBAR srCAN srGPS srIMU srRTC];
chdSR = min(sr); %choosed sampling rate can changed as 1 for high resolution..;
%chdSR = 1;

%% interpolate
    %% ADC
ADCxq = 0 : chdSR : ADC(length(ADC),1);
ipdADCbreak     = interp1(ADC(:,1),ADC(:,2),ADCxq,'previous')';
ipdADCaccel     = interp1(ADC(:,1),ADC(:,3),ADCxq,'linear')';
ipdADCpitot      = interp1(ADC(:,1),ADC(:,4),ADCxq,'linear')';
    %% BAR
BARxq = 0 : chdSR : BAR(length(BAR),1);
ipdBARbaroTemp     = interp1(BAR(:,1),BAR(:,2),BARxq,'linear')';
ipdBARbaroPressure = interp1(BAR(:,1),BAR(:,3),BARxq,'linear')';
    %% CAN
CANxq = 0 : chdSR : CAN(length(CAN),1);
ipdCANaMotorAngle       = interp1(CAN(:,1),CAN(:,2),CANxq,'linear')';ipdCANaMotorCurrent     = interp1(CAN(:,1),CAN(:,3),CANxq,'linear')';ipdCANaMotorTemperature = interp1(CAN(:,1),CAN(:,4),CANxq,'linear')';
ipdCANaMotorTorque      = interp1(CAN(:,1),CAN(:,5),CANxq,'linear')';ipdCANaMotorVelocity    = interp1(CAN(:,1),CAN(:,6),CANxq,'linear')';ipdCANaMotorVoltage     = interp1(CAN(:,1),CAN(:,7),CANxq,'linear')';
    
ipdCANbMotorAngle       = interp1(CAN(:,1),CAN(:,8),CANxq,'linear')';ipdCANbMotorCurrent     = interp1(CAN(:,1),CAN(:,9),CANxq,'linear')';ipdCANbMotorTemperature = interp1(CAN(:,1),CAN(:,10),CANxq,'linear')';
ipdCANbMotorTorque      = interp1(CAN(:,1),CAN(:,11),CANxq,'linear')';ipdCANbMotorVelocity    = interp1(CAN(:,1),CAN(:,12),CANxq,'linear')';ipdCANbMotorVoltage     = interp1(CAN(:,1),CAN(:,13),CANxq,'linear')';

ipdCANfrontAVGTemp      = interp1(CAN(:,1),CAN(:,14),CANxq,'linear')';ipdCANfrontCurrent      = interp1(CAN(:,1),CAN(:,15),CANxq,'linear')';ipdCANfrontSOC          = interp1(CAN(:,1),CAN(:,16),CANxq,'linear')';ipdCANfrontVoltage      = interp1(CAN(:,1),CAN(:,17),CANxq,'linear')';
ipdCANbackAVGTemp       = interp1(CAN(:,1),CAN(:,18),CANxq,'linear')';ipdCANbackCurrent       = interp1(CAN(:,1),CAN(:,19),CANxq,'linear')';ipdCANbackSOC           = interp1(CAN(:,1),CAN(:,20),CANxq,'linear')';ipdCANbackVoltage       = interp1(CAN(:,1),CAN(:,21),CANxq,'linear')';
ipdCANtrunkAVGTemp      = interp1(CAN(:,1),CAN(:,22),CANxq,'linear')';ipdCANtrunkCurrent      = interp1(CAN(:,1),CAN(:,23),CANxq,'linear')';ipdCANtrunkSOC          = interp1(CAN(:,1),CAN(:,24),CANxq,'linear')';ipdCANtrunkVoltage      = interp1(CAN(:,1),CAN(:,25),CANxq,'linear')';
    %% GPS
GPSxq = 0 : chdSR : GPS(length(GPS),1);
ipdGPSLattitude = interp1(GPS(:,1),GPS(:,2),GPSxq,'linear')';
ipdGPSLongitude = interp1(GPS(:,1),GPS(:,3),GPSxq,'linear')';
    %% IMU
IMUxq = 0 : chdSR : IMU(length(IMU),1);
ipdIMUAccX  = interp1(IMU(:,1),IMU(:,2),IMUxq,'linear')';
ipdIMUAccY  = interp1(IMU(:,1),IMU(:,3),IMUxq,'linear')';
ipdIMUAccZ  = interp1(IMU(:,1),IMU(:,4),IMUxq,'linear')';
ipdIMUGyroX = interp1(IMU(:,1),IMU(:,5),IMUxq,'linear')';
ipdIMUGyroY = interp1(IMU(:,1),IMU(:,6),IMUxq,'linear')';
ipdIMUGyroZ = interp1(IMU(:,1),IMU(:,7),IMUxq,'linear')';
ipdIMUTemp  = interp1(IMU(:,1),IMU(:,8),IMUxq,'linear')';
    %% RTC
RTCxq = 0 : chdSR : RTC(length(RTC),1);
ipdRTCsec  = interp1(RTC(:,1),RTC(:,2),RTCxq,'linear')';
ipdRTCmin  = interp1(RTC(:,1),RTC(:,3),RTCxq,'linear')';
ipdRTChour = interp1(RTC(:,1),RTC(:,4),RTCxq,'linear')';

%% DataCat and return
mintick = min( [max(ADCxq) max(BARxq) max(CANxq) max(GPSxq) max(IMUxq) max(RTCxq) ] );
ipdTick = 0 : chdSR : mintick;

result = [ipdTick' ...
          ipdADCbreak(1:(mintick/chdSR)+1,1) ipdADCaccel(1:(mintick/chdSR)+1,1) ipdADCpitot(1:(mintick/chdSR)+1,1) ...
          ipdBARbaroTemp(1:(mintick/chdSR)+1,1) ipdBARbaroPressure(1:(mintick/chdSR)+1,1) ...
          ...
          ipdCANaMotorAngle(1:(mintick/chdSR)+1,1) ipdCANaMotorCurrent(1:(mintick/chdSR)+1,1) ipdCANaMotorTemperature(1:(mintick/chdSR)+1,1) ...
          ipdCANaMotorTorque(1:(mintick/chdSR)+1,1) ipdCANaMotorVelocity(1:(mintick/chdSR)+1,1) ipdCANaMotorVoltage(1:(mintick/chdSR)+1,1) ...
          ...
          ipdCANbMotorAngle(1:(mintick/chdSR)+1,1)  ipdCANbMotorCurrent(1:(mintick/chdSR)+1,1) ipdCANbMotorTemperature(1:(mintick/chdSR)+1,1) ...
          ipdCANbMotorTorque(1:(mintick/chdSR)+1,1) ipdCANbMotorVelocity(1:(mintick/chdSR)+1,1) ipdCANbMotorVoltage(1:(mintick/chdSR)+1,1) ... 
          ...
          ipdCANfrontAVGTemp(1:(mintick/chdSR)+1,1) ipdCANfrontCurrent(1:(mintick/chdSR)+1,1) ipdCANfrontSOC(1:(mintick/chdSR)+1,1) ipdCANfrontVoltage(1:(mintick/chdSR)+1,1) ...
          ipdCANbackAVGTemp(1:(mintick/chdSR)+1,1)  ipdCANbackCurrent(1:(mintick/chdSR)+1,1)  ipdCANbackSOC(1:(mintick/chdSR)+1,1)  ipdCANbackVoltage(1:(mintick/chdSR)+1,1) ...
          ipdCANtrunkAVGTemp(1:(mintick/chdSR)+1,1) ipdCANtrunkCurrent(1:(mintick/chdSR)+1,1) ipdCANtrunkSOC(1:(mintick/chdSR)+1,1) ipdCANtrunkVoltage(1:(mintick/chdSR)+1,1) ...
          ...
          ipdGPSLattitude(1:(mintick/chdSR)+1,1) ipdGPSLongitude(1:(mintick/chdSR)+1,1) ...
          ...
          ipdIMUAccX(1:(mintick/chdSR)+1,1) ipdIMUAccY(1:(mintick/chdSR)+1,1) ipdIMUAccZ(1:(mintick/chdSR)+1,1) ipdIMUGyroX(1:(mintick/chdSR)+1,1) ipdIMUGyroY(1:(mintick/chdSR)+1,1) ipdIMUGyroZ(1:(mintick/chdSR)+1,1) ipdIMUTemp(1:(mintick/chdSR)+1,1) ...
          ...
          ipdRTCsec(1:(mintick/chdSR)+1,1) ipdRTCmin(1:(mintick/chdSR)+1,1) ipdRTChour(1:(mintick/chdSR)+1,1) ];

end


