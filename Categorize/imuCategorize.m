function [imuAccX,imuAccY,imuAccZ,imuGyroX,imuGyroY,imuGyroZ] = imuCategorize(imuRawData)
n = 0;
imu_accel_sensitivity = 2048;
imu_gyro_sensitivity = 16.4;

filelength = length(imuRawData);
%{
imuAccX = zeros(filelength,2);
imuAccY = zeros(filelength,2);
imuAccZ = zeros(filelength,2);
imuAccXData_t = zeros(filelength,1);
imuAccYData_t = zeros(filelength,1);
imuAccZData_t = zeros(filelength,1);

imuGyroX = zeros(filelength,2);
imuGyroY = zeros(filelength,2);
imuGyroZ = zeros(filelength,2);
imuGyroXData_t = zeros(filelength,1);
imuGyroYData_t = zeros(filelength,1);
imuGyroZData_t = zeros(filelength,1);
%}

        for n = 1 : 1 : filelength/19
%             dataType(n,1)               = imuRawData(19*n-18,1);                                        % dataType(1byte) == 0x00 == IMU
            
           %Accelerometer measurements (X, Y, Z) 
%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-17,1);                    % data(14byte) -> axis X == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-16,1);                        % data(14byte) -> axis X == two byte [7:0]
            imuAccX(n,1)            = (2^8*imuRawData(19*n-17,1)+imuRawData(19*n-16,1))/imu_accel_sensitivity;      % LSB sensitivity == 16384 LSB/g -> data / 16384
             if(imuAccX(n,1) > 32767/imu_accel_sensitivity)
                 imuAccX(n,1)       = imuAccX(n,1) - 65536/imu_accel_sensitivity;
             end
            imuAccXData_t= 0:1:length(imuAccX)-1;
                                                                                        
%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-15,1);                    % data(14byte) -> axis Y == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-14,1);                        % data(14byte) -> axis Y == two byte [7:0]
            imuAccY(n,1)            = (2^8*imuRawData(19*n-15,1)+imuRawData(19*n-14,1))/imu_accel_sensitivity;
             if(imuAccY(n,1) > 32767/imu_accel_sensitivity)
                 imuAccY(n,1)       = imuAccY(n,1) - 65536/imu_accel_sensitivity ;            
             end
             imuAccYData_t= 0:1:length(imuAccY)-1;

%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-13,1);                    % data(14byte) -> axis Z == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-12,1);                        % data(14byte) -> axis Z == two byte [7:0]
            imuAccZ(n,1)            = (2^8*imuRawData(19*n-13,1)+imuRawData(19*n-12,1))/imu_accel_sensitivity;
             if(imuAccZ(n,1) > 32767/imu_accel_sensitivity)
                 imuAccZ(n,1)       = imuAccZ(n,1) - 65536/imu_accel_sensitivity;
             end
             imuAccZData_t= 0:1:length(imuAccZ)-1;

            %Gyroscope measurements (X, Y, Z)            
%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-9,1);                    % data(14byte) -> axis X == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-8,1);                        % data(14byte) -> axis X == two byte [7:0]
            imuGyroX(n,1)           = (2^8*imuRawData(19*n-9,1)+imuRawData(19*n-8,1))/imu_gyro_sensitivity;
             if(imuGyroX(n,1) > 32767/imu_gyro_sensitivity)
                 imuGyroX(n,1)       = imuGyroX(n,1) - 65536/imu_gyro_sensitivity;
             end            
            imuGyroXData_t= 0:1:length(imuGyroX)-1;

%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-7,1);                    % data(14byte) -> axis Y == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-6,1);                        % data(14byte) -> axis Y == two byte [7:0]
            imuGyroY(n,1)           = (2^8*imuRawData(19*n-7,1)+imuRawData(19*n-6,1))/imu_gyro_sensitivity;
             if(imuGyroY(n,1) > 32767/imu_gyro_sensitivity)
                 imuGyroY(n,1)       = imuGyroY(n,1) - 65536/imu_gyro_sensitivity;
             end            
            imuGyroYData_t= 0:1:length(imuGyroY)-1;

%             imuData(1,2*n-1)            = 2^8*imuRawData(19*n-5,1);                    % data(14byte) -> axis Z == two byte [15:8]
%             imuData(1,2*n)              = imuRawData(19*n-4,1);                        % data(14byte) -> axis Z == two byte [7:0]
            imuGyroZ(n,1)           = (2^8*imuRawData(19*n-5,1)+imuRawData(19*n-4,1))/imu_gyro_sensitivity;
             if(imuGyroZ(n,1) > 32767/imu_gyro_sensitivity)
                 imuGyroZ(n,1)       = imuGyroZ(n,1) - 65536/imu_gyro_sensitivity;
             end            
            imuGyroZData_t= 0:1:length(imuGyroZ)-1;

%             imuData(1,2*n-1)        = 2^8*imuRawData(19*n-11,1);
%             imuData(1,2*n)          = imuRawData(19*n-10,1);
           
            imuTempData(n,1)                   = (2^8*imuRawData(19*n-11,1)+imuRawData(19*n-10,1));
            if imuTempData(n,1) > 2^15
                imuTempData(n,1)               = imuTempData(n,1) - 2^16;              % mpu6050 temp is signed value
            end
            
            imuTempData(n,1)                   = imuTempData(n,1)/340 +36.53;
            imuTempData_t= 0:1:length(imuTempData)-1;
            
             tick(4*n-3,1)               = imuRawData(19*n-3,1);                                                             % tick(4byte)
             tick(4*n-2,1)               = 2^8 * imuRawData(19*n-2,1);                                                       % tick(4byte)
             tick(4*n-1,1)               = 2^8 * 2^8 * imuRawData(19*n-1,1);                                                 % tick(4byte)
             tick(4*n,1)                 = 2^8 * 2^8 * 2^8 * imuRawData(19*n,1);                                             % tick(4byte)
            tick_sum(n,1)               = 2^8 * 2^8 * 2^8 * imuRawData(19*n,1) +2^8 * 2^8 * imuRawData(19*n-1,1) +2^8 * imuRawData(19*n-2,1) +imuRawData(19*n-3,1);
        end
    %{
    imuAccXData_t = imuAccXData_t';
    imuAccYData_t = imuAccYData_t';
    imuAccZData_t = imuAccZData_t';
    imuGyroXData_t = imuGyroXData_t';
    imuGyroYData_t = imuGyroYData_t';
    imuGyroZData_t = imuGyroZData_t';
    %}
    imuAccX = [tick_sum, imuAccX];
    imuAccY = [tick_sum, imuAccY];
    imuAccZ = [tick_sum, imuAccZ];
    
    imuGyroX = [tick_sum, imuGyroX];
    imuGyroY = [tick_sum, imuGyroY];
    imuGyroZ = [tick_sum, imuGyroZ];
end

