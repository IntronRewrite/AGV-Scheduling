function New = Cross(New,Cur)
%%�������
% ����
%New ����ֵ
%Cur ��ǰ����ֵ
% ���
% New �����ĸ���ֵ

[cow,rol] = size(New);
for i = 1:cow
    c1 = unidrnd(rol-1);
    c2 = unidrnd(rol-1);%��������λ
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