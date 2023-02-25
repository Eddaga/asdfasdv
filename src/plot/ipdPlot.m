function ipdPlot(data,nameTag)

%sec = 1000;
min = 60000;
%hour = 3600000;

for i = 2 : 1 : size(data,2)
    figure(i-1)
    plot( data(:,1)/min, data(:,i))
    title(nameTag(1,i));
end
   

