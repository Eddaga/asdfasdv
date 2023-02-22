function [gpsLat,gpsLong] = gpsCategorize(gpsRawData)
 for n = 1 : 1 : length(gpsRawData)/13
            dataType(n,1)       = gpsRawData(13*n-12,1);               % dataType(1byte) == 0x04 == GPS
            
            gpsLatData(1,4*n-3) =    gpsRawData(13*n-11,1);
            gpsLatData(1,4*n-2) =    gpsRawData(13*n-10,1);
            gpsLatData(1,4*n-1) =    gpsRawData(13*n-9,1);
            gpsLatData(1,4*n) =    gpsRawData(13*n-8,1);
            gpsLatData = uint8(gpsLatData) ;                      %// cast them to "uint8" if they are not already
            gpsLatitudeData(n,1) = typecast( [gpsLatData(1,4*n-3) gpsLatData(1,4*n-2) gpsLatData(1,4*n-1) gpsLatData(1,4*n)] , 'single') ;  %// cast the 4 bytes as a 32 bit float
            gpsLatitudeData(n,1) = floor(gpsLatitudeData(n,1) / 100) + mod((gpsLatitudeData(n,1) / 100),1)*100/60  ; % Right calculation but resolution is bad
            gpsLatitudeData_t= 0:1:length(gpsLatitudeData)-1;
             
            gpsLotData(1,4*n-3) =    gpsRawData(13*n-7,1);
            gpsLotData(1,4*n-2) =    gpsRawData(13*n-6,1);
            gpsLotData(1,4*n-1) =    gpsRawData(13*n-5,1);
            gpsLotData(1,4*n) =    gpsRawData(13*n-4,1);
            gpsLotData = uint8(gpsLotData) ;                      %// cast them to "uint8" if they are not already
            gpsLongitudeData(n,1) = typecast( [gpsLotData(1,4*n-3) gpsLotData(1,4*n-2) gpsLotData(1,4*n-1) gpsLotData(1,4*n)] , 'single') ;  %// cast the 4 bytes as a 32 bit float
            gpsLongitudeData(n,1) = floor(gpsLongitudeData(n,1) / 100) + mod((gpsLongitudeData(n,1) / 100),1)*100/60  ;
            gpsLongitudeData_t= 0:1:length(gpsLongitudeData)-1;
            
            tick(4*n-3,1)          = gpsRawData(13*n-3,1);                               % tick(4byte)
            tick(4*n-2,1)          = 2^8 * gpsRawData(13*n-2,1);                               % tick(4byte)
            tick(4*n-1,1)          = 2^8 * 2^8 * gpsRawData(13*n-1,1);                               % tick(4byte)
            tick(4*n,1)            = 2^8 * 2^8 * 2^8 * gpsRawData(13*n,1);                               % tick(4byte)
            tick_sum(n,1)              = tick(4*n-3,1) + tick(4*n-2,1) + tick(4*n-1,1) + tick(4*n,1);
 end
        gpsLat = [tick_sum gpsLatitudeData];
        gpsLong = [tick_sum gpsLongitudeData];
end

