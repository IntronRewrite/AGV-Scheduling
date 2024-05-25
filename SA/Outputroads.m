function caroads = Outputroads(Chrom,X,Y,Map,Tlast)
%% 输出小车路径
%输入
%Chrom 个体
%X 卸箱任务点
%Y 装箱任务点
%Map 映射矩阵
%Tlast 小车最晚达到时间
%输出
%caroads 小车路径

lengthx = size(X,1);%卸箱区数目
lengthy = size(Y,1);%装箱区数目
cars = size(Tlast,1);%小车数目
X = X(:,1);%取卸箱任务点
Y = Y(:,1);%取装箱任务点
Map = Map(:,1);%取映射任务点
caroads = deroad(Chrom,lengthx,lengthy,cars);
for i = 1:cars
    if isempty(caroads{i})
        disp(['第',num2str(i),'辆车未运输集装箱'])
        continue
    end
    p=['第',num2str(i),'辆车运输路径为：1'];
    roads = caroads{i};
    len = size(roads,2);%任务点序列长度
    for j = 1:len
        if j~=1&&(ismember(roads(j),X)||(ismember(roads(j),Y)&&ismember(roads(j-1),Y)))
            p = [p,'->1->',num2str(Map(roads(j)))];
        else
            p =  [p,'->',num2str(Map(roads(j)))];
        end
    end
    p = [p,'->1'];
    disp(p)
end
