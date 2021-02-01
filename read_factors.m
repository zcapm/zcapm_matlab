%%%%%%%%%%%%%%%%%%%%%%%%%
function  factors=read_factors()

filename='mu_sigma.xlsx';
data1 = xlsread(filename);

filename='ff_factors_day.xlsx';
data2 = xlsread(filename);

factors=[data1(1005:end,1),data2(1006:end,2),...
    data1(1005:end,3)*100,data2(1006:end,6)];
