function [adcBreak,adcAccel,adcPitot] = adcCategorize(adcRawData)
    for n = 1 : 1 : length(adcRawData)/14
            dataType(n,1)               = adcRawData(14*n-13,1);                                        % dataType(1byte) == 0x01 == ADC
            
            adcData(1,3*n-2)            = 2^16*adcRawData(14*n-12,1);                   % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n-1)            = 2^8*adcRawData(14*n-11,1);                    % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n)              = adcRawData(14*n-10,1);                        % data(14byte) -> axis x == two byte [7:0]
            adcBreakData(n,1)                   = (adcData(1,3*n-2)+adcData(1,3*n-1)+adcData(1,3*n))*0.000000596046447754;    %adc resolution
            adcBreakData_t= 0:1:length(adcBreakData)-1;
            
            adcData(1,3*n-2)            = 2^16*adcRawData(14*n-9,1);                    % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n-1)            = 2^8*adcRawData(14*n-8,1);                     % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n)              = adcRawData(14*n-7,1);                         % data(14byte) -> axis x == two byte [7:0]
            adcAccelData(n,1)                  = (adcData(1,3*n-2)+adcData(1,3*n-1)+adcData(1,3*n))*0.000000596046447754;
            adcAccelData_t= 0:1:length(adcAccelData)-1;
            
            adcData(1,3*n-2)            = 2^16*adcRawData(14*n-6,1);                    % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n-1)            = 2^8*adcRawData(14*n-5,1);                     % data(14byte) -> axis x == two byte [7:0]
            adcData(1,3*n)              = adcRawData(14*n-4,1);               % data(14byte) -> axis x == two byte [7:0]
            adcPitotData(n,1)                  = (adcData(1,3*n-2)+adcData(1,3*n-1)+adcData(1,3*n))*0.000000596046447754;
            adcPitotData_t= 0:1:length(adcPitotData)-1;
            
            tick(4*n-3,1)               = adcRawData(14*n-3,1);                               % tick(4byte)
            tick(4*n-2,1)               = 2^8 * adcRawData(14*n-2,1);                               % tick(4byte)
            tick(4*n-1,1)               = 2^8 * 2^8 * adcRawData(14*n-1,1);                               % tick(4byte)
            tick(4*n,1)                 = 2^8 * 2^8 * 2^8 * adcRawData(14*n,1);                               % tick(4byte)
            tick_sum(n,1)               = tick(4*n-3,1) + tick(4*n-2,1) + tick(4*n-1,1) + tick(4*n,1); 
    
    end
    
    adcBreak = [tick_sum, adcBreakData];       
    adcAccel = [tick_sum, adcBreakData];       
    adcPitot = [tick_sum, adcBreakData];       
    
    
end

