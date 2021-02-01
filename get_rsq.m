%%%%%%%%%%%%%%%%%%%%%%%%
function [rsq,beta_hat,t_stat]=get_rsq(coeff,ret_mon,factors_a)

mean_ret=mean(ret_mon);
dim=size(ret_mon);
dim_cff=size(coeff);

mean_cff=zeros(dim(2),dim_cff(2));

for j=1:dim_cff(2)
    for i=1:dim(1)
        mean_cff(:,j)=mean_cff(:,j)+coeff((i-1)*dim(2)+1:i*dim(2),j);
    end
end

mean_cff=mean_cff/dim(1);

X=[ones(dim(2),1),mean_cff];
Y=mean_ret';
factors=factors_a(:,1:2);

%[beta_hat,rs,t_stat,u_hat]=ols_estimator(X,Y);

[beta_hat,rs,t_stat,u_hat]=ols_estimator_cs_corr(X,Y,ret_mon,coeff,factors);

rsq=rs;
