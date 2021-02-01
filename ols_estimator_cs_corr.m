%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [beta_hat,rsqr,t_stat,u_hat]=ols_estimator_cs_corr(X,Y,ret,coeff,factors)
dim_r=size(ret);
dim_f=size(factors);
% OLS estimation
dim=size(Y);
beta_hat = inv(X'*X)*X'*Y;                 % OLS estimation of beta
u_hat = Y - X*beta_hat;                        % estimated residual
s = (u_hat'*u_hat)/(dim(1)-1)*inv(X'*X);  % estimated covariance matrix
se = sqrt(diag(s)); 

%beta_no_cons=beta_hat(2:end,:);
%sig_f=cov(factors);
%c=beta_no_cons'*inv(sig_f)*beta_no_cons;  %%%define variables needs for Shanken
%dim_s=size(sig_f);
%sig_f_hat=zeros(dim_s(1)+1,dim_s(2)+1);
%sig_f_hat(2:end,2:end)=sig_f;

%ss=inv(X'*inv(cov(ret))*X)/dim_r(1);
ss=inv(X'*X)*X'*(cov(ret)/dim_r(1))*X*inv(X'*X); %adjust for cross-correlation
%ss=inv(X'*X)*X'*(cov(ret)/dim_r(1))*X*inv(X'*X)*(1+c)+sig_f_hat/dim_f(1);%for Shanken

sse= sqrt(diag(ss));
                     % statard errors of beta_hat
t_stat = beta_hat./sse; %beta_hat./se;                    % t-statistic for beta_hat
%p = 2*(1-tcdf(abs(t),dim(1)-1));         % P-value for the t-statistic

y_av=0;
for i=1:dim(1)
    y_av=y_av+Y(i);
end
y_av=y_av/dim(1);

err_y=0;
for i=1:dim(1)
    err_y=err_y+(Y(i)-y_av)^2;
end
rsqr=1.0-(dim(1)-1)/(dim(1)-dim(2))*(u_hat'*u_hat)/err_y;
