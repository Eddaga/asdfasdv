function result = baroCategorize(barRawData)
   for n = 1 : 1 : length(barRawData)/13
            dataType(n,1)       = barRawData(13*n-12,1);               % dataType(1byte) == 0x05 == BAR
            
            bardata(1,4*n-3) =    barRawData(13*n-11,1);
            bardata(1,4*n-2) =    barRawData(13*n-10,1);
            bardata(1,4*n-1) =    barRawData(13*n-9,1);
            bardata(1,4*n) =    barRawData(13*n-8,1);
            bardata = uint8(bardata) ;                      %// cast them to "uint8" if they are not already
            barTempData(n,1) = typecast( [bardata(1,4*n-3) bardata(1,4*n-2) bardata(1,4*n-1) bardata(1,4*n)] , 'single') ;  %// cast the 4 bytes as a 32 bit float
            barTempData_t= 0:1:length(barTempData)-1;
             
            barData(1,4*n-3) =    barRawData(13*n-7,1);
            barData(1,4*n-2) =    barRawData(13*n-6,1);
            barData(1,4*n-1) =    barRawData(13*n-5,1);
            barData(1,4*n) =    barRawData(13*n-4,1);
            barData = uint8(barData) ;                      %// cast them to "uint8" if they are not already
            barPressData(n,1) = typecast( [barData(1,4*n-3) barData(1,4*n-2) barData(1,4*n-1) barData(1,4*n)] , 'single') ;  %// cast the 4 bytes as a 32 bit float
            barPressData_t= 0:1:length(barPressData)-1;
                        
            tick(4*n-3,1)          = barRawData(13*n-3,1);                               % tick(4byte)
            tick(4*n-2,1)          = 2^8 * barRawData(13*n-2,1);                               % tick(4byte)
            tick(4*n-1,1)          = 2^8 * 2^8 * barRawData(13*n-1,1);                               % tick(4byte)
            tick(4*n,1)            = 2^8 * 2^8 * 2^8 * barRawData(13*n,1);                               % tick(4byte)
            tick_sum(n,1)              = tick(4*n-3,1) + tick(4*n-2,1) + tick(4*n-1,1) + tick(4*n,1);
   end
   result = [tick_sum barTempData barPressData];
end

