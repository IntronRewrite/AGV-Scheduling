function New = variation(New)
%%变异操作
[row,col] = size(New);
for i = 1:row
    c1 = unidrnd(col-1);
    c2 = unidrnd(col-1);%产生交叉位
    while c1==c2
        c1 = unidrnd(col-1);
        c2 = unidrnd(col-1);
    end
    temp = New(i,c1);
    New(i,c1) = New(i,c2);
    New(i,c2) = temp;
end