function [rtcSec,rtcMin,rtcHour,tick_sum] = rtcCategorize(rtcRawData)
       for n = 1 : 1 : length(rtcRawData)/41
            dataType(n,1)       = rtcRawData(41*n-40,1);               % dataType(1byte) == 0x00 == IMU
            
            rtcData(1,4*n-3)    = rtcRawData(41*n-39,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-2)    = 2^8 * rtcRawData(41*n-38,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-1)    = 2^8 * 2^8 * rtcRawData(41*n-37,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n)      = 2^8 * 2^8 * 2^8 * rtcRawData(41*n-36,1);               % data(14byte) -> axis x == two byte [7:0]

            rtcSecData(n,1)           = rtcData(1,4*n-3)+rtcData(1,4*n-2)+rtcData(1,4*n-1)+rtcData(1,4*n);
            rtcSecData_t= 0:1:length(rtcSecData)-1;

            rtcData(1,4*n-3)    = rtcRawData(41*n-35,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-2)    = 2^8 * rtcRawData(41*n-34,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-1)    = 2^8 * 2^8 * rtcRawData(41*n-33,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n)      = 2^8 * 2^8 * 2^8 * rtcRawData(41*n-32,1);               % data(14byte) -> axis x == two byte [7:0]

            rtcMinData(n,1)           = rtcData(1,4*n-3)+rtcData(1,4*n-2)+rtcData(1,4*n-1)+rtcData(1,4*n);
            rtcMinData_t= 0:1:length(rtcMinData)-1;
            
            rtcData(1,4*n-3)    = rtcRawData(41*n-31,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-2)    = 2^8 * rtcRawData(41*n-30,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n-1)    = 2^8 * 2^8 * rtcRawData(41*n-29,1);               % data(14byte) -> axis x == two byte [7:0]
            rtcData(1,4*n)      = 2^8 * 2^8 * 2^8 * rtcRawData(41*n-28,1);               % data(14byte) -> axis x == two byte [7:0]

            rtcHourData(n,1)           = rtcData(1,4*n-3)+rtcData(1,4*n-2)+rtcData(1,4*n-1)+rtcData(1,4*n);
            rtcHourData_t= 0:1:length(rtcHourData)-1;
                      
            tick(4*n-3,1)          = rtcRawData(41*n-3,1);                               % tick(4byte)
            tick(4*n-2,1)          = 2^8 * rtcRawData(41*n-2,1);                               % tick(4byte)
            tick(4*n-1,1)          = 2^8 * 2^8 * rtcRawData(41*n-1,1);                               % tick(4byte)
            tick(4*n,1)            = 2^8 * 2^8 * 2^8 * rtcRawData(41*n,1);                               % tick(4byte)
            tick_sum(n,1)          = tick(4*n-3,1) + tick(4*n-2,1) + tick(4*n-1,1) + tick(4*n,1);
       end
       rtcSec = [tick_sum, rtcSecData];
       rtcMin = [tick_sum, rtcMinData];
       rtcHour = [tick_sum, rtcHourData];
       
end

