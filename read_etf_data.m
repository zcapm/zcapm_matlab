%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ff25,ind47,own25,bm100,bmop25,bminv25,opinv25]=read_etf_data()

filename='ff25_day_vw.xlsx';
ff25 = xlsread(filename);
ff25=ff25(1006:end,:);

filename='ind47_day_vw.xlsx';
ind47 = xlsread(filename);
ind47=ind47(1006:end,:);

filename='beta_zstar_assets.xlsx';
own25 = xlsread(filename);
own25=[own25(:,1),own25(:,2:end)*100];

filename='ff_bm_100.xlsx';
bm100 = xlsread(filename);
bm100=bm100(1006:end,:);

filename='ff_bmop_25.xlsx';
bmop25 = xlsread(filename);
bmop25=bmop25(127:end,:);

filename='ff_bminv_25.xlsx';
bminv25 = xlsread(filename);
bminv25=bminv25(127:end,:);

filename='ff_opinv_25.xlsx';
opinv25 = xlsread(filename);
opinv25=opinv25(127:end,:);

