function overweight = overwcount(caroads,X,Y,Tlast)
%%计算超重数量
%输入
%输出
wrongcountw=0;
rowcar = size(caroads,1);%AGV数目
Weightx = X(:,6);%卸箱任务点集装箱重量
Weighty = Y(:,6);%卸箱任务点集装箱重量
limit = Tlast(:,2);
X = X(:,1);
Y = Y(:,1);
for i = 1:rowcar
    roads = caroads{i};
    if isempty(roads)%判断非空
        continue
    end
    len = size(roads,2);%计算路径任务点个数
    for j = 1:len
        %计算重量影响
        if ismember(roads(j),X)%如果是卸箱任务点
            if limit(i) < Weightx(roads(j))
                wrongcountw = wrongcountw +1;
            end
        else 
            if limit(i) < Weighty(roads(j)-12)
                wrongcountw = wrongcountw +1;
            end
        end
    end
end
overweight=wrongcountw;