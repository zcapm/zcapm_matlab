%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data_nm,data_str]=scan_data_struct(data)

dim=size(data);

data_ini=data(1,1);
data_inf=data_ini;
data_ps=zeros(1000,2);
data_ps(1,1)=1;
count=1;
for i=2:dim(1)
    if (data(i,1)~=data_ini)
        count=count+1;
        data_ps(count-1,2)=i-1;
        data_ps(count,1)=i;
        temp=[data_inf;data(i,1)];
        data_ini=data(i,1);
        data_inf=temp;
    end
end
data_ps(count,2)=dim(1);
data_str=data_ps(1:count,:);
data_nm=data_inf;