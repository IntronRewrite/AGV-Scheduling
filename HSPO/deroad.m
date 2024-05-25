function caroads = deroad(Chrom,lengthx,lengthy,rowcar)
%%染色体分解小车路径
%输入
%Chrom 染色体
%lengthx 卸货区个数
%lengthy 装货区个数
%rowcar 小车数目
%输出
%caroads 小车运行路径
carindex = find(Chrom>lengthx+lengthy);%找到小车在染色体中的位置
caroads = cell(rowcar,1);%小车路径
for j = 1:rowcar%分解每个小车的路径
    if j==1 || j==rowcar
        if j==1
            thefirst = 1;
            thelast = carindex(j)-1;
        else
            thefirst = carindex(j-1)+1;
            thelast = lengthx + lengthy + rowcar - 1;
        end
    else
        thefirst = carindex(j-1)+1;
        thelast = carindex(j)-1;
    end
    if thefirst<=thelast
        caroads{j}=Chrom(thefirst:thelast);
    end
end