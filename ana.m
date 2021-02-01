%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ts_coeff,cs_coeff,ret_mon,factors_a]...
    =ana(date_start,roll_window,holding_mon)

[ff25,ind47,own25,bm100,bmop25,bminv25,opinv25]=read_etf_data;

%stock_ret=ff25;
%stock_ret=ind47;
%stock_ret=own25;
%stock_ret=[ff25,ind47(:,2:48)];
%stock_ret=[ff25,ind47(:,2:48),own25(:,2:26)]; %choose different test assets

%stock_ret=bm100;
%stock_ret=bm100(:,1:21);                    %bottom 20
%stock_ret=[bm100(:,1),bm100(:,22:end)];     %top 80
%stock_ret=bm100(:,1:51);                    %bottom 50
%stock_ret=[bm100(:,1),bm100(:,52:end)];     %bottom 50

%stock_ret=bmop25;
%stock_ret=bminv25;
%stock_ret=opinv25;

%%%%%%%%%%split data half (as robustness)%%%%%%%%%
%stock_ret=ff25(1:6538,:);
%stock_ret=ff25(6287:end,:);

%stock_ret=ind47(1:6538,:);
%stock_ret=ind47(6287:end,:);

%stock_ret=own25(1:6538,:);
%stock_ret=own25(6287:end,:);

%stock_ret=[ff25(1:6538,:),ind47(1:6538,2:48)];
%stock_ret=[ff25(6287:end,:),ind47(6287:end,2:48)];

%stock_ret=[ff25(1:6538,:),ind47(1:6538,2:48),own25(1:6538,2:26)];
%stock_ret=[ff25(6287:end,:),ind47(6287:end,2:48),own25(6287:end,2:26)]; %choose different test assets

dim_ret=size(stock_ret);
factors=read_factors;
%%%%%%%%%%%%factors for split data%%%%%%%%%%%%%%%%%
%factors=factors(1:6538,:);    %%first half
%factors=factors(6287:end,:);  %%second half

[data_nm,data_str]=scan_data_struct(int32(factors(:,1)/100));
dim=size(data_nm);
for i=1:dim(1)
    if (date_start==data_nm(i,1))
        pos_i=i;
        break;
    end
end

factors_a=factors(data_str(pos_i-roll_window,1):data_str(dim(1)-1,2),2:4);%all factors used for Shanken
cs_coeff=[];
ts_coeff=[];
ret_mon=[];
for itr_pd=pos_i:holding_mon:dim(1)
    %display(itr_pd);
    factors_pr=factors(data_str(itr_pd-roll_window,1):data_str(itr_pd-1,2),2:4);
    regress_ret=stock_ret(data_str(itr_pd-roll_window,1):data_str(itr_pd-1,2),2:dim_ret(2));
    out_sampl_ret_pr=stock_ret(data_str(itr_pd,1):data_str(itr_pd+holding_mon-1,2),2:dim_ret(2))...
        -factors(data_str(itr_pd,1):data_str(itr_pd+holding_mon-1,2),4)...
        *ones(1,dim_ret(2)-1);
    
    coeff=solve_hidden_variable_v2(regress_ret,factors_pr);
    coeff_pr=[coeff(:,1),coeff(:,2).*(2*coeff(:,3)-1)*21]; %on average each month has 21 trading days
    ts_coeff_i=[ts_coeff;coeff_pr];
    ts_coeff=ts_coeff_i;
    
    out_sample_ret=gen_cul_ret(out_sampl_ret_pr);
    out_sample_mon=out_sample_ret(end,:)/holding_mon;
    %out_sample_mon=((1+out_sample_ret(end,:)/100).^(1/holding_mon)-1)*100;
    cs_coeff_pr=cross_section_reg(out_sample_mon,coeff_pr);
    ret_mon_i=[ret_mon;out_sample_mon(end,:)];
    ret_mon=ret_mon_i;
    cs_coeff_i=[cs_coeff;cs_coeff_pr];
    cs_coeff=cs_coeff_i;
end
