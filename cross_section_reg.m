function coeff=cross_section_reg(assets,factors_pr)

dim=size(assets);
dim_f=size(factors_pr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  cros sectional regression  %%%%%%%%%%%%%%%%%%%
coeff=zeros(1,2*dim_f(2)+3);

X=[ones(dim(2),1),factors_pr];
Y=assets';
[beta_hat,rs,t_stat,u_hat]=ols_estimator(X,Y);

for i=1:dim_f(2)+1
    coeff(1,2*i-1)=beta_hat(i);
    coeff(1,2*i)=t_stat(i);
end
coeff(1,2*dim_f(2)+3)=rs;

