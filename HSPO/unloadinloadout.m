function unlilo = unloadinloadout(caroads,X,Y)
%����
%caroads С����ʻ·��
%X ж����
%Y װ����
%���
%unlilo �������ؽ��س��ĸ���
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
