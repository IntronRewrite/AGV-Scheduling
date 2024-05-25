function New = Cross(New,Cur)
%%交叉操作
% 输入
%New 个体值
%Cur 当前最优值
% 输出
% New 交叉后的个体值

[cow,rol] = size(New);
for i = 1:cow
    c1 = unidrnd(rol-1);
    c2 = unidrnd(rol-1);%产生交叉位
    while c1==c2
        c1 = unidrnd(rol-1);
        c2 = unidrnd(rol-1);
    end
    st = min(c1,c2);
    ed = max(c1,c2);
    cros = Cur(i,st:ed);
    temp = setdiff(New(i,:),cros,'stable');
    temp = [temp cros];
    New(i,:) = temp;               
end