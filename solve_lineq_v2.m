%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hat_beta,hat_sigma,p]=solve_lineq_v2(Y,hat_pt,factors)

dim=size(Y);

a=zeros(2,2);
b=zeros(2,1);
hat_dt=2*hat_pt-1;

a(1,1)=sum(factors(:,1).*factors(:,1));
a(1,2)=sum(hat_dt(:,1).*factors(:,1).*factors(:,2));
a(2,1)=sum(hat_dt(:,1).*factors(:,1).*factors(:,2));
a(2,2)=sum(factors(:,2).*factors(:,2));

b(1,1)=sum(Y(:,1).*factors(:,1));
b(2,1)=sum(hat_dt(:,1).*Y(:,1).*factors(:,2));

hat_beta=linsolve(a,b);
p=mean(hat_pt(:,1));

sigma_t=zeros(dim(1),1);

for i=1:dim(1)
    sigma_t(i,1)=(Y(i,1)-hat_beta(1,1)*factors(i,1))^2 ...
        -2*(Y(i,1)-hat_beta(1,1)*factors(i,1))* ...
        hat_beta(2,1)*hat_dt(i,1)*factors(i,2)...
        +hat_beta(2,1)^2*factors(i,2)^2;
end
hat_sigma=mean(sigma_t(:,1));