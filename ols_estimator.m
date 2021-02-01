%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [beta_hat,rsqr,t_stat,u_hat]=ols_estimator(X,Y)

% OLS estimation
dim=size(Y);
beta_hat = inv(X'*X)*X'*Y;                 % OLS estimation of beta
u_hat = Y - X*beta_hat;                        % estimated residual
s = (u_hat'*u_hat)/(dim(1)-1)*inv(X'*X);  % estimated covariance matrix
se = sqrt(diag(s));                      % statard errors of beta_hat
t_stat = beta_hat./se;                    % t-statistic for beta_hat
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
