%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()

date_start=196501;
%date_start=199001; %%%%second half for split data

holding_unit=[1,3,6,9,12,24];

num_roll_window=[6,12]; % number of months used to estimate beta and zstar
for ii=2:2
    roll_window_mon=num_roll_window(ii);
    for j=1:1
        holding_mon=holding_unit(j);
        [ts_coeff,cs_coeff,ret_mon,factors_a]...
            =ana(date_start,roll_window_mon,holding_mon);
        dim=size(cs_coeff);
        [rsq,beta,t_stat]=get_rsq(ts_coeff,ret_mon,factors_a);
        num_para=(dim(2)-1)/2;
        results=NaN(2*num_para+1,2+1);
        for i=1:num_para
            results(i,1)=mean(cs_coeff(:,2*i-1));
            results(i,2)=results(i,1)/std(cs_coeff(:,2*i-1))*sqrt(dim(1)-1);
        end
        for jj=2:num_para    %%Shanken T
            t_lambda=results(jj,2);
            c=results(jj,1)^2/var(factors_a(:,jj-1));
            results(jj,3)=t_lambda/sqrt(1+c+var(factors_a(:,jj-1))/(dim(1)*var(cs_coeff(:,2*jj-1))));
        end
        results(num_para+1,1)=rsq;
        results(num_para+2,1:2)=[beta(1),t_stat(1)];
        results(num_para+3,1:2)=[beta(2),t_stat(2)];
        results(num_para+4,1:2)=[beta(3),t_stat(3)];
        xlswrite('results',results);
        %xlswrite('ts_coeff',ts_coeff);
        %xlswrite('cs_coeff',cs_coeff);
        %xlswrite('ret_mon',ret_mon)
    end
end


