%function [outputArg1] = canCategorize(canRawData)


fileID = fopen('00082257.BIN_03.subdata','r');  % CAN data (03)
a03canRawData = fread(fileID,'uint8');
canRawData = a03canRawData;
fclose(fileID);


% z000ReadCANdata = xlsread('can1.xlsx');
z000ReadCANdata = canRawData;

CANRow= size(z000ReadCANdata,1); % can 몇개 들어옴?

BMSsize = 21; %
Motorsize = 45; %

CANstructureSize = 133;
n = 0; motorAi = 0; motorBi = 0;
fronti = 0; backi = 0; trunki = 0;
z01Front_ = 0; z02Back_ = 0; z03Trunk_ = 0; z04MotorA_ = 0; z05MotorB_ = 0;

vars1 = {'CANstructureSize', 'motorAi', 'motorBi', 'fronti','backi', 'trunki', 't', 'i','sortline','CANRow','canswitch'};

for i=1:1:CANRow-3
    sortline = mod(i, CANstructureSize);
    if sortline == 1
        % array에 3 추가 (구분선)
        canswitch = 1;
    elseif (2 <= sortline) && (sortline <= 17) %front
        % bms에 16byte 추가
        canswitch = 2;
    elseif (18 <= sortline) && (sortline <= 33) % back
        % bms에 16byte 추가
        canswitch = 3;
    elseif (34 <= sortline) && (sortline <= 49) % trunk
        % bms에 16byte 추가
        canswitch = 4;
    elseif (50 <= sortline) && (sortline <= 89)
        % motor A에 40byte 추가
        canswitch = 5;
    elseif (90 <= sortline) && (sortline <= 129)
        % motor B에 40byte 추가
        canswitch = 6;
    elseif sortline == 130
        % array에 tick 추가
        canswitch = 7;
    elseif (131 <= sortline) && (sortline <= 133) || (sortline == 0)
        canswitch = 8;
    end
    switch canswitch
        case 1
            z001Front_BMS_Raw(n*BMSsize+1, 1) = z000ReadCANdata(i,1);
            z002Back_BMS_Raw(n*BMSsize+1, 1) = z000ReadCANdata(i,1);
            z003Trunk_BMS_Raw(n*BMSsize+1, 1) = z000ReadCANdata(i,1);
            z004Motor_A_Raw(n*Motorsize+1, 1) = z000ReadCANdata(i,1);
            z005Motor_B_Raw(n*Motorsize+1, 1) = z000ReadCANdata(i,1);
            n = n+1; fronti = fronti+1; backi = backi + 1; trunki = trunki + 1;
            motorAi = motorAi+1; motorBi = motorBi + 1;
        case 2
            z001Front_BMS_Raw((n*1)+fronti,1) = z000ReadCANdata(i,1);
            fronti = fronti + 1;
        case 3
            z002Back_BMS_Raw((n*1)+backi,1) = z000ReadCANdata(i,1);
            backi = backi + 1;
        case 4
            z003Trunk_BMS_Raw((n*1)+trunki,1) = z000ReadCANdata(i,1);
            trunki = trunki + 1;
        case 5
            z004Motor_A_Raw((n*1)+motorAi,1) = z000ReadCANdata(i,1);
            motorAi = motorAi + 1;
        case 6
            z005Motor_B_Raw((n*1)+motorBi,1) = z000ReadCANdata(i,1);
            motorBi = motorBi + 1;
        case 7
            for t= 0:1:3
                z001Front_BMS_Raw(n*BMSsize,1) = z000ReadCANdata(i+t,1);
                z002Back_BMS_Raw(n*BMSsize,1) = z000ReadCANdata(i+t,1);
                z003Trunk_BMS_Raw(n*BMSsize,1) = z000ReadCANdata(i+t,1);
                z004Motor_A_Raw(n*Motorsize, 1) = z000ReadCANdata(i+t,1);
                z005Motor_B_Raw(n*Motorsize, 1) = z000ReadCANdata(i+t,1);
            end
            fronti = fronti+3; backi = backi + 3; trunki = trunki + 3;
            motorAi = motorAi+3; motorBi = motorBi + 3;
            canswitch = 8;
        case 8
    end
