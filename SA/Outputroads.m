function caroads = Outputroads(Chrom,X,Y,Map,Tlast)
%% ���С��·��
%����
%Chrom ����
%X ж�������
%Y װ�������
%Map ӳ�����
%Tlast С������ﵽʱ��
%���
%caroads С��·��

lengthx = size(X,1);%ж������Ŀ
lengthy = size(Y,1);%װ������Ŀ
cars = size(Tlast,1);%С����Ŀ
X = X(:,1);%ȡж�������
Y = Y(:,1);%ȡװ�������
Map = Map(:,1);%ȡӳ�������
caroads = deroad(Chrom,lengthx,lengthy,cars);
for i = 1:cars
    if isempty(caroads{i})
        disp(['��',num2str(i),'����δ���伯װ��'])
        continue
    end
    p=['��',num2str(i),'��������·��Ϊ��1'];
    roads = caroads{i};
    len = size(roads,2);%��������г���
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
