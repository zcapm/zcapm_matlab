%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coeff=solve_hidden_variable_v2(assets,mu_sigma)

dim=size(assets);
factors=mu_sigma(:,1:2);

num_factor=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  ZCAPM monthly regression  %%%%%%%%%%%%%%%%%%%
hat_pt=zeros(dim(1),1);
eta_p=zeros(dim(1),1);
eta_n=zeros(dim(1),1);
coeff=zeros(dim(2),num_factor+1);
for j=1:dim(2)
    X=factors(:,1);
    Y=assets(:,j)-mu_sigma(:,3);
    [beta_hat,rs,t_stat,u_hat]=ols_estimator(X,Y);
    Z=factors;
    for kk=1:dim(1)
        if (u_hat(kk)>=0)
            Z(kk,2)=factors(kk,2);
            hat_pt(kk,1)=1;
        else
            Z(kk,2)=-factors(kk,2);
            hat_pt(kk,1)=0;
        end
    end
    [beta_hat,rs,t_stat,u_hat]=ols_estimator(Z,Y);
    p_0=0;
    for kk=1:dim(1)
        if (hat_pt(kk,1)==1)
            p_0=p_0+hat_pt(kk,1);
        end
    end    
    p_0=p_0/dim(1);
    sigma_0=mean(u_hat(:,1).*u_hat(:,1));
    
    delta=1;    
    while (delta>0.001)
        for kk=1:dim(1)
            eta_p(kk,1)=exp(-(Y(kk,1)-beta_hat(1)*factors(kk,1)-beta_hat(2)*factors(kk,2))^2....
                /2/sigma_0);
            eta_n(kk,1)=exp(-(Y(kk,1)-beta_hat(1)*factors(kk,1)+beta_hat(2)*factors(kk,2))^2....
                /2/sigma_0);
            hat_pt(kk,1)=eta_p(kk,1)*p_0/(eta_p(kk,1)*p_0+eta_n(kk,1)*(1-p_0));
        end
        
        [beta_itr,hat_sigma,p]=solve_lineq_v2(Y,hat_pt,factors);
        
        diff=[abs((beta_itr(1)-beta_hat(1))/beta_hat(1)),abs((beta_itr(2)-beta_hat(2))/beta_hat(2)),...
            abs((p-p_0)/p_0),abs((hat_sigma-sigma_0)/sigma_0)];
        delta=max(diff);
        
        p_0=p;
        sigma_0=hat_sigma;
        beta_hat=beta_itr;
    end
    
    for i=1:num_factor
        coeff(j,i)=beta_hat(i);
    end
    coeff(j,num_factor+1)=p_0;
end
