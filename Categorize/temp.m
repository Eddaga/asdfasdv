function ...
[aMotorAngle, aMotorCurrent, aMotorTemp, aMotorTorque, aMotorVelocity, aMotorVoltage,...
 bMotorAngle, bMotorCurrent, bMotorTemp, bMotorTorque, bMotorVelocity, bMotorVoltage,...
 frontAVGTemp, frontCurrent, frontSOC, frontVoltage,...
 backAVGTemp, backCurrent, backSOC, backVoltage,...
 trunkAVGTemp, trunkCurrent, trunkSOC, trunkVoltage] = temp(canRawData)


    canStructureSize = 133;


    for i = 1 : 1 : length(canRawData) / canStructureSize
        % 1. 크게 분류
       [front, back, trunk, motorA, motorB, tick] = canClassify(canRawData(1+((i-1)*canStructureSize) : i*canStructureSize,1));
       % 2. 세부항목 분류 및 저장
        [frontVoltage(i,1), frontCurrent(i,1), frontSOC(i,1), frontAVGTemp(i,1)] = bmsDataClassifier(front);
        [backVoltage(i,1), backCurrent(i,1), backSOC(i,1), backAVGTemp(i,1)] = bmsDataClassifier(back);
        [trunkVoltage(i,1), trunkCurrent(i,1), trunkSOC(i,1), trunkAVGTemp(i,1)] = bmsDataClassifier(trunk);
        
        [aMotorAngle(i,1), aMotorCurrent(i,1), aMotorTemp(i,1), aMotorTorque(i,1), aMotorVelocity(i,1), aMotorVoltage(i,1)] = motorDriverclassify(motorA);
        [bMotorAngle(i,1), bMotorCurrent(i,1), bMotorTemp(i,1), bMotorTorque(i,1), bMotorVelocity(i,1), bMotorVoltage(i,1)] = motorDriverclassify(motorB);
    end

end

function [front, back, trunk, motorA, motorB, tick] = canClassify(data)
    datatype =  data(1,1);
    front =     data(2   : 17, 1);
    back =      data(18  : 33, 1);
    trunk =     data(34  : 49, 1);
    motorA =    data(50  : 89, 1);
    motorB =    data(90  : 129,1);
    tick =      data(130 : 133,1);
end

function [V,C,SOC,AVGTemp] = bmsDataClassifier(data)
    indexVolt = 0; indexCurrent = 2; indexSOC = 4; indexSOH = 5; indexPower = 6; indexAVGTemp = 14;
    tempoffset = 40;
    
    V = bmsTranslater(data,indexVolt) * 0.1;
    C = bmsTranslater(data,indexCurrent) * 0.1;
    SOC = data(1+ indexSOC) * 0.4;
    AVGTemp = data(1+ indexAVGTemp) - tempoffset;
end

function result = bmsTranslater(data,index)
    d1 = data(1 + index,1);
    d2 = hex2dec([sprintf('%d',data(2 + index,1)) '00']);
    result = d1 + d2;
end

function [angle, current, temp, torque, velocity, voltage] = motorDriverclassify(data)
    indexTemp = 0; indexAngle = 4; indexVelocity = 6; indexCurrent = 18;  indexVoltage = 20; indexTorque = 30; 

    temp = motorDriverTranslater(data,indexTemp);
    angle = motorDriverTranslater(data,indexAngle);
    velocity = motorDriverTranslater(data,indexVelocity);
    current = motorDriverTranslater(data,indexCurrent);
    voltage = motorDriverTranslater(data,indexVoltage);
    torque = motorDriverTranslater(data,indexTorque);
end

function result = motorDriverTranslater(data,index)
    d1 = data(1+index,1);
    d2 = dec2hex(data(2+index));
    d2 = hex2dec([d2 '00']);
    isMSB = bitget(d1 + d2, 16);
    unsigned2signed = int16(bitset(d1 + d2, 16, 0)) + (-2^15)* isMSB;
    result = unsigned2signed * 0.1;
end
