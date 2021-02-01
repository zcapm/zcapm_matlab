%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret_mon=gen_avg_ret(ret_day,date_str)

dim_ret=size(ret_day);
dim=size(date_str);

ret_mon=zeros(dim(1),dim_ret(2));

count=0;
for i=1:dim(1)
    num=date_str(i,2)-date_str(i,1)+1;
    temp=gen_cul_ret(ret_day(count+1:count+num,:));
    ret_mon(i,:)=temp(end,:);
    count=count+num;
end

