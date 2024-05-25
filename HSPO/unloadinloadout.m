function unlilo = unloadinloadout(caroads,X,Y)
%输入
%caroads 小车行驶路径
%X 卸货区
%Y 装货区
%输出
%unlilo 不符合重进重出的个数
X = X(:,1);
Y = Y(:,1);
unlilo = 0;
car = size(caroads,1);
for i = 1:car
    roads = caroads{i};
    if isempty(roads)
        continue
    end
    locx = ismember(roads,X);
    locy = ismember(roads,Y);
    len = size(roads,2);
    for j = 1:len
        if mod(j,2)==1&&locy(j)
            unlilo = unlilo + 1;
        elseif mod(j,2)==0&&locx(j)
            unlilo = unlilo + 1;
        end
    end
    if mod(len,2)==1
        unlilo = unlilo + 1;
    end
end
