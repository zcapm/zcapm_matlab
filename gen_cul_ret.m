%%%%%%%%%%%%%%%%%%%%
function cul_ret=gen_cul_ret(data)

dim=size(data);
cul_ret=zeros(dim(1),dim(2));
for i=1:dim(1)
    if (i>=2)
        cul_ret(i,:)=(1+data(i,:)/100).*(1+cul_ret(i-1,:))-1;
    else
        cul_ret(i,:)=data(i,:)/100;
    end
end
cul_ret=cul_ret*100;