end
clear(vars1{:});
Front_BMS_Row = size(z001Front_BMS_Raw,1);
% Back_BMS_Row = size(z002Back_BMS_Raw,1);
% Trunk_BMS_Row = size(z003Trunk_BMS_Raw,1);
MotorA_Row= size(z004Motor_A_Raw,1);
% MotorB_Row= size(z005Motor_B_raw,1);
n = 1;
Byte_Voltage = 1; Byte_Current1 = 2; Byte_Current2 = 3; Byte_SOC = 4; Byte_SOH = 5; Byte_power1 = 6; Byte_power2 = 7;
Byte_MAXtemp = 12; Byte_MINtemp = 13; Byte_AVGtemp = 14;
tempoffset = 40;

for i = 1:1:Front_BMS_Row-13
    a = mod(i, BMSsize);
    if a == 2
        % 조수석 bms
        voltage1 = z001Front_BMS_Raw(i,1);
        voltage2 = hex2dec([sprintf('%d', z001Front_BMS_Raw(i+Byte_Voltage,1)) '00']);
        z01Front_Voltage(n,1) = (voltage1 + voltage2) * 0.1;

        current1 = z001Front_BMS_Raw(i+Byte_Current1,1);
        current2 = hex2dec([sprintf('%d', z001Front_BMS_Raw(i+Byte_Current2,1)) '00']);
        z01Front_Current(n,1) = (current1 + current2) * 0.1;

        SOC = z001Front_BMS_Raw(i+Byte_SOC);
        z01Front_SOC(n,1) = SOC * 0.4;

        SOH = z001Front_BMS_Raw(i+Byte_SOH);
        z01Front_SOH(n,1) = SOH * 0.4;

        BAT_power1 = z001Front_BMS_Raw(i+Byte_power1,1);
        BAT_power2 = hex2dec([sprintf('%d', z001Front_BMS_Raw(i+Byte_power2,1)) '00']);
        z01Front_BATpower(n,1) = (BAT_power1 + BAT_power2) * 0.1;

        % 뒷자석 bms
        voltage1 = z002Back_BMS_Raw(i,1);
        voltage2 = hex2dec([sprintf('%d', z002Back_BMS_Raw(i+Byte_Voltage,1)) '00']);
        z02Back_Voltage(n,1) = (voltage1 + voltage2) * 0.1;

        current1 = z002Back_BMS_Raw(i+Byte_Current1,1);
        current2 = hex2dec([sprintf('%d', z002Back_BMS_Raw(i+Byte_Current2,1)) '00']);
        z02Back_Current(n,1) = (current1 + current2) * 0.1;

        SOC = z002Back_BMS_Raw(i+Byte_SOC);
        z02Back_SOC(n,1) = SOC * 0.4;

        SOH = z002Back_BMS_Raw(i+Byte_SOH);
        z02Back_SOH(n,1) = SOH * 0.4;

        BAT_power1 = z002Back_BMS_Raw(i+Byte_power1,1);
        BAT_power2 = hex2dec([sprintf('%d', z002Back_BMS_Raw(i+Byte_power2,1)) '00']);
        z02Back_BATpower(n,1) = (BAT_power1 + BAT_power2) * 0.1;

        % trunk bms
        voltage1 = z003Trunk_BMS_Raw(i,1);
        voltage2 = hex2dec([sprintf('%d', z003Trunk_BMS_Raw(i+Byte_Voltage,1)) '00']);
        z03Trunk_Voltage(n,1) = (voltage1 + voltage2) * 0.1;

        current1 = z003Trunk_BMS_Raw(i+Byte_Current1,1);
        current2 = hex2dec([sprintf('%d', z003Trunk_BMS_Raw(i+Byte_Current2,1)) '00']);
        z03Trunk_Current(n,1) = (current1 + current2) * 0.1;

        SOC = z003Trunk_BMS_Raw(i+Byte_SOC);
        z03Trunk_SOC(n,1) = SOC * 0.4;

        SOH = z003Trunk_BMS_Raw(i+Byte_SOH);
        z03Trunk_SOH(n,1) = SOH * 0.4;

        BAT_power1 = z003Trunk_BMS_Raw(i+Byte_power1,1);
        BAT_power2 = hex2dec([sprintf('%d', z003Trunk_BMS_Raw(i+Byte_power2,1)) '00']);
        z03Trunk_BATpower(n,1) = (BAT_power1 + BAT_power2) * 0.1;

        z00BMS_Voltage(n,1) = z01Front_Voltage(n,1) + z02Back_Voltage(n,1) + z03Trunk_Voltage(n,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 조수석 bms
        temp = z001Front_BMS_Raw(i+Byte_MAXtemp);
        z01Front_MAXtemp(n,1) = temp - tempoffset;

        temp = z001Front_BMS_Raw(i+Byte_MINtemp);
        z01Front_MINtemp(n,1) = temp - tempoffset;

        temp = z001Front_BMS_Raw(i+Byte_AVGtemp);
        z01Front_AVGtemp(n,1) = temp - tempoffset;

        % 뒷자석 bms
        temp = z002Back_BMS_Raw(i+Byte_MAXtemp);
        z02Back_MAXtemp(n,1) = temp - tempoffset;

        temp = z002Back_BMS_Raw(i+Byte_MINtemp);
        z02Back_MINtemp(n,1) = temp - tempoffset;

        temp = z002Back_BMS_Raw(i+Byte_AVGtemp);
        z02Back_AVGtemp(n,1) = temp - tempoffset;

        % trunk bms
        temp = z003Trunk_BMS_Raw(i+Byte_MAXtemp);
        z03Trunk_MAXtemp(n,1) = temp - tempoffset;

        temp = z003Trunk_BMS_Raw(i+Byte_MINtemp);
        z03Trunk_MINtemp(n,1) = temp - tempoffset;

        temp = z003Trunk_BMS_Raw(i+Byte_AVGtemp);
        z03Trunk_AVGtemp(n,1) = temp - tempoffset;
        n = n + 1;
    end
end

clear(vars1{:}); clear -regexp ^Byte_;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Byte_motorTemp = 1; Byte_motorAngle1 = 4; Byte_motorAngle2 = 5; Byte_motorVelocity1 = 6; Byte_motorVelocity2 = 7;
Byte_motorCurrent1 = 18;  Byte_motorCurrent2 = 19; Byte_motorVoltage1 = 20; Byte_motorVoltage2 = 21; Byte_motorTorque1 = 30; Byte_motorTorque2 = 31;

n = 1;
for i = 1:1:MotorA_Row
    a = mod(i, Motorsize);
    if a == 6
        % temp
        motortemp1 = z004Motor_A_Raw(i,1);
        motortemp2 = dec2hex(z004Motor_A_Raw(i+Byte_motorTemp));
        motortemp2 = hex2dec([motortemp2 '00']);
        isMSB = bitget(motortemp1 + motortemp2, 16);
        unsigned2signed = int16(bitset(motortemp1 + motortemp2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Temp(n,1) = unsigned2signed * 0.1;

        motortemp1 = z005Motor_B_Raw(i,1);
        motortemp2 = dec2hex(z005Motor_B_Raw(i+Byte_motorTemp));
        motortemp2 = hex2dec([motortemp2 '00']);
        isMSB = bitget(motortemp1 + motortemp2, 16);
        unsigned2signed = int16(bitset(motortemp1 + motortemp2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Temp(n,1) = unsigned2signed * 0.1;

        % angle
        motorangle1 = z004Motor_A_Raw(i+Byte_motorAngle1,1);
        motorangle2 = dec2hex(z004Motor_A_Raw(i+Byte_motorAngle2));
        motorangle2 = hex2dec([motorangle2 '00']);
        isMSB = bitget(motorangle1 + motorangle2, 16);
        unsigned2signed = int16(bitset(motorangle1 + motorangle2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Angle(n,1) = unsigned2signed * 0.1;

        motorangle1 = z005Motor_B_Raw(i+Byte_motorAngle1,1);
        motorangle2 = dec2hex(z005Motor_B_Raw(i+Byte_motorAngle2));
        motorangle2 = hex2dec([motorangle2 '00']);
        isMSB = bitget(motorangle1 + motorangle2, 16);
        unsigned2signed = int16(bitset(motortemp1 + motorangle2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Angle(n,1) = unsigned2signed * 0.1;

        % anguler velocity
        motorAngVelocity1 = z004Motor_A_Raw(i+Byte_motorVelocity1,1);
        motorAngVelocity2 = dec2hex(z004Motor_A_Raw(i+Byte_motorVelocity2));
        motorAngVelocity2 = hex2dec([motorAngVelocity2 '00']);
        isMSB = bitget(motorAngVelocity1 + motorAngVelocity2, 16);
        unsigned2signed = int16(bitset(motorAngVelocity1 + motorAngVelocity2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Velocity(n,1) = unsigned2signed * 0.1;

        motorAngVelocity1 = z005Motor_B_Raw(i+Byte_motorVelocity1,1);
        motorAngVelocity2 = dec2hex(z005Motor_B_Raw(i+Byte_motorVelocity2));
        motorAngVelocity2 = hex2dec([motorAngVelocity2 '00']);
        isMSB = bitget(motorAngVelocity1 + motorAngVelocity2, 16);
        unsigned2signed = int16(bitset(motorAngVelocity1 + motorAngVelocity2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Velocity(n,1) = unsigned2signed * 0.1;

        % current
        motorCurrent1 = z004Motor_A_Raw(i+Byte_motorCurrent1,1);
        motorCurrent2 = dec2hex(z004Motor_A_Raw(i+Byte_motorCurrent2));
        motorCurrent2 = hex2dec([motorCurrent2 '00']);
        isMSB = bitget(motorCurrent1 + motorCurrent2, 16);
        unsigned2signed = int16(bitset(motorCurrent1 + motorCurrent2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Current(n,1) = unsigned2signed * 0.1;

        motorCurrent1 = z005Motor_B_Raw(i+Byte_motorCurrent1,1);
        motorCurrent2 = dec2hex(z005Motor_B_Raw(i+Byte_motorCurrent2));
        motorCurrent2 = hex2dec([motorCurrent2 '00']);
        isMSB = bitget(motorCurrent1 + motorCurrent2, 16);
        unsigned2signed = int16(bitset(motorCurrent1 + motorCurrent2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Current(n,1) = unsigned2signed * 0.1;

        % voltage
        motorVoltage1 = z004Motor_A_Raw(i+Byte_motorVoltage1,1);
        motorVoltage2 = dec2hex(z004Motor_A_Raw(i+Byte_motorVoltage2));
        motorVoltage2 = hex2dec([motorVoltage2 '00']);
        isMSB = bitget(motorVoltage1 + motorVoltage2, 16);
        unsigned2signed = int16(bitset(motorVoltage1 + motorVoltage2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Voltage(n,1) = unsigned2signed * 0.1;

        motorVoltage1 = z005Motor_B_Raw(i+Byte_motorVoltage1,1);
        motorVoltage2 = dec2hex(z005Motor_B_Raw(i+Byte_motorVoltage2));
        motorVoltage2 = hex2dec([motorVoltage2 '00']);
        isMSB = bitget(motorVoltage1 + motorVoltage2, 16);
        unsigned2signed = int16(bitset(motorVoltage1 + motorVoltage2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Voltage(n,1) = unsigned2signed * 0.1;

        % torque
        motortorqu1 = z004Motor_A_Raw(i+Byte_motorTorque1,1);
        motortorqu2 = dec2hex(z004Motor_A_Raw(i+Byte_motorTorque2));
        motortorqu2 = hex2dec([motortorqu2 '00']);
        isMSB = bitget(motortorqu1 + motortorqu2, 16);
        unsigned2signed = int16(bitset(motortorqu1 + motortorqu2, 16, 0 )) + (-2^15)* isMSB;
        z04MotorA_Torque(n,1) = unsigned2signed * 0.1;

        motortorqu1 = z005Motor_B_Raw(i+Byte_motorTorque1,1);
        motortorqu2 = dec2hex(z005Motor_B_Raw(i+Byte_motorTorque2));
        motortorqu2 = hex2dec([motortorqu2 '00']);
        isMSB = bitget(motortorqu1 + motortorqu2, 16);
        unsigned2signed = int16(bitset(motortorqu1 + motortorqu2, 16, 0 )) + (-2^15)* isMSB;
        z05MotorB_Torque(n,1) = unsigned2signed * 0.1;

        n = n + 1;
    end
end
% figure (1)
% plot(length(z01Front_AVGtemp),z01Front_AVGtemp);

vars1 = {'tempoffset','a', 'BMSsize', 'i', 'Motorsize', 'n', 'Front_BMS_Row', 'Back_BMS_Row', 'Trunk_BMS_Row', 'MotorA_Row', 'MotorB_Row', 'voltage1', 'voltage2', 'current1', 'current2', 'SOC', 'SOH', 'temp'};
clear -regexp ^Byte_ ^motor;
clear(vars1{:});

z04MotorA_Angle    = cast(z04MotorA_Angle,"double");
z04MotorA_Current  = cast(z04MotorA_Current,"double");
z04MotorA_Temp     = cast(z04MotorA_Temp,"double");
z04MotorA_Torque   = cast(z04MotorA_Torque,"double");
z04MotorA_Velocity = cast(z04MotorA_Velocity,"double");
z04MotorA_Voltage  = cast(z04MotorA_Voltage,"double");

z05MotorB_Angle    = cast(z05MotorB_Angle,"double");
z05MotorB_Current  = cast(z05MotorB_Current,"double");
z05MotorB_Temp     = cast(z05MotorB_Temp,"double");
z05MotorB_Torque   = cast(z05MotorB_Torque,"double");
z05MotorB_Velocity = cast(z05MotorB_Velocity,"double");
z05MotorB_Voltage  = cast(z05MotorB_Voltage ,"double");

z01Front_AVGtemp_t= 0:1:length(z01Front_AVGtemp)-1;
z01Front_Current_t= 0:1:length(z01Front_Current)-1;
z01Front_SOC_t= 0:1:length(z01Front_SOC)-1;
z01Front_Voltage_t= 0:1:length(z01Front_Voltage)-1;

z02Back_AVGtemp_t= 0:1:length(z02Back_AVGtemp)-1;
z02Back_Current_t= 0:1:length(z02Back_Current)-1;
z02Back_SOC_t= 0:1:length(z02Back_SOC)-1;
z02Back_Voltage_t= 0:1:length(z02Back_Voltage)-1;

z03Trunk_AVGtemp_t= 0:1:length(z03Trunk_AVGtemp)-1;
z03Trunk_Current_t= 0:1:length(z03Trunk_Current)-1;
z03Trunk_SOC_t= 0:1:length(z03Trunk_SOC)-1;
z03Trunk_Voltage_t= 0:1:length(z03Trunk_Voltage)-1;

z04MotorA_Angle_t= 0:1:length(z04MotorA_Angle)-1;
z04MotorA_Current_t= 0:1:length(z04MotorA_Current)-1;
z04MotorA_Temp_t= 0:1:length(z04MotorA_Temp)-1;
z04MotorA_Torque_t= 0:1:length(z04MotorA_Torque)-1;
z04MotorA_Velocity_t= 0:1:length(z04MotorA_Velocity)-1;
z04MotorA_Voltage_t= 0:1:length(z04MotorA_Voltage)-1;

z05MotorB_Angle_t= 0:1:length(z05MotorB_Angle)-1;
z05MotorB_Current_t= 0:1:length(z05MotorB_Current)-1;
z05MotorB_Temp_t= 0:1:length(z05MotorB_Temp)-1;
z05MotorB_Torque_t= 0:1:length(z05MotorB_Torque)-1;
z05MotorB_Velocity_t= 0:1:length(z05MotorB_Velocity)-1;
z05MotorB_Voltage_t= 0:1:length(z05MotorB_Voltage)-1;




%end

