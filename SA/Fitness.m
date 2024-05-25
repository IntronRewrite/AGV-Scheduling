function Fit = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v)
%%������Ⱥ��Ӧ�� ���óͷ�����
%����
%Chrom ��Ⱥ
%Pos �����
%X ж������ʱ�䴰
%Y װ������ʱ�䴰
%Map ӳ�亯��
%Tlast С������ʱ��
%pa "�ؽ��س�"�ͷ�����
%pb ���ųͷ�����
%pload ���ųͷ�����
%tload װ��ʱ��
%v AGV��ʻ�ٶ�
%���
%Fit ��Ⱥ��Ӧ��
rowcar = size(Tlast,1);%agv����
rowchrom = size(Chrom,1);%Ⱦɫ����Ŀ
lengthx = size(X,1);%ж�����
lengthy = size(Y,1);%װ�����
Fit = zeros(rowchrom,7);%��Ӧ��ֵ��ʼ��

for i = 1:rowchrom
    caroads = deroad(Chrom(i,:),lengthx,lengthy,rowcar);%����ֽ����С��·��
    [runtime,wrongtime,wrongcountyl,wrongcountyr,wrongcountql,wrongcountqr] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);%������峵������ʱ�� ʱ�䴰�ͷ�ֵ �����㰶��ʱ�䴰���� �����㳡��ʱ�䴰���� 
    unlilo = unloadinloadout(caroads,X,Y);%���㲻�Ϸ��ؽ��س������
    overweight= overwcount(caroads,X,Y,Tlast);
    Fit(i,1) = runtime+wrongtime+unlilo*pf+overweight*pw;
    Fit(i,2) = wrongcountyr;
    Fit(i,3) = wrongcountqr;
    Fit(i,4) = wrongcountyl;
    Fit(i,5) = wrongcountql;
    Fit(i,6) = unlilo;
    Fit(i,7) = overweight;
